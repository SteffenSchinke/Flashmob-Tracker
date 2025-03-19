//
//  MapUserMarker.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.03.25.
//


import SwiftUI


struct MapOrgMarker: View {
    
    private var org: Organizer
    private var cornerRadius: CGFloat
    
    init( _ org: Organizer, _ cornerRadius: CGFloat = 24) {
        
        self.org = org
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        
        Group {
            if let _ = self.org.profileImage?.url {
                
                asyncImage
            } else {
                
                defaultImage
            }
        }
        .frame(width: self.cornerRadius * 2 + 1,
               height: self.cornerRadius * 2 + 1)
        .clipShape(
            
            RoundedRectangle(cornerRadius: self.cornerRadius)
        )
        .overlay(
            
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 0.7)
        )
    }
    
    var defaultImage: some View {
        
        Image(systemName: "photo")
            .frame(width: self.cornerRadius * 2,
                   height: self.cornerRadius * 2)
            .font(.system(size: ((self.cornerRadius * 2) / 3)))
            
    }
    
    var asyncImage: some View {
        
        AsyncImage(url: self.org.profileImage!.url) { image in
            
            image
                .resizable()
                .scaledToFill()
                .frame(width: self.cornerRadius * 2,
                       height: self.cornerRadius * 2)
                
        } placeholder: {
            
            ProgressView()
                .progressViewStyle()
        }
    }
}
