//
//  Language.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


enum AppLanguage: Int, CaseIterable, Identifiable {
    
    case de, fr, en, us, jp, ch
    
    var id: Int { self.rawValue }
    
    var localCode: String {
        
        switch self {
            
            case .de: "de"
            case .us: "en-US"
            case .fr: "fr"
            case .en: "en-GB"
            case .jp: "ja"
            case .ch: "zh-Hans"
        }
    }
    
    var localKey: String {
        
        switch self {
            
            case .ch: "lng_ch"
            case .de: "lng_de"
            case .en: "lng_en"
            case .fr: "lng_fr"
            case .jp: "lng_jp"
            case .us: "lng_us"
        }
    }
    
    var imageName: String {
        
        switch self {
            
            case .ch: "CountryFlags/ch"
            case .de: "CountryFlags/de"
            case .en: "CountryFlags/en"
            case .fr: "CountryFlags/fr"
            case .jp: "CountryFlags/jp"
            case .us: "CountryFlags/us"
        }
    }
    
    init( _ localCode: String) {
        
        switch localCode {
            
            case "zh-Hans": self = .ch
            case "de": self = .de
            case "en-US": self = .us
            case "en-GB": self = .en
            case "fr": self = .fr
            case "ja": self = .jp
            default: self = .de
        }
    }
}
