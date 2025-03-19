//
//  SignIn.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct SignIn: ContentView {

    @Environment(AuthUserVM.self) private var authUserVM
    @State private var showErrorAlert: Bool = false
    @Bindable private var appLang: AppLocalization = .shared
    
    var localKey: String = "title_sign_in"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool {
        self.authUserVM.isWorking
    }
    var sourceViewNamespace: Namespace.ID? 
    
    var content: some View {
        
        @Bindable var authUserVM = authUserVM
        
        VStack {
            
            VStack {
                
                VStack {
                    
                    BorderTextField($authUserVM.email, "ph_email", "tip_email", .emailAddress) { authUserVM.isEmailValid() }
                    BorderSecureTextField($authUserVM.pwd, "ph_pwd", "tip_pwd") { authUserVM.isPasswordValid() }
                }
                .padding(.horizontal, 50)
                
                VStack {
                    
                    ButtonRect("btn_sign_in") {
                        
                        if authUserVM.isSignInConform() {
                            
                            authUserVM.signIn(.custom)
                        }
                    }
                    
                    ButtonRect("btn_sign_up") {
                        
                        authUserVM.resetAuthData()
                        authUserVM.authState = .inSignUp
                    }
                }
                .padding(.bottom, 40)
            }
            
            SocialMedia()
        }
        .padding(.top, 50)
        .alert(appLang.localString(authUserVM.errorMessage),
               isPresented: $authUserVM.hasError) {}
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    
    func getTrailingMenu() -> AnyView  {
        
        AnyView (
            
            Picker(selection: $appLang.selectedLanguageIndex,
                   content: {
                       ForEach(AppLanguage.allCases, id: \.id) { lng in
                           
                           Image(lng.imageName).tag(lng.id)
                       }},
                   label: { Text(appLang.localString("title_lang")) })
            .pickerStyle(.inline)
            .background(Color.clear)
            .frame(width: 80, height: 80)
            .offset(x: -12, y: 3)
        )
    }
}
