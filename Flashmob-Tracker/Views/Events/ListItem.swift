//
//  ListItem.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 05.03.25.
//


import SwiftUI
import AVKit


struct ListItem: View {
    
    @State private var favSV: Favorites = .shared
    
    private var item: Event
    private var size: CGSize
    
    init( _ item: Event, _ size: CGSize = CGSize(width: 160, height: 160)) {
        
        self.item = item
        self.size = size
    }
    
    var body: some View {
       
        ZStack {
            
            FlashmobMedias(self.item.medias.first, size)
            
            VStack {
                
                
                let isFavorite = self.favSV.isInFavorites(self.item.id)
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(.red)
                    .font(.title2)
                    .onTapGesture {
                        
                        self.favSV.toggleFavorite(self.item.id)
                    }
            }
            .padding(6)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .topTrailing)
            
            VStack (alignment: .leading) {
                
                Text(item.title ?? "No Title")
                    .font(.footnote)
                    .fontWeight(.bold)
                    
                
                Text(item.motto ?? "No Motto")
                    .font(.caption)
                
                Text(item.date ?? .now, style: .date)
                    .font(.caption)
            }
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding()
            .darkModeForegroundShadow()
            
        }
        .frame(width: self.size.width + 2,
               height: self.size.height + 2)
    }
}

