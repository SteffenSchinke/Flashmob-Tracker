//
//  ButtonRect.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct ButtonRect: View {
    
    private var title: String
    private var action: () -> Void
    
    init( _ title: String, _ action: @escaping () -> Void) {
     
        self.title = title
        self.action = action
    }
    
    
    var body: some View {
        
        Button(action: {
            
            self.action()
        }) {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 200, height: 50)
                .buttonShadowStyle()
                .overlay(
                    
                    Text(appLang.localString(self.title))
                        .foregroundStyle(colorScheme == .light ? .white : .black)
                        .font(.custom("NovaSquare", size: 22))
                        .fontWeight(.medium)
                        .shadow(color: colorScheme == .light ? .black : .white, radius: 1, x: 1.5, y: 1.5)
                )
            
        }
        .buttonStyle(.plain)
        .padding(4)
    }
}
