//
//  Favorite.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 07.03.25.
//


import FirebaseFirestore


struct FavoriteList: Codable, Equatable, Hashable {
    
    var favorites: [String] = []
}
