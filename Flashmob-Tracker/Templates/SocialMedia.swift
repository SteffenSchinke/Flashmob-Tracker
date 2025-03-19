//
//  SocialMedia.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct SocialMedia: View {
    
    @Environment(AuthUserVM.self) private var authUserVM
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack() {
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(.gray)
                }
                .frame(maxWidth: 80, maxHeight: 60)
                
                VStack {
                    Text(appLang.localString("title_sozial_media"))
                        .font(.custom("NovaSquare", size: 16))
                        .foregroundStyle(colorScheme == .light ? .white : .black)
                        .shadow(color: colorScheme == .light ? .black : .white, radius: 2, x: 1.5, y: 1.5)
                }
                .frame(maxWidth: 200, maxHeight: 60)
                
                VStack() {
                    
                    Divider()
                        .frame(height: 2)
                        .overlay(.gray)
                    
                }
                .frame(maxWidth: 80, maxHeight: 60)
            }
            .padding(.bottom, 40)
            
            HStack {
                
                ButtonSquare("AuhtIcons/IconApple") { authUserVM.signIn(.apple) }
                ButtonSquare("AuhtIcons/IconGoogle") { authUserVM.signIn(.google) }
                ButtonSquare("AuhtIcons/IconFacebook") { authUserVM.signIn(.facebook) }
            }
            
            HStack {
                
                ButtonSquare("AuhtIcons/IconInstagram") { authUserVM.signIn(.instagram) }
                ButtonSquare("AuhtIcons/IconTwitter") { authUserVM.signIn(.twitter) }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 40)
    }
}
