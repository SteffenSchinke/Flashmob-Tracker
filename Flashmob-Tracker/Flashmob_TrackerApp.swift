//
//  Flashmob_TrackerApp.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//

import SwiftUI
import FirebaseCore

@main
struct Flashmob_TrackerApp: App {
    
    @State private var authUserVM: AuthUserVM
    @State private var appSettingsVM: AppSettingsVM
    @State private var pdfVM:PDFFileVM
    @State private var mediaVM: MediaFileVM
    @State private var eventVM: EventVM
    @State private var dashVM: DashboardVM
    @State private var mapVM: MapVM
    
    init() {
        
        // firebase core config
        setenv("GRPC_VERBOSITY", "ERROR", 1)
        setenv("GRPC_TRACE", "", 1)
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        
        let authVM: AuthUserVM = .init()
        let appVM: AppSettingsVM = .init()
        let pdfVM: PDFFileVM = .init()
        let mediaVM: MediaFileVM = .init()
        let mapVM: MapVM = .init()
        let dashVM: DashboardVM = .init()
        let eventVM: EventVM = .init(authVM, pdfVM, mediaVM, mapVM)
        
        
        self.authUserVM = authVM
        self.appSettingsVM = appVM
        self.pdfVM = pdfVM
        self.mediaVM = mediaVM
        self.mapVM = mapVM
        self.dashVM = dashVM
        self.eventVM = eventVM
        
        /// DEBUGING for view rendering errors
        // UserDefaults.standard.setValue(true, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        /// DEBUGING for warning
        /// "Failed to locate resource "default.csv"
        /// "Missing MeshRenderables for ground mesh layer for (2/2) of ground tiles. Tile debug info: (Key: 17614.10748.15.255 t:33 kt:0, Has mesh errors: 0, MeshInstance count: 33, PendingMaterial count: 33, Invisible MeshInstances count: 0 | Key: 17614.10749.15.255 t:33 kt:0, Has mesh errors: 0, MeshInstance count: 18, PendingMaterial count: 18, Invisible MeshInstances count: 0)"
        //if let path = Bundle.main.path(forResource: "default", ofType: "csv") {
        //    print("default.csv gefunden: \(path)")
        //} else {
        //    print("default.csv nicht gefunden")
        //}
    }
    
    var body: some Scene {
        
        WindowGroup {
            
            Launch()
                .preferredColorScheme(self.appSettingsVM.isDarkMode ? .dark : .light)
        }
        .environment(\.font, .custom("NovaSquare", size: 18, relativeTo: .body))
        .environment(self.authUserVM)
        .environment(self.appSettingsVM)
        .environment(self.pdfVM)
        .environment(self.mediaVM)
        .environment(self.mapVM)
        .environment(self.dashVM)
        .environment(self.eventVM)
    }
}
