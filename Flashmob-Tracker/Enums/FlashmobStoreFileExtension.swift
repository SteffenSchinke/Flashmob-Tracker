//
//  FlashmobStoreFileExtension.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 23.02.25.
//


enum FlashmobStoreFileExtension: String, Codable {
    
    case jpg, png, gif, mp4, mov, pdf, mp3, none
    
    var mimeType: String {
        
        switch self {
            
            case .jpg: "image/jpeg"
            case .png: "image/png"
            case .gif: "image/gif"
            case .mp4: "video/mp4"
            case .mov: "video/quicktime"
            case .pdf: "application/pdf"
            case .mp3: "audio/mpeg"
            case .none: "application/octet-stream"
        }
    }
}
