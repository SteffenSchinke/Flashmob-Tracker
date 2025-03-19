//
//  Event.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 24.02.25.
//


import SwiftUI
import FirebaseFirestore
import Observation
import MapKit

struct Event: FlashmobAnnotation {
    
    enum CodingKeys: String, CodingKey {
        
        case id, organizerId, title, motto, desc, date, location,
             medias, documents, participantRequiredCount,
             participantAvailableCount, participantRegistrationList,
             createdAt, updatedAt
    }
    
    var id: String
    var organizerId: String
    
    var title: String?
    var motto: String?
    var desc: String?
    var date: Date?
    var location: FlashmobLocation?
    var medias: [FlashmobStoreFile] = []
    var documents: [FlashmobStoreFile] = []
    
    var participantRequiredCount: Int = 0
    var participantAvailableCount: Int = 0
    var participantRegistrationList: [String]?
    var isOnlyMarker: Bool = false
    var description: String {
        """
        \(self.title ?? "")
        \(self.date?.formatted(.dateTime.day().month().year().hour().minute()) ?? "")
        """
    }

    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
    
    private(set) var isOnlyMapMarker: Bool = false
    
    init( _ eventId: String,  _ appUserId: String) {
        
        self.id = eventId
        self.organizerId = appUserId
    }
    
    // default event and only location for map annotation
    init( _ location: FlashmobLocation) {
        
        self.id = UUID().uuidString
        self.organizerId = UUID().uuidString
        self.location = location
        self.isOnlyMapMarker = true
    }
    
    func getFirstMediaImageUrl() -> URL? {
        
        let medias = self.medias.filter({ $0.ext == .png || $0.ext == .jpg })
        if let media = medias.first {
            
            return media.url
        }
        return nil
    }
    
    
    // protocol FlashmobAnnotation implements
    var coord2D: CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(
            latitude: self.location?.latitude ?? 0.0,
            longitude: self.location?.longitude ?? 0.0)
    }
    
    
    // protocol Hashable implements
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        
//        return lhs.id == rhs.id
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        
//        hasher.combine(id)
//    }
    
}
