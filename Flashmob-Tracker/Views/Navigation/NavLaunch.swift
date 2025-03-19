//
//  Navigation.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct NavLaunch: View {
    
    @Environment(AppSettingsVM.self) private var appSettingsVM
    
    var body: some View {
        
        @Bindable var appSettingsVM = appSettingsVM
        
        TabView(selection: $appSettingsVM.selectedNavTabIndex) {
            
            Tab("title_dashboard",
                systemImage: SFIcon.dashboard.key,
                value: NavTabIndex.dashboard.index) {
                
                Dashboard()
            }
            
            Tab("title_flashmobs",
                systemImage: SFIcon.map.key,
                value: NavTabIndex.map.index) {
                
                FlashmobMap()
            }
            
            Tab("title_settings",
                systemImage: SFIcon.setting.key,
                value: NavTabIndex.appSetting.index) {
                
                AppSettings()
            }
        }
        .tabViewStyle(.page)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .task {
            
            UIPageControl.updateAppearance(colorScheme)
        }
        .onChange(of: appSettingsVM.isDarkMode) { _, _ in
            
            UIPageControl.updateAppearance(colorScheme)
        }
        .navigationDestination(for: NavLinkSetting.self) { link in
            
            if link.tabIndex == .agb {
                
                SheetViewer("title_agb", "agb_complete")
                    .navigationTransition(
                        .zoom(sourceID: NavTabIndex.agb,
                              in: link.nameSpace))
            } else if link.tabIndex == .dsgvo {
                
                SheetViewer("title_dgsvo", "dsgvo_complete")
                    .navigationTransition(
                        .zoom(sourceID: NavTabIndex.dsgvo,
                              in: link.nameSpace))
            }
        }
        .navigationDestination(for: NavLinkDash.self) { link in
            
            if link.tabIndex == .filter {
                
                Filter()
                    .navigationTransition(
                        .zoom(sourceID: NavTabIndex.filter,
                              in: link.nameSpace))
            } else if link.tabIndex ==  .create {
                
                Create()
                    .navigationTransition(
                        .zoom(sourceID: NavTabIndex.create,
                              in: link.nameSpace))
            } else if link.tabIndex == .detail {
                
                EventDetail(link.navObjectId)
                    .navigationTransition(
                        .zoom(sourceID: link.navObjectId,
                              in: link.nameSpace))
            }
        }
        .navigationDestination(for: NavLinkPDF.self, destination: { link in
            
            PDFViewer(link.url)
                .navigationTransition(
                    .zoom(sourceID: link.id,
                          in: link.nameSpace))
        })
        .navigationDestination(for: NavLinkMap.self, destination: { link in
            
            if link.annoType == Event.self  {
                
                EventDetail(link.annoId)
                    .navigationTransition(
                        .zoom(sourceID: link.annoId,
                              in: link.nameSpace))
            } else if link.annoType == Organizer.self {
                
                OrganizerDetail(link.annoId)
                    .navigationTransition(
                        .zoom(sourceID: link.annoId,
                              in: link.nameSpace))
            }
            
            
        })
        .navigationDestination(for: NavLinkProfile.self , destination: { link in
            
            Profile()
                .navigationTransition(
                    .zoom(sourceID: link.profileId,
                          in: link.nameSpace))
        })
    }
}
