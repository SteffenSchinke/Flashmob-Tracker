//
//  FirebaseAuthentication.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import Foundation
import SwiftUI
import Observation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn


final class FirebaseAuthentification {
    
    /// Singleton pattern
    static let shared = FirebaseAuthentification()
    private init() {}
    
    private var auth = Auth.auth()
    
    
    func signOut() async throws {
        
        try auth.signOut()
    }
    
    func singInWithApple() async throws(Error) -> User {
        
        throw .notImplementet
    }
    
    func singInWithFacebook() async throws(Error) -> User {
        
        throw .notImplementet
    }
    
    func singInWithInstagram() async throws(Error) -> User {
        
        throw .notImplementet
    }
    
    func singInWithTwitter() async throws(Error) -> User {
        
        throw .notImplementet
    }
    
    func signInWithGoogle() async throws(Error) -> (User?, GIDGoogleUser?) {
        
        guard let presentingVC = await UIApplication.shared.rootViewController else {
            
            throw .viewControllerNotFound
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            
            throw .validClientIdNotFound("Google")
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        var signResult: GIDSignInResult? = nil
        do {
            
            // start the signin flow!
            signResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)
        } catch {
            
            throw .signInFailed(error.localizedDescription)
        }
        
        guard let gUser = signResult?.user else {
            
            // TODO sts 22.02.2025 - error message localize
            throw .signInFailed("err_google_user")
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: gUser.idToken?.tokenString ?? "",
                                                       accessToken: gUser.accessToken.tokenString)
        
        do {
            
            let fUser = try await auth.signIn(with: credential).user
            return (fUser, gUser)
        } catch {
            
            throw .signInFailed(error.localizedDescription)
        }
    }
    
    
    func singIn( _ email: String, _ pwd: String) async throws(Error) -> User {
        
        do {
            
            return  try await auth.signIn(withEmail: email, password: pwd).user
        } catch {
            
            throw .signInFailed(error.localizedDescription)
        }
    }
    
    func signUp( _ email: String, _ pwd: String) async throws(Error) -> User {
        
        do {
            
            return  try await auth.createUser(withEmail: email, password: pwd).user
        } catch {
            
            throw .signUpFailed(error.localizedDescription)
        }
    }
    
    func existsLoginUser() -> User? {
        
        return self.auth.currentUser
    }
    
    enum Error: LocalizedError {
        
        // TODO sts 21.02.2025 - reason's localize string
        case signOutFailed( _ reason: String)
        case signInFailed( _ reason: String)
        case signUpFailed( _ reason: String)
        case notImplementet
        case viewControllerNotFound
        case validClientIdNotFound( _ reason: String)
        
        // TODO sts 22.02.2025 - error message localize
        var errorDescription: String? {
            
            switch self {
                
                case .signOutFailed(let reason):
                        "Logout fehlgeschlagen: \(reason)"
                case .signInFailed(let reason): 
                        "Login fehlgeschlagen:  \(reason)"
                case .signUpFailed(let reason): 
                        "Registrierung fehlgeschlagen: : \(reason)"
                case .notImplementet: 
                        "err_not_implemented"
                case .viewControllerNotFound:
                        "ViewController für Google Login nicht gefunden."
                case .validClientIdNotFound(let reason):
                        "Keine gültige ClientId für die \(reason) Anmeldung gefunden."
            }
        }
    }
}
