//
//  Filter.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 06.03.25.
//


import SwiftUI


struct Filter: ContentView {
    
    @Namespace private var filterSpace
    
    @Environment(DashboardVM.self) private var dashVM
    
    var localKey: String = "title_filter"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool {
        self.dashVM.isWorking
    }
    var sourceViewNamespace: Namespace.ID? { self.filterSpace }
    
    
    var content: some View {
        
        // TODO sts 18.03.25 - filter implements in the future
        VStack {
            
            EmptyView()
        }
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() ->  AnyView  {
        
        AnyView(
            
            ButtonDismiss() { }
        )
    }
}
