//
//  AppUser.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import FirebaseFirestore
import MapKit
import SwiftUI


struct AppUser: FlashmobAnnotation {
    
    enum CodingKeys: String, CodingKey {
        
        case id, companyName, firstName, lastName, email,
             storePwd, userRule, location, profileImage,
             createdAt, updatedAt
    }
    
    var id: String = UUID().uuidString
    var companyName: String?
    var firstName: String?
    var lastName:String?
    var email: String?
    var storePwd: String?
    var userRule: AppUserRule = AppUserRule.guest
    var location: FlashmobLocation?
    var profileImage: FlashmobStoreFile = .init()
    
    /// Firebase handling this automatically
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
    
    
    init() { }
    
    init( _ id: String) {
        
        self.id = id
        self.profileImage.id = id
    }
    
    
    // protocol FlashmobAnnotation implements
    var description: String {
        
        var result: String = ""
        if self.userRule == .organizer {
            result += "\(self.companyName ?? "")\n"
        } else {
            result += "\(self.firstName ?? "") \(self.lastName ?? "")\n"
        }
        result += "\(self.location?.description ?? "")"
        
        return result
    }
    
    var isOnlyMarker: Bool = false
    
    var coord2D: CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(
            latitude: self.location?.latitude ?? 0.0,
            longitude: self.location?.longitude ?? 0.0)
    }
}


