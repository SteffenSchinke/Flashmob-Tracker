//
//  MapMarker.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 14.03.25.
//


import SwiftUI


struct MapMarker: View {
    
    var body: some View {
        
        Image("MapMarker")
            .resizable()
            .scaledToFit()
            .frame(width: 45, height: 45)
    }
}
