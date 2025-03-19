//
//  FirestoreKey.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 19.02.25.
//


enum FireStoreKey: String {
    
    case appUsers = "app_users"
    case events = "events"
    case favorites = "favorites"
    
    var key: String { self.rawValue }
}
