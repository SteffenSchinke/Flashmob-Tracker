//
//  AppSettings.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct AppSettings: ContentView {
    
    @Namespace private var settingSpace
    
    @Environment(AuthUserVM.self) private var authUserVM
    @Environment(AppSettingsVM.self) private var appSettingsVM
    
    @Bindable private var appLang: AppLocalization = .shared
    
    var localKey: String = "title_settings"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool { false }
    var sourceViewNamespace: Namespace.ID? { self.settingSpace }
    
    var content: some View {
        
        VStack {
            
            @Bindable var appSettingsVM = self.appSettingsVM
            
            Form {
                
                Section(
                    
                    header:
                        
                        Label(appLang.localString("title_global"),
                              systemImage: SFIcon.globe.key),
                    content: {
                        
                        Picker(selection: self.$appLang.selectedLanguageIndex,
                               content: {
                            ForEach(AppLanguage.allCases, id: \.id) { lng in
                                
                                Text(appLang.localString(lng.localKey)).tag(lng.id)
                            }},
                               label: { Text(appLang.localString("title_lang")) })
                        .pickerStyle(.menu)
                        
                        Toggle(appLang.localString("title_dark_mode"),
                               isOn: $appSettingsVM.isDarkMode)
                        
                        Toggle(appLang.localString("title_anime_mode"),
                               isOn: $appSettingsVM.isAnimeBackground)
                        
                    }
                )
                .listRowBackground(Color.clear)
                
                Section(
                    
                    header:
                        
                        Label(appLang.localString("title_notice"),
                              systemImage: SFIcon.widget.key),
                    content: {
                        
                        Toggle(appLang.localString("title_notice_allowed"),
                               isOn: $appSettingsVM.isNoticeAllowed)
                        
                        Toggle(appLang.localString("title_notice_new_events_allowed"),
                               isOn: $appSettingsVM.isNoticeNewEventsAllowed)
                        .disabled(!appSettingsVM.isNoticeAllowed)
                        
                        Toggle(appLang.localString("title_notice_new_massege_allowed"),
                               isOn: $appSettingsVM.isNoticeNewMessageAllowed)
                        .disabled(!appSettingsVM.isNoticeAllowed)
                        
                        Toggle(appLang.localString("title_notice_memories_allowed"),
                               isOn: $appSettingsVM.isNoticeMemoriesAllowed)
                        .disabled(!appSettingsVM.isNoticeAllowed)
                    }
                )
                .listRowBackground(Color.clear)
                
                Section(
                    
                    header:
                        
                        Label(appLang.localString("title_informations"),
                              systemImage: SFIcon.info.key),
                    content: {
                       
                        List{
                            
                            NavigationLink(
                                value: NavLinkSetting(tabIndex: .agb,
                                                      nameSpace: self.settingSpace),
                                label: {
                                    Text(appLang.localString("title_agb"))
                                        .matchedTransitionSource(
                                            id: NavTabIndex.agb,
                                            in: self.settingSpace)
                                }
                            )
                            
                            NavigationLink(
                                value: NavLinkSetting(tabIndex: .dsgvo,
                                                      nameSpace: self.settingSpace),
                                label: {
                                    Text(appLang.localString("title_dgsvo"))
                                        .matchedTransitionSource(
                                            id: NavTabIndex.dsgvo,
                                            in: self.settingSpace)
                                }
                            )
                            
                            Text(appLang.localString("title_datasource"))
                                .font(.caption2)
                        }
                    }
                )
                .listRowBackground(Color.clear)
            }
            .padding(.top, -10)
            .scrollContentBackground(.hidden)
            .foregroundStyle(.black.opacity(appSettingsVM.isDarkMode ? 0.9 : 0.6))
        }
        .padding(.horizontal, 10)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    func getTrailingMenu() -> AnyView  {
        
        AnyView(
            
            Menu {
                
                Button(action: { self.authUserVM.signOut() }) {
                    Label(appLang.localString("btn_sign_out"),
                          systemImage: SFIcon.signOut.key)
                }
            } label: {
                
                Label(appLang.localString("title_menu"),
                      systemImage: SFIcon.menu.key)
                    .darkModeTintShadow()
                    .labelStyle(.iconOnly)
                
            }
            .menuStyle(.automatic)
        )
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
}
