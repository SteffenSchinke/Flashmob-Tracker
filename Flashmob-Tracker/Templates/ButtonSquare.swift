//
//  ButtonSquare.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct ButtonSquare: View {
    
    private var systemName: String
    private var action: () -> Void
    
    
    init( _ systemName: String, _ action: @escaping () -> Void) {
     
        self.systemName = systemName
        self.action = action
    }
    
    var body: some View {
        
        Button(action: {
            
            self.action()
        }) {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 60, height: 60)
                .buttonShadowStyle()
                .overlay(
                    
                    Image(self.systemName)
                        .foregroundStyle(.primary)
                        .font(.system(size: 34))
                        .foregroundStyle(colorScheme == .light ? .white : .black)
                        .offset(x: 0.5, y: 0.5)
                        .shadow(color: colorScheme == .light ? .black : .white, radius: 2, x: 0.7, y: 0.7)
                )
        }
        .buttonStyle(.plain)
        .padding()
    }
}


