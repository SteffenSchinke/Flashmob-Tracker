//
//  LoginState.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


enum AuthState: Int {
    
    case inSignIn
    case inSignUp
    case inGreeting
    case inLoggedIn
    case refreshedLogin
}
