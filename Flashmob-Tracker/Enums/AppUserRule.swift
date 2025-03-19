//
//  LoginModus.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


enum AppUserRule: String, Codable, CaseIterable {
    
    case guest
    case participant
    case organizer
    
    var localKey: String {
        
        switch self {
            
            case .organizer: "title_organizer"
            case .participant: "title_participant"
            case .guest: "title_guest"
        }
    }
}
