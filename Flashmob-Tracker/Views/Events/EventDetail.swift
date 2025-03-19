//
//  EventDetail.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 05.03.25.
//


import SwiftUI
import MapKit


struct EventDetail: ContentView {
    
    @Namespace private var detailSpace
    
    @Environment(AuthUserVM.self) private var authVM
    @Environment(MapVM.self) private var mapVM
    
    @State private var favSV: Favorites = .shared
    @State private var detailVM: DetailVM = .init()
    
    var localKey: String = "title_event_details"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool {
        self.detailVM.isWorking
    }
    var sourceViewNamespace: Namespace.ID? { self.detailSpace }
    
    
    private var eventId: String
    
    init( _ eventId: String) {
        
        self.eventId = eventId
    }
    
    var content: some View {
        
        VStack {
               
            if let event = detailVM.event,
               let media = event.medias.first {
                
                VStack {
                    
                    ZStack {
                        
                        GeometryReader { geometry in
                            
                            let width = geometry.size.width
                            let height = (width * 10 / 16)
                            let size = CGSize(width: width, height: height)
                            
                            FlashmobMedias(media, size, 0.1)
                        }
                        .padding(20)
                        
                        VStack {
                            
                            let isFavorite = self.favSV.isInFavorites(event.id)
                            Image(systemName: isFavorite ?
                                  SFIcon.heart_fill.key :
                                    SFIcon.heart.key)
                            .foregroundStyle(.red)
                            .font(.title)
                            .onTapGesture {
                                
                                self.favSV.toggleFavorite(event.id)
                            }
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity,
                               maxHeight: .infinity,
                               alignment: .topTrailing)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 260)
                }
                
                ScrollView {
                    
                    Text(event.title ?? "")
                        .darkModeForegroundShadow(24)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("\"\(event.motto ?? "")\"")
                        .darkModeForegroundShadow(20)
                        .padding()
                    
                    Text(event.desc ?? "")
                        .darkModeForegroundShadow(18)
                        .padding()
                    
                    Text("\(self.appLang.localString("title_date_where")) : \(event.date ?? .now, style: .date) \(event.date ?? .now, style: .time)")
                        .darkModeForegroundShadow(18)
                        .padding()
                    
                    MapRect(.constant(false),
                            .constant(false),
                            .constant(false),
                            .constant(false),
                            .constant(false),
                            self.sourceViewNamespace!)
                    .cornerRadius(16)
                    .frame(height: 300)
                    .padding()
                    
                    if event.medias.count > 1 {
                        
                        Text(self.appLang.localString("title_motiv"))
                            .darkModeForegroundShadow(20)
                            .padding()
                        
                        ScrollView(.horizontal) {
                            
                            HStack {
                                
                                ForEach(event.medias.dropFirst(), id: \.id) { media in
                                    
                                    FlashmobMedias(media, CGSize(width: 128, height: 128), 0.3) { media in
                                        
                                        self.detailVM.setMediaFileToTitleTheme(media)
                                    }
                                    .padding(.bottom, 15)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 130)
                        }
                        .padding()
                    }
                    
                    
                    if event.documents.count > 0 {
                        
                        Text(self.appLang.localString("title_docs"))
                            .darkModeForegroundShadow(20)
                            .padding(.bottom, 10)
                        
                        ScrollView(.horizontal) {
                            
                            HStack {
                                
                                ForEach(event.documents, id: \.id) { media in
                                    
                                    if let url = media.url {
                                        
                                        NavigationLink(
                                            value: NavLinkPDF(url: url,
                                                              nameSpace: self.detailSpace),
                                            label: {
                                                   
                                                FlashmobMedias(media,
                                                               CGSize(width: 128, height: 128))
                                                    .padding(.bottom, 15)
                                            })
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: 130)
                        }
                        .padding()
                    }
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(5)
                .padding(.bottom, 60)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            
            await self.detailVM.loadEvent(
                    self.eventId,
                    self.authVM.authUser.id) { event in
                
                self.mapVM.insertEventLocation(event)
            }
        }
    }
    
    func getLeadingMenu() -> EmptyView { EmptyView() }
    
    func getTrailingMenu() -> AnyView  { AnyView(ButtonDismiss()) }
}
