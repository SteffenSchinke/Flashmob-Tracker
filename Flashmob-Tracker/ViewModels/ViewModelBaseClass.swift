//
//  ViewModelBase.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 11.03.25.
//


import SwiftUI
import Observation


@Observable
class ViewModelBaseClass {
    
    var isWorking: Bool = true
    var errorMessage = ""
    var hasError = false
    
    func setError( _ message: String) {
        
        Task { @MainActor in
            
            let appLang: AppLocalization = .shared
            self.errorMessage = appLang.localString(message)
            self.hasError = true
            self.isWorking = false
        }
    }
    
    func setIsWorking( _ isWorking: Bool) async {
        
        Task { @MainActor in
            
            self.isWorking = isWorking
        }
    }
}
