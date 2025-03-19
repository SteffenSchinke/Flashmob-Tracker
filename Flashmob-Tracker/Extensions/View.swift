//
//  View.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 24.02.25.
//


import SwiftUI


extension View {
    
    var colorScheme: ColorScheme {
        
        return (UIApplication.shared.connectedScenes
            .first as? UIWindowScene)?
            .windows.first?
            .traitCollection.userInterfaceStyle == .dark ? .dark : .light
    }
    
    var appLang: AppLocalization { .shared }
    
    func progressViewStyle() -> some View {
        
        self.modifier(ProgressViewStyle())
    }
    
    func darkModeTintShadow( _ size: CGFloat = 16) -> some View {
        
        self.modifier(DarkModeTintShadowModifier(size))
    }
    
    func darkModeForegroundShadow( _ size: CGFloat = 36) -> some View {
        
        self.modifier(DarkModeForegroundShadowModifier(size))
    }
    
    func borderTextFieldStyle() -> some View {
        
        self.modifier(BorderTextFieldStyle())
    }
    
    func borderTextFieldMapStyle() -> some View {
        
        self.modifier(BorderTextFieldMapStyle())
    }
    
    func dynamicSizeModifier( _ uiImage: UIImage) -> some View {
        
        self.modifier(DynamicSizeModifier(uiImage: uiImage))
    }
    
    func buttonShadowStyle() -> some View {
        
        self.modifier(ButtonShadowStyle())
    }
}

extension ViewModifier {
    
    var colorScheme: ColorScheme {
        
        return (UIApplication.shared.connectedScenes
            .first as? UIWindowScene)?
            .windows.first?
            .traitCollection.userInterfaceStyle == .dark ? .dark : .light
    }
}

struct ProgressViewStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .tint(self.colorScheme == .light ?
                  Color.black.opacity(0.5) :
                    Color.white.opacity(0.5))
    }
}

struct DarkModeTintShadowModifier: ViewModifier {
    
    var size : CGFloat
    
    init( _ size: CGFloat = 24) {
        
        self.size = size
    }
    
    func body(content: Content) -> some View {
        
        content
            .font(.custom("NovaSquare", size: self.size))
            .tint(colorScheme == .dark ? .black : .white)
            .shadow(color: colorScheme == .dark ? .white : .black,
                    radius: 1, x: 1.3, y: 1.3)
    }
}

struct DarkModeForegroundShadowModifier: ViewModifier {
    
    var size : CGFloat
    
    init( _ size: CGFloat = 36) {
        
        self.size = size
    }
    
    func body(content: Content) -> some View {
        
        content
            .font(.custom("NovaSquare", size: self.size))
            .foregroundStyle(colorScheme == .dark ? .black : .white)
            .shadow(color: colorScheme == .dark ? .white : .black, radius: 2, x: 1.5, y: 1.5)
            
    }
}

struct BorderTextFieldStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(self.colorScheme == .light ?
                            Color.white.opacity(0.5) :
                            Color.gray.opacity(0.5))
            )
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(self.colorScheme == .light ?
                            Color.white.opacity(0.5) :
                            Color.gray.opacity(0.5), lineWidth: 0.5)
            )
    }
}

struct BorderTextFieldMapStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(self.colorScheme == .light ?
                            Color.gray.opacity(0.35) :
                            Color.white.opacity(0.3))
            )
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(self.colorScheme == .light ?
                            Color.gray.opacity(0.35) :
                            Color.white.opacity(0.3), lineWidth: 0.5)
            )
    }
}

struct DynamicSizeModifier: ViewModifier {
    
    let uiImage: UIImage

    func body(content: Content) -> some View {
        
        let isLandscape = uiImage.size.width > uiImage.size.height
        
        return content
            .frame(
                width: isLandscape ? 90 : 60,
                height: isLandscape ? 60 : 90
            )
    }
}

struct ButtonShadowStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(
                
                RoundedRectangle(cornerRadius: 14)
                    .shadow(color: colorScheme == .light ? .white : .black, radius: 4, x: 3, y: 3)
            )
            .overlay(
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(.gray)
            )
            .overlay(
                
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white, lineWidth: 4)
                    .blur(radius: 2)
                    .offset(x: 2, y: 2)
                    .mask(
                        RoundedRectangle(cornerRadius: 16).fill(LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                    )
            )
    }
}
