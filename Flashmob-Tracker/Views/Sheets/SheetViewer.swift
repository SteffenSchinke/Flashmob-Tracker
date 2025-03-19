//
//  SheetViewer.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 17.02.25.
//


import SwiftUI

struct SheetViewer: ContentView {
    
    var localKey: String
    var localContent: String
    var headerMode: HeaderDisplayMode = .onlyTitleAndMenu
    var isViewModelinWorking: Bool { false }
    var sourceViewNamespace: Namespace.ID?
    
    
    init( _ localTitle: String, _ localContent: String) {
        
        self.localKey = localTitle
        self.localContent = localContent
    }
    
    var content: some View {
       
        VStack {
            
            ScrollView {
                Text(appLang.localString(self.localContent))
                    .padding()
                    .font(.custom("NovaSquare", size: 17))
            }
            .padding(.horizontal, 20)
        }
        .foregroundStyle(.black)
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() -> AnyView  { AnyView(ButtonDismiss()) }
}
