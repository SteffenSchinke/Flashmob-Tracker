//
//  AppLanguage.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import Foundation
import Observation


@Observable
final class AppLocalization {
    
    /// Singleton pattern
    static let shared = AppLocalization()
    private init() {
        
        let langCode = UserDefaults
            .standard
            .string(forKey: AppStorageKey.selectedLanguage.key) ?? "de"
        self.selectedLanguage = AppLanguage(langCode)
    }
    
    var selectedLanguageIndex: Int {
        
        get { AppLanguage.allCases.firstIndex(of: self.selectedLanguage)! }
        set { self.selectedLanguage = AppLanguage.allCases[newValue] }
    }
    var selectedLanguage: AppLanguage {
        
        didSet { UserDefaults.standard.set(
                    self.selectedLanguage.localCode,
                    forKey: AppStorageKey.selectedLanguage.key)}
    }
    
    
    func localString( _ key: String) -> String {
        
        guard let path = Bundle.main.path(
                            forResource: self.selectedLanguage.localCode,
                            ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            
            return key
        }
        
        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}
    
