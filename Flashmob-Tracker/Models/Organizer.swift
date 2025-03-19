//
//  Organizer.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 14.03.25.
//


import FirebaseFirestore
import MapKit


struct Organizer: FlashmobAnnotation {
    
    enum CodingKeys: CodingKey {
        
        case id, companyName, location, profileImage
    }
    
    var id: String
    var companyName: String?
    var location: FlashmobLocation?
    var profileImage: FlashmobStoreFile?
    var isOnlyMarker: Bool = false
    
    init() { self.id = UUID().uuidString }
    
    // protocol codable implements
    init(from decoder: Decoder) throws {
        
        do {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.id = try container.decode(String.self, forKey: .id)
            self.companyName = try container.decode(String.self, forKey: .companyName)
            self.location = try container.decode(FlashmobLocation.self, forKey: .location)
            self.profileImage = try container.decodeIfPresent(FlashmobStoreFile.self, forKey: .profileImage) ?? nil
            
        } catch {
            
            self.id = UUID().uuidString
            print("Decode Error: \(error.localizedDescription)")
        }
    }
    
    
    // protocol codable implements
    func encode(to encoder: Encoder) throws {}
    
    
    // protocol FlashmobAnnotation implements
    var description: String {
        
        var result: String = "\(self.companyName ?? "")\n"
        result += "\(self.location?.description ?? "")"
        
        return result
    }
    
    var coord2D: CLLocationCoordinate2D {
        
        CLLocationCoordinate2D(
            latitude: self.location?.latitude ?? 0.0,
            longitude: self.location?.longitude ?? 0.0)
    }
}
