//
//  MapUserMarker.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.03.25.
//


import SwiftUI


struct MapUserMarker: View {
    
    private var appUser: AppUser
    private var cornerRadius: CGFloat
    
    init( _ appUser: AppUser, _ cornerRadius: CGFloat = 24) {
        
        self.appUser = appUser
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        
        AsyncImage(url: self.appUser.profileImage.url) { image in
            
            image
                .resizable()
                .scaledToFill()
                .frame(width: self.cornerRadius * 2,
                       height: self.cornerRadius * 2)
                .clipShape(
                    
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                )
                .overlay(
                    
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 0.7)
                )
        } placeholder: {
            
            ProgressView()
                .progressViewStyle()
        }
        .frame(width: self.cornerRadius * 2 + 1,
               height: self.cornerRadius * 2 + 1)
        
    }
}
