//
//  Background.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI

import SwiftUI

struct Background: View {

    @Environment(AppSettingsVM.self) private var appSettingsVM
    
    @State private var opacity: Double = 0.7
    @State private var direction: Bool = true
    @State private var isAnimating: Bool = false

    var body: some View {
        
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.9, 0.3], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ],
            colors: [
                .black, .black, .black,
                .white, .blue, .blue,
                .red, .green, .green
            ]
        )
        .opacity(self.opacity)
        .task {
            
            startOpacityAnimation()
        }
        .onChange(of: appSettingsVM.isAnimeBackground, {
            
            if appSettingsVM.isAnimeBackground {
                
                startOpacityAnimation()
            } else {
                
                self.isAnimating = false
                self.opacity = 0.6
            }
        })
        .animation(.linear(duration: 1.0), value: self.opacity)
    }

    private func startOpacityAnimation() {
        
        guard !self.isAnimating else { return }
        
        self.isAnimating = true
        
        Task {

            while !Task.isCancelled {
                
                guard self.appSettingsVM.isAnimeBackground else {
                    await MainActor.run { self.isAnimating = false }
                    return
                }
                
                await MainActor.run { self.updateOpacity() }

                try? await Task.sleep(for: .seconds(1))
            }
        }
        
//        Task {
//            
//            while Task.isCancelled == false {
//                
//                await MainActor.run {
//                    
//                    guard self.appSettingsVM.isAnimeBackground else {
//                        self.isAnimating = false
//                        return
//                    }
//                    self.updateOpacity()
//                }
//                try? await Task.sleep(nanoseconds: 1_000_000_000)
//            }
//        }
    }

    private func updateOpacity() {
        
        if self.direction {
            
            if self.opacity > 0.4 {
                self.opacity -= 0.03
            } else {
                self.direction.toggle()
            }
            
        } else {
            
            if self.opacity < 0.7 {
                self.opacity += 0.03
            } else {
                self.direction.toggle()
            }
        }
    }
}
