//
//  FlashmobStoreKey.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 04.03.25.
//


enum FlashmobStoreKey: String {
    
    case profileImage = "profile_img"
    case eventPDF = "event_pdf"
    case eventMedia = "event_media"
    
    var key: String { self.rawValue }
}
