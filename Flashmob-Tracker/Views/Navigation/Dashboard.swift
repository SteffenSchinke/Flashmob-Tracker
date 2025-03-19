//
//  Dashboard.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct Dashboard: ContentView {
    
    @Namespace private var dashSpace
    
    @Environment(AuthUserVM.self) private var authUserVM
    @Environment(AppSettingsVM.self) private var appSettingsVM
    @Environment(MapVM.self) private var mapVM
    
    @State private var showFilter = false
    @State private var favSV: Favorites = .shared
    @State private var dashVM: DashboardVM = .init()
    
    var localKey: String = "title_dashboard"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool { false }
    var sourceViewNamespace: Namespace.ID? { self.dashSpace }
    
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 165), spacing: 10)
    ]
    
    
    var content: some View {
        
        VStack {
            
            if self.favSV.count > 0 {
                
                VStack {
                    
                    Text(appLang.localString("title_dash_fav"))
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .darkModeForegroundShadow(18)
                    
                    ScrollView(.horizontal) {
                        
                        HStack {
                            
                            ForEach(self.dashVM.events, id: \.id) { event in
                                
                                if self.favSV.isInFavorites(event.id) {
                                    
                                    NavigationLink(
                                        value: NavLinkDash(navObjectId: event.id,
                                                           tabIndex: .detail,
                                                           nameSpace: self.dashSpace),
                                        label: {
                                            ListItem(event, CGSize(width: 140, height: 110))
                                                .matchedTransitionSource(
                                                    id: event.id,
                                                    in: self.dashSpace)
                                        }
                                    )
                                    .buttonStyle(.plain)
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: 160, alignment: .top)
            }
            
            VStack {
                Text(self.appLang.localString("title_dash_news"))
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .darkModeForegroundShadow(18)
                
                VStack {
                    ScrollView {
                        
                        LazyVGrid(columns: columns, spacing: 5) {
                            
                            ForEach(self.dashVM.events, id: \.id) { event in
                                
                                if !self.favSV.isInFavorites(event.id) {
                                    
                                    NavigationLink(
                                        value: NavLinkDash(navObjectId: event.id,
                                                           tabIndex: .detail,
                                                           nameSpace: self.dashSpace),
                                        label: {
                                            ListItem(event, CGSize(width: 165, height: 165))
                                                .matchedTransitionSource(
                                                    id: event.id,
                                                    in: self.dashSpace)
                                        }
                                    )
                                    .buttonStyle(.plain)
                                    .padding()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 60)
                }
                .padding(.vertical, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .task {
            
            await self.dashVM.loadEvents()
        }
    }
    
    func getLeadingMenu() -> EmptyView { EmptyView() }
    
    func getTrailingMenu() -> AnyView  {
        
        AnyView(
            
            HStack {
                
                Menu {
                    
                    Button(action: {
                        
                        let events = self.dashVM.events.compactMap { self.favSV.favorites.contains($0.id) ? $0 : nil }
                        if events.count > 0 {
                            
                            self.mapVM.setEventLocations(events)
                            self.appSettingsVM.selectedNavTabIndex = NavTabIndex.map.index
                        }
                    } ) {
                        
                        Label(appLang.localString("title_map_favorites"),
                              systemImage: SFIcon.mappin_map.key)
                    }
                    .disabled(self.favSV.favorites.count == 0)
                    
                    Button(action: {
                        
                        let events = self.dashVM.events.compactMap { self.favSV.favorites.contains($0.id) ? nil : $0 }
                        if events.count > 0 {
                            
                            self.mapVM.setEventLocations(events)
                            self.appSettingsVM.selectedNavTabIndex = NavTabIndex.map.index
                        }
                    } ) {
                        
                        Label(appLang.localString("title_map_flashmobs"),
                              systemImage: SFIcon.mappin_map.key)
                    }
                    
                    Button(action: {
                        
                        Task {
                            
                            await self.dashVM.loadOrganizers(self.authUserVM.authUser.id)
                            
                            if self.dashVM.organizers.count > 0 {
                                
                                self.mapVM.setOrganizers(self.dashVM.organizers)
                                self.appSettingsVM.selectedNavTabIndex = NavTabIndex.map.index
                            }
                        }
                    } ) {
                        
                        Label(appLang.localString("title_map_organizer"),
                              systemImage: SFIcon.mappin_map.key)
                    }
                } label: {
                    
                    Label(appLang.localString(""),
                          systemImage: SFIcon.map.key)
                    .darkModeTintShadow()
                }
                
// TODO sts 18.03.25 - filter implements in the future
//                NavigationLink(
//                    value:  NavLinkDash(navObjectId: UUID().uuidString,
//                                        tabIndex: .filter,
//                                        nameSpace: self.dashSpace),
//                    label: {
//                        Label(appLang.localString("title_filter"),
//                              systemImage: SFIcon.filter.key)
//                        .matchedTransitionSource(
//                            id: NavTabIndex.filter,
//                            in: self.dashSpace)
//                        .darkModeTintShadow()
//                    }
//                )
                
                if authUserVM.authUser.userRule == .organizer {
                    
                    NavigationLink(
                        value: NavLinkDash(navObjectId: UUID().uuidString,
                                           tabIndex: .create,
                                           nameSpace: self.dashSpace),
                        label: {
                            Label(appLang.localString("title_create_event"),
                                  systemImage: SFIcon.add.key)
                            .matchedTransitionSource(
                                id: NavTabIndex.create,
                                in: self.dashSpace)
                            .darkModeTintShadow()}
                    )
                }
            }
            .labelStyle(.iconOnly)
        )
    }
}

