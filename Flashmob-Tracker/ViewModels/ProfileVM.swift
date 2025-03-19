//
//  ProfileVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.03.25.
//



import SwiftUI
import Observation
import FirebaseAuth
import GoogleSignIn
import CryptoKit
import MapKit


@Observable
final class ProfileVM: ViewModelBaseClass {
    
    private var authUserVM: AuthUserVM?
    
    override var isWorking: Bool {
        get { authUserVM?.isWorking ?? false }
        set { }
    }
    
    override init() {
        
        super.init()
        self.isWorking = false
    }
    
    func setAuthUserVM(_ authUserVM: AuthUserVM) {
        
        self.authUserVM = authUserVM
    }
}
