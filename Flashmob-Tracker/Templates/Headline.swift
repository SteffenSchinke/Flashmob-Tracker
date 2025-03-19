//
//  Headline.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct Headline<Leading: View, Trailing: View>: View {
    
    @Environment(AuthUserVM.self) private var authUserVM
    
    private let title: String
    private var displayMode: HeaderDisplayMode
    private let leadingMenu: Leading
    private let trailingMenu: Trailing
    private let sourceViewNamespace: Namespace.ID
    
    init( _ title: String,
          _ sourceViewNamespace: Namespace.ID,
          _ leadingMenu: Leading = EmptyView(),
          _ trailingMenu: Trailing = EmptyView(),
          _ dispayMode: HeaderDisplayMode = .visible) {
        
        self.title = title
        self.sourceViewNamespace = sourceViewNamespace
        self.leadingMenu = leadingMenu
        self.trailingMenu = trailingMenu
        self.displayMode = dispayMode
    }
    
    enum DisplayMode {
        
        case onlyMenu
        case onlyTitle
        case onlyImage
        case onlyTitleAndMenu
        case hidden
        case visible
    }
    
    var body: some View {
        
        if self.displayMode != .hidden {
            
            VStack {
                
                ZStack {
                    
                    if [.onlyTitle,
                        .onlyTitleAndMenu,
                        .visible].contains(where: { $0 == self.displayMode }) {
                        
                        Text(appLang.localString(self.title))
                            .darkModeForegroundShadow(28)
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                            .padding(.leading, 72)
                    }
                    
                    if [.inLoggedIn, .refreshedLogin]
                            .contains(self.authUserVM.authState),
                        [.onlyImage, .visible, .onlyImageAndMenu]
                            .contains(self.displayMode) {
                       
                        HStack {
                            
                            NavigationLink(
                                value: NavLinkProfile(
                                            profileId: self.authUserVM.authUser.id,
                                            nameSpace: self.sourceViewNamespace),
                                label: {
                                    ProfileImageFile(self.authUserVM, 25, false)
                                        .matchedTransitionSource(
                                            id: self.authUserVM.authUser.id,
                                            in: self.sourceViewNamespace)
                                }
                            )
                        }
                        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                    }
                    
                    if [.onlyMenu,
                        .onlyTitleAndMenu,
                        .visible,
                        .onlyImageAndMenu].contains(where: { $0 == self.displayMode })  {
                        
                        self.leadingMenu
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .leading)
                        
                        self.trailingMenu
                            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .trailing)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: 100)
        } else {
            
            EmptyView()
        }
    }
}
