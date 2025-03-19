//
//  Address.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 05.03.25.
//


import MapKit
import SwiftUI


struct FlashmobLocation: FlashmobAnnotation {
    
    enum CodingKeys: String, CodingKey {
        
        case street, zipCode, city, country,
             latitude, longitude
    }
    
    var street: String?
    var zipCode: String?
    var city: String?
    var country: String?
    
    var latitude: Double?
    var longitude: Double?
    var isOnlyMarker: Bool = true
    
    // protocol FlashmobAnnotation implements
    var description: String {
        
        "\(self.street ?? ""),\n\(self.zipCode ?? "") \(self.city ?? ""),\n\(self.country ?? "")"
    }
     
    var id: String { UUID().uuidString }
    
    var coord2D: CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(
            latitude: self.latitude ?? 0.0,
            longitude: self.longitude ?? 0.0)
    }
}
