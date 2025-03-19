//
//  Greeting.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct Greeting: ContentView {
    
    
    @Environment(AuthUserVM.self) private var authVM
    
    var localKey: String = "title_greet"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool { false }
    var sourceViewNamespace: Namespace.ID?
    
    var content: some View {
        
        VStack {
            
            VStack {
                
                let user = self.authVM.authUser
                
                ProfileImageFile(self.authVM, 100, false)
                
                Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                    
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.bottom, 30)
            
            Text(appLang.localString("greet_title"))
                .font(.headline)
                .padding(.bottom, 20)
            
            ScrollView {
                Text(appLang.localString("greet_description"))
                    .font(.body)
                    .padding(.bottom, 50)
            }
        }
        .darkModeForegroundShadow()
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() -> AnyView {
        
        AnyView(
            
            ButtonDismiss(action: {
                self.authVM.authState = .inLoggedIn
            })
        )
    }
}
