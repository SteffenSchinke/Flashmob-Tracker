//
//  Launch.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct Launch: View {
    
    @Environment(AuthUserVM.self) private var authUserVM
    
    var body: some View {
        
        NavigationStack {
            
            if [.inLoggedIn, .refreshedLogin].contains(self.authUserVM.authState)  {
                
                NavLaunch()
            } else  {
                
                AuthLaunch()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}


#Preview {
    
    let authUserVM = AuthUserVM()
    let appSettingsVM = AppSettingsVM()
    let pdfVM = PDFFileVM()
    let mediaVM = MediaFileVM()
    let dashVM = DashboardVM()
    let mapVM = MapVM()
    let eventVM = EventVM(authUserVM, pdfVM, mediaVM, mapVM)

    Launch() 
        .preferredColorScheme(appSettingsVM.isDarkMode ? .dark : .light)
        .environment(authUserVM)
        .environment(appSettingsVM)
        .environment(pdfVM)
        .environment(mediaVM)
        .environment(mapVM)
        .environment(dashVM)
        .environment(eventVM)
}
