//
//  MapRect.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI
import MapKit


struct MapRect: View {
    
    @Namespace private var mapCtrlSpace
    
    @Environment(MapVM.self) private var mapVM
    @State private var isLongPressingTap: Bool = false
    
    @Binding var showSearchField: Bool
    @Binding var showLookAroundView: Bool
    @Binding var showFullScrene: Bool
    @Binding var showControls: Bool
    @Binding var isPickupMapMode: Bool
    
    @Bindable var locationManager = Location()
    
    private var sourceNamespace: Namespace.ID
    
    private var onSelectedLocation: ((FlashmobLocation?) -> Void)?
    
    init( _ showSearchField: Binding<Bool>,
          _ showLookAroundView: Binding<Bool>,
          _ showFullScrene: Binding<Bool>,
          _ showControls: Binding<Bool>,
          _ isPickupMapMode: Binding<Bool>,
          _ sourceNamespace: Namespace.ID,
          _ onSelectedLocation: ((FlashmobLocation?) -> Void)? = nil) {
        
        self._showSearchField = showSearchField
        self._showLookAroundView = showLookAroundView
        self._showFullScrene = showFullScrene
        self._showControls = showControls
        self._isPickupMapMode = isPickupMapMode
        self.sourceNamespace = sourceNamespace
        self.onSelectedLocation = onSelectedLocation
    }
    
    var body: some View {
        
        @Bindable var mapVM = self.mapVM
        
        ZStack {
            
            MapReader { mapProxy in
                
                Map(position: $mapVM.cameraPosition,
                    interactionModes: [.all], scope: mapCtrlSpace) {
                    
                    ForEach(self.mapVM.annotations, id:\.id) { anno in
                        
                        Annotation(anno.description, coordinate: anno.coord2D) {
                            
                            if anno.isOnlyMarker {
                                
                                MapMarker()
                            } else {
                                
                                NavigationLink(
                                    value: NavLinkMap(annoId: anno.id,
                                                      annoType: type(of: anno),
                                                      nameSpace: self.sourceNamespace),
                                    label: {
                                        Group {                
                                            if let event = anno as? Event {
                                                
                                                MapImageMarker(event)
                                            } else if let user = anno as? AppUser {
                                                
                                                MapUserMarker(user)
                                            } else if let org = anno as? Organizer {
                                                
                                                MapOrgMarker(org)
                                            } else {
                                                
                                                MapMarker()
                                            }
                                        }
                                        .matchedTransitionSource(
                                                id: anno.id,
                                                in: self.sourceNamespace    )
                                    })
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                // TODO sts 11.03.25 - picker for selection
                .mapStyle(.standard)
                //.mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excluding([])))
                //.mapStyle(.imagery(elevation: .realistic))
                //.mapStyle(.hybrid(elevation: .realistic, pointsOfInterest: .excluding([])))
                
                .mapControlVisibility( self.showFullScrene ? .hidden : .visible)
                .mapControls {
                    
                    if !self.showFullScrene {
                        
                        if self.showControls {
                            MapUserLocationButton()
                            MapPitchToggle()
                        }
                        MapCompass()
                        MapScaleView()
                            .scaleEffect(1.2)
                    }
                }
                .lookAroundViewer(
                    isPresented: self.$showLookAroundView,
                    initialScene: mapVM.lookAroundScene
                )
                .simultaneousGesture(
                    
                    SpatialTapGesture(count: 1, coordinateSpace: .local)
                        .onEnded { location in
                            
                            if self.isPickupMapMode {
                                
                                Task {
                                    
                                    if let coordinate: CLLocationCoordinate2D =
                                        mapProxy.convert(location.location, from: .local) {
                                        
                                        let location = await self.mapVM.setSingleMapMarker(coordinate)
                                        self.onSelectedLocation?(location)
                                    }
                                }
                            }
                        }
                )
                .task {
                    
                    self.locationManager.requestPermission()
                }
            }
            
            if self.showFullScrene {
                
                VStack {
                    
                    if self.showControls {
                        
                        MapUserLocationButton(scope: mapCtrlSpace)
                            .background(
                                Color(colorScheme == .dark ?
                                      Color.black.opacity(0.75) :
                                        Color.white)
                                .cornerRadius(8)
                            )
                        
                        MapPitchToggle(scope: mapCtrlSpace)
                            .background(
                                Color(colorScheme == .dark ?
                                      Color.black.opacity(0.75) :
                                        Color.white)
                                .cornerRadius(8)
                            )
                    }
                    
                    MapCompass(scope: mapCtrlSpace)
                }
                .padding(16)
                .padding(.top, 56)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                
                HStack { MapScaleView(scope: mapCtrlSpace) }
                    .padding(16)
                    .padding(.bottom, 26)
                    .scaleEffect(1.2)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .bottomLeading)
                    .offset(x: 16)
            }
            
            if self.showSearchField {
                
                VStack {
                    
                    GeometryReader { geo in
                        
                        let width = geo.size.width * 0.85
                        
                        HStack {
                            
                            TextField(appLang.localString("ph_search"),
                                      text: $mapVM.txtSearch)
                                .foregroundStyle(Color.black.opacity(0.6))
                                .borderTextFieldMapStyle()
                                .onSubmit(of: .text) {
                                    
                                    mapVM.setMapLocationBySearch()
                                }
                            
                            Button(action: { mapVM.setMapLocationBySearch() }) {
                                
                                Label(appLang.localString("lbl_search"),
                                      systemImage: SFIcon.search.key)
                                .labelStyle(.iconOnly)
                                .foregroundStyle(Color.black.opacity(0.5))
                                .offset(x: -40)
                            }
                        }
                        .padding(6)
                        .frame(maxWidth: width,
                               maxHeight: 60)
                        .position(x: geo.size.width / 2 + 16,
                                  y: geo.size.height > 300 ?
                                        geo.size.height - 100 :
                                        geo.size.height - 50)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .mapScope(mapCtrlSpace)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

