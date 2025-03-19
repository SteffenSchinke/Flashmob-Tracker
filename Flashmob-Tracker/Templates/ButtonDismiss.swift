//
//  ButtonDismiss.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 24.02.25.
//


import SwiftUI


struct ButtonDismiss: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var action: (() async -> Void)?
    
    var body: some View {
        
        Button( action: {
            
            Task {
                
                do {
                    
                    try await Task.sleep(for: .milliseconds(500))
                } catch { }
                
                await self.action?()
            }
            
            self.dismiss()
        }) {
            
            Image(systemName: "xmark.circle")
                .darkModeTintShadow()
        }
    }
}
