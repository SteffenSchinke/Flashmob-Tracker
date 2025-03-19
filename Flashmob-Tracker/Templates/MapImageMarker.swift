//
//  MapImageMarker.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 09.03.25.
//


import SwiftUI


struct MapImageMarker: View {
    
    let event: Event
    
    init( _ event: Event) {
        
        self.event = event
    }
    
    var body: some View {
        
        ZStack {
            
            if let url = event.getFirstMediaImageUrl() {
                
                AsyncImage(url: url) { image in
                    
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 45)
                        .clipShape(
                            
                            RoundedRectangle(cornerRadius: 6)
                        )
                        .overlay(
                            
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 0.7)
                        )
                } placeholder: {
                    
                    ProgressView()
                        .progressViewStyle()
                }
                .frame(width: 60, height: 60)
                
            } else if event.isOnlyMapMarker {
                
                Image("MapMarker")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45, height: 45)
            } else {
                
                Image("DefaultAnnotation")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 45)
                    .clipShape(
                        
                        RoundedRectangle(cornerRadius: 6)
                    )
                    .overlay(
                        
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 0.7)
                    )
            }
        }
    }
}

