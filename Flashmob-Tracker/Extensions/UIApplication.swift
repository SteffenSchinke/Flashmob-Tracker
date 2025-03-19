//
//  UIApplication.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 25.02.25.
//


import SwiftUI


extension UIApplication {
    
    @MainActor
    var rootViewController: UIViewController? {
        
        // Hole die aktive Szene
        guard let windowScene = connectedScenes.first as? UIWindowScene else { return nil }
        
        // Hole das Hauptfenster
        return windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }
}
