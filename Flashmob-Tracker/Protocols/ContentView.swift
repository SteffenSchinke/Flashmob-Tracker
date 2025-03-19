//
//  ContentView.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


protocol ContentView: View {
    
    associatedtype LeadingMenu: View
    associatedtype TrailingMenu: View
    associatedtype ViewContent: View
    
    @ViewBuilder
    var content: ViewContent { get }
    var headerMode: HeaderDisplayMode { get }

    var localKey: String { get }
    var isViewModelinWorking: Bool { get }
    var sourceViewNamespace: Namespace.ID? { get }
    
    func getLeadingMenu() -> LeadingMenu
    func getTrailingMenu() -> TrailingMenu
}

extension ContentView {
    
    @ViewBuilder
    public var body: some View {
        
        
        ZStack {
            
            Background()
            
            if self.isViewModelinWorking {
                
                ProgressView()
                    .tint(self.colorScheme == .light ?
                          Color.black.opacity(0.5) :
                            Color.white.opacity(0.5))
                    .scaleEffect(1.3)
            } else {
                
                VStack {
                    
                    VStack {
                        
                        Headline(self.localKey,
                                 self.sourceViewNamespace ?? Namespace().wrappedValue,
                                 self.getLeadingMenu(),
                                 self.getTrailingMenu(),
                                 self.headerMode)
                        .padding(.top, 40)
                        .frame(maxHeight: 120, alignment: .top)
                    }
                    
                    content
                        .ignoresSafeArea()
                        .frame(maxHeight: .infinity, alignment: .top)
                }
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .ignoresSafeArea()
        .frame(maxHeight: .infinity, alignment: .top)
        .navigationBarHidden(true)
    }
}
