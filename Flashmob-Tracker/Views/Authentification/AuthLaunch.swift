//
//  ContentView.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI
import Observation


struct AuthLaunch: View {
    
    @Environment(AuthUserVM.self) private var authUserVM
    
    var body: some View {
        
        ZStack {
            
            switch authUserVM.authState {
                
                case .inSignIn: SignIn()
                case .inSignUp: SignUp()
                case .inGreeting: Greeting()
                case .inLoggedIn, .refreshedLogin: EmptyView()
            }
        }
    }
}
