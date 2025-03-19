//
//  MapTracker.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct FlashmobMap: ContentView {
    
    @Namespace private var mapSpace
    
    @Environment(MapVM.self) private var mapVM
    @Environment(AuthUserVM.self) private var authVM
    
    @State private var isFullScreen: Bool = false
    @State private var isPickupMapMode: Bool = false
    @State private var showSearchFiled: Bool = false
    @State private var showControls: Bool = true
    @State private var showLookAroundView: Bool = false
    
    var localKey: String = "title_flashmob_map"
    var headerMode: HeaderDisplayMode { isFullScreen ? .hidden : .visible }
    var isViewModelinWorking: Bool { mapVM.isWorking }
    var sourceViewNamespace: Namespace.ID? { self.mapSpace }
    
    private var locationService: Location = .init()
    
    var content: some View {
        
        ZStack {
            
            VStack {
                
                MapRect(self.$showSearchFiled,
                        self.$showLookAroundView,
                        self.$isFullScreen,
                        self.$showControls,
                        self.$isPickupMapMode,
                        self.sourceViewNamespace!)
                .cornerRadius( self.isFullScreen ? 0 : 16)
                .clipped()
                .padding(.bottom, self.isFullScreen ? 0 : 50)
                .padding(.horizontal, self.isFullScreen ? 0: 16)
                .ignoresSafeArea(self.isFullScreen ? .all : .container)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            if self.isFullScreen {
                
                VStack {
                    
                    getTrailingMenu()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 70)
                .padding(.trailing, 16)
            }
        }
        .task {
            
            self.mapVM.setMapRegion()
        }
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() -> AnyView  {
        
        AnyView(
            
            HStack {
                
                Button(action: { self.isPickupMapMode.toggle() }) {
                    
                    Label(appLang.localString("lbl_pin_mode"),
                          systemImage: self.isPickupMapMode ?
                                            SFIcon.mappin.key :
                                            SFIcon.mappin_off.key)
                                .darkModeTintShadow()
                }
                
                Button(action: { self.showSearchFiled.toggle() }) {
                    
                    Label(appLang.localString("lbl_search"),
                          systemImage: SFIcon.search.key)
                                .darkModeTintShadow()
                }
                
                Button(action: { self.showLookAroundView.toggle() } ) {
                    
                    Label(appLang.localString("lbl_look_around_view"),
                          systemImage: SFIcon.eye.key)
                                .darkModeTintShadow()
                }
                
                Button(action: { self.isFullScreen.toggle() }) {
                    
                    Label(appLang.localString("btn_map_min"),
                          systemImage:
                                self.isFullScreen ?
                                SFIcon.zoomOut.key :
                                SFIcon.zoomIn.key )
                            .darkModeTintShadow()
                }
            }
            .darkModeTintShadow()
            .labelStyle(.iconOnly)
        )
    }
}
