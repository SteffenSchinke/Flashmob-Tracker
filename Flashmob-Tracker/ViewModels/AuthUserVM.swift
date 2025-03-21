//
//  AppUserVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI
import Observation
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import MapKit


@Observable
final class AuthUserVM: ViewModelBaseClass {
    
    var authUser: AppUser = .init() {
        didSet {
            
            if authUser.id != oldValue.id {
                
                let favSV: Favorites = .shared
                favSV.startObserver(self.authUser.id)
            }
        }
    }
    
    var authState: AuthState = .inSignIn
    var companyName: String = "BeatBox GmbH"
    var firstName: String = "Paul"
    var lastName: String = "Newman"
    var email: String = "paul.newman@gmx.de"
    var pwd: String = "Hannibal04!"
    var pwd2: String = "Hannibal04!"
    var location: FlashmobLocation?
    var isAcceptedAGB: Bool = false
    var userRule: AppUserRule = .guest
    
    private var authService: FirebaseAuthentification = .shared
    private var repo: Repository = AppUserFirebase()
    
    var isPreviewRunning: Bool {
        ProcessInfo
            .processInfo
            .environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    
    override init() {
        
        super.init()
        
        Task {
            
            await setIsWorking(true)
            
            guard let user = self.authService.existsLoginUser() else {
                
                await setIsWorking(false)
                return
            }
            
            do {
                
                self.authUser = try await repo.fetch(AppUser.self, user.uid)
                self.authState = .inLoggedIn
                
                // auth flashmob store & jwt ist avilable
                let store: FlashmobStore = .shared
                try await store.authService(self.authUser.email!, self.authUser.storePwd!)
                
                // location set
                CLLocationCoordinate2D.home =
                        CLLocationCoordinate2D(
                            latitude: self.authUser.location?.latitude ?? 0,
                            longitude: self.authUser.location?.longitude ?? 0)
                
            } catch {
                
                await setIsWorking(false)
                self.signOut()
            }
            
            //await setIsWorking(false)
        }
    }
    
    func signIn( _ authOption: AuthOption) {
        
        Task {
            
            await setIsWorking(true)
            
            let store: FlashmobStore = .shared
            
            do {
                
                var fireUser: User?
                
                switch authOption {
                    
                    case .custom:
                    
                        try await fireUser = authService.singIn(self.email, self.pwd)
                    case .apple:
                    
                        try await fireUser = authService.singInWithApple()
                    case .google:
                    
                        guard !self.isPreviewRunning else {
                            
                            self.setError("tip_auth_google")
                            return
                        }
                    
                        if case let (fUser?, gUser?) = try await authService.signInWithGoogle(),
                           let gProfile = gUser.profile {
                                
                            do {
                                
                                // check exists google user as auth id
                                if let socialUser = try await self.loadSocialeUser(fUser.uid) {
                                    
                                    self.resetAuthData()
                                    
                                    self.authUser = socialUser
                                    self.authState = .inLoggedIn
                                } else {
                                    
                                    var newUser: AppUser = .init(fUser.uid)
                                    
                                    // TODO sts 25.02.25 - is followed sigin, check of user email!
                                    let hashed = SHA256.hash(data: Data("GooglePWD2025!".utf8))
                                    let pwdDecoded = hashed.compactMap { String(format: "%02x", $0) }.joined()
                                    
                                    newUser.firstName = gProfile.givenName
                                    newUser.lastName = gProfile.familyName
                                    newUser.email = gProfile.email
                                    newUser.storePwd = pwdDecoded
                                    
                                    // TODO sts 25.02.25 - is followed sigin, check of user email and no register
                                    try await store.registerService(newUser.firstName!,
                                                                    newUser.lastName!,
                                                                    "",
                                                                    newUser.email!,
                                                                    newUser.storePwd!,
                                                                    newUser.id)
                                    
                                    if let imgUrl = gProfile.imageURL(withDimension: 180) {
                                        
                                        var newImg = await FlashmobStoreFile(fUser.uid, imgUrl)
                                        newImg.source = .sozialMedia
                                        newUser.profileImage = newImg
                                    }
                                    
                                    try repo.insert(newUser)
                                    self.authUser = newUser
                                    self.authState = .inLoggedIn
                                }
                            } catch {
                                
                                setError(error.localizedDescription)
                            }
                        }
                    case .facebook:
                    
                        try await fireUser = authService.singInWithFacebook()
                    case .twitter:
                    
                        try await fireUser = authService.singInWithTwitter()
                    case .instagram:
                    
                        try await fireUser = authService.singInWithInstagram()
                }
                
                if fireUser != nil && authOption != .google {
                    
                    self.authUser = try await repo.fetch(AppUser.self, fireUser!.uid)
                    self.authState = .inLoggedIn
                    
                    // auth flashmob store & jwt ist avilable
                    try await store.authService(self.authUser.email!, self.authUser.storePwd!)
                    
                    // location set
                    CLLocationCoordinate2D.home =
                            CLLocationCoordinate2D(
                                latitude: self.authUser.location?.latitude ?? 0,
                                longitude: self.authUser.location?.longitude ?? 0)
                }
                
            } catch let error as LocalizedError {
                
                self.setError(error.errorDescription ?? "err_unknow")
            }
            
            await setIsWorking(false)
        }
    }
    
    func signUp() {
        
        Task {
            
            await setIsWorking(true)
            
            do {
                
                let user = try await self.authService.signUp(self.email, self.pwd)
                var appUser = AppUser(user.uid)
                
                // decode pwd
                let hashed = SHA256.hash(data: Data(pwd.utf8))
                let pwdDecoded = hashed.compactMap { String(format: "%02x", $0) }.joined()
                
                appUser.userRule = self.userRule
                appUser.email = self.email
                appUser.storePwd = pwdDecoded
                
                appUser.firstName = self.firstName
                appUser.lastName = self.lastName
                appUser.location = self.location
                if self.userRule == .organizer {
                    
                    appUser.companyName = self.companyName
                }
                
                try repo.insert(appUser)
                
                // user in flashmob stor register & jwt is avilable
                let store: FlashmobStore = .shared
                try await store.registerService(self.firstName,
                                                self.lastName,
                                                self.companyName,
                                                self.email,
                                                pwdDecoded,
                                                appUser.id)
                
                //  has profile image & changed
                if self.authUser.profileImage.isChanged,
                   let data = self.authUser.profileImage.fileData {
                    
                    let newProfileImage = try await store.uploadFile(
                        data, FlashmobStoreKey.profileImage.key)
                    appUser.profileImage = newProfileImage
                    try await repo.update(appUser)
                }
                
                self.authUser = appUser
                self.resetAuthData()
                self.authState = .inGreeting
                
                // location set
                CLLocationCoordinate2D.home =
                        CLLocationCoordinate2D(
                            latitude: self.location?.latitude ?? 0,
                            longitude: self.location?.longitude ?? 0)
                
                self.isWorking = false
                
            }catch let error as LocalizedError {
                
                setError(error.errorDescription ?? "err_unknow")
                await setIsWorking(false)
            } catch {
                
                setError(error.localizedDescription)
                await setIsWorking(false)
            }
        }
    }
    
    func signOut() {
        
        Task { 
            
            await setIsWorking(true)
            
            do {
                
                try await self.authService.signOut()
                
                // TODO sts 23.02.25 - flashmob stor signout, jwt token deactiveted
                
                self.authUser = AppUser()
                self.authState = .inSignIn
            } catch {
                
                setError(error.localizedDescription)
            }
            
            await setIsWorking(false)
        }
    }
    
    func updateAuthUser() async {
        
        await setIsWorking(true)
        
        do {
            
            try await Task.sleep(for: .seconds(5))
            
            var user = self.authUser
            
            user.location = self.location
            if user.profileImage.isChanged {
                
                let imageStore: FlashmobStore = .shared
                let newImage = try await imageStore.uploadFile(
                    user.profileImage.fileData!,
                    FlashmobStoreKey.profileImage.key)
                
                user.profileImage = newImage
            }
            
            // update firebase auth pwd
            try await self.changePassword(self.pwd)
            
            let repo = AppUserFirebase()
            try await repo.update(user)
            
            self.authState = .refreshedLogin
            self.authUser = user
        } catch {
            
            setError(error.localizedDescription)
        }
        
        await setIsWorking(false)
    }
    
    func uploadProfileImage() {
        
        Task {
            
            await setIsWorking(true)
            
            do {
                
                var user = self.authUser
                
                if let data = user.profileImage.fileData {
                    
                    let store: FlashmobStore = .shared
                    let newProfileImage =
                            try await store.uploadFile(
                                    data,FlashmobStoreKey.profileImage.key)
                    
                    user.profileImage = newProfileImage
                    self.authUser = user
                } else {
                    
                    self.setError("conf_error")
                }
            } catch {
                
                self.setError(error.localizedDescription)
            }
            
            await setIsWorking(false)
        }
    }
    
    func isCompanyNameValid() -> Bool {
        
        RegExpNotation.company.checkValue(self.companyName)
    }
    
    func isFirstNameValid() -> Bool {
        
        RegExpNotation.name.checkValue(self.firstName)
    }
    
    func isLastNameValid() -> Bool {
        
        RegExpNotation.name.checkValue(self.lastName)
    }
    
    func isEmailValid() -> Bool {
        
        RegExpNotation.email.checkValue(self.email)
    }
    
    func isPasswordValid() -> Bool {
        
        RegExpNotation.password.checkValue(self.pwd)
    }
    
    func isPasswordConform() -> Bool { return self.pwd == self.pwd2 }
    
    func isSignInConform() -> Bool {
        
        guard self.isEmailValid() else {
            self.setError("conf_email")
            return false
        }
        
        guard self.isPasswordValid() else {
            self.setError("conf_pwd")
            return false
        }
        
        return true
    }
    
    func isProfileConform() -> Bool {
        
        guard self.location != nil else {
            self.setError("conf_location")
            return false
        }
        
        guard self.isPasswordValid() else {
            self.setError("conf_pwd")
            return false
        }
        
        guard self.isPasswordConform() else {
            self.setError("conf_pwd_conform")
            return false
        }
        
        // TODO sts 10.03.25 - implements
        return true
    }
    
    func isSignUpConform() -> Bool {
        
        if self.userRule == .organizer {
            
            guard self.isCompanyNameValid() else {
                self.setError("conf_company_name")
                return false
            }
        }
        
        guard self.isFirstNameValid() else {
            self.setError("conf_first_name")
            return false
        }
        
        guard self.isLastNameValid() else {
            self.setError("conf_last_name")
            return false
        }
        
        guard self.location != nil else {
            self.setError("conf_location")
            return false
        }
        
        guard self.isEmailValid() else {
            self.setError("conf_email")
            return false
        }
        
        guard self.isPasswordValid() else {
            self.setError("conf_pwd")
            return false
        }
        
        guard self.isPasswordConform() else {
            self.setError("conf_pwd_conform")
            return false
        }
        
        guard isAcceptedAGB else {
            self.setError("conf_agb")
            return false
        }
        
        return true
    }
    
    func resetAuthData() {

#if !DEBUG
        self.email = ""
        self.pwd = ""
        self.pwd2 = ""
        self.firstName = ""
        self.lastName = ""
        self.companyName = ""
#endif
    }
    
    private func loadSocialeUser( _ appUserId: String) async throws -> AppUser? {
        
        do {
            
            return try await repo.fetch(AppUser.self, appUserId)
        } catch {
            
            return nil
        }
    }
    
    private func changePassword( _ newPWD: String) async throws(Error) {
        
        guard let user = Auth.auth().currentUser else {
            
            throw .failedUser
        }
        
        do {
            
            // refresh firebase auth
            let credential = EmailAuthProvider.credential(
                                withEmail: self.email,
                                password: self.pwd)
            let secretUserAuth = try await user.reauthenticate(with: credential)
            
            try await secretUserAuth.user.updatePassword(to: newPWD)
        } catch {
            
            throw .failedSetPWD(error.localizedDescription)
        }
    }
    
    enum Error: LocalizedError {
        
        // TODO sts 18.02.2025 - error message locate
        case failedUser
        case failedSetPWD( _ reason: String)
        
        var errorDescription: String? {
            
            switch self {
                
                case .failedUser: "Auth user failed"
                case .failedSetPWD(let reason): "Failed set new password: \(reason)"
            }
        }
    }
}
