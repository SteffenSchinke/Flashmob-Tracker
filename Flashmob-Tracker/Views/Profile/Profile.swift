//
//  Profile.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 21.02.25.
//


import SwiftUI

struct Profile: ContentView {
    
    @Namespace private var profileSpace
    
    @Environment(AuthUserVM.self) private var authUserVM
    @Environment(MapVM.self) private var mapVM
    @Environment(\.dismiss) private var dismiss
    
    @State private var profilVM: ProfileVM = .init()
    @State private var tempImageInfos: FlashmobStoreFile?
    @State private var isExpanded1: Bool = true
    @State private var isExpanded2: Bool = false
    
    var localKey: String = "title_create_event"
    var headerMode: HeaderDisplayMode = .onlyMenu
    var isViewModelinWorking: Bool { self.profilVM.isWorking }
    var sourceViewNamespace: Namespace.ID? { self.profileSpace }
    
    
    private var flStore: FlashmobStore = .shared
    
    init() {
        
        print("Profile init() ... ")
    }
    
    var content: some View {
        
        let firstName = authUserVM.authUser.firstName ?? ""
        let lastName = authUserVM.authUser.lastName ?? ""
        let rule = self.appLang.localString(authUserVM.authUser.userRule.localKey)
        let email = authUserVM.authUser.email ?? ""
        
        @Bindable var authUserVM = self.authUserVM
        
        VStack {
        
            VStack {
                
                ProfileImageFile(self.authUserVM, 100)
                    
                Text("\(firstName) \(lastName)")
                    .darkModeForegroundShadow(32)
                    
                Text("\(rule)")
                    .darkModeForegroundShadow(26)
                    
                Text("\(email)")
                    .darkModeForegroundShadow(18)

            }
            .frame(maxWidth: .infinity, alignment: .top)
            
            VStack {
                Form {
                    
                    
                    Section {
                        
                        DisclosureGroup(
                            isExpanded: $isExpanded1,
                            content: {
                                
                                VStack {
                                    
                                    MapRect(.constant(true),
                                            .constant(false),
                                            .constant(false),
                                            .constant(false),
                                            .constant(true),
                                            self.sourceViewNamespace!) { location in
                                                
                                                self.authUserVM.location = location
                                            }
                                            .cornerRadius(16)
                                            .frame(height: 300)
                                            .padding(.top, 32)
                                }
                                .listRowBackground(Color.clear)
                            },
                            label: {
                                Label(self.appLang.localString("title_location"),
                                      systemImage: SFIcon.mappin_map.key)
                            })
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    .listRowBackground(isExpanded1 ?
                                       Color.gray.opacity(0.3) :
                                        Color.clear)
                    
                    Section {
                        
                        DisclosureGroup(
                            isExpanded: $isExpanded2,
                            content: {
                                
                                VStack {
                                    
                                    BorderSecureTextField(
                                        $authUserVM.pwd, "ph_pwd", "tip_pwd") {
                                            authUserVM.isPasswordValid() }
                                    
                                    BorderSecureTextField(
                                        $authUserVM.pwd2, "ph_pwd_conform",
                                        "tip_pwd_conform") { (authUserVM.isPasswordValid() &&
                                                              authUserVM.isPasswordConform()) }
                                }
                                .padding(.top, 25)
                                .listRowBackground(Color.clear)
                            },
                            label: {
                                Label(self.appLang.localString("title_auth"),
                                      systemImage: SFIcon.person_auth.key)
                            })
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    .listRowBackground(isExpanded2 ?
                                       Color.gray.opacity(0.3) :
                                        Color.clear)
                    
                    
                    VStack {
                        
                        ButtonRect("btn_save") {
                            
                            if authUserVM.isProfileConform() {
                                
                                Task {
                                    
                                    await authUserVM.updateAuthUser()
                                    self.mapVM.deleteProfileLocation(self.authUserVM.authUser)
                                    dismiss()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity,
                               alignment: .center)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden, edges: .all)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .padding(.bottom, 40)
                }
                .scrollContentBackground(.hidden)
                .foregroundStyle(.black.opacity(
                        colorScheme == .dark ? 0.9 : 0.6))
            }
        }
        .padding(.top, -40)
        .alert(self.appLang.localString(self.authUserVM.errorMessage),
               isPresented: $authUserVM.hasError) {}
        .task {
            
            print("Profile task() ... auth is working:\(self.authUserVM.isWorking)")
            
            self.authUserVM.isWorking = false
            self.profilVM.setAuthUserVM(self.authUserVM)
            self.tempImageInfos = self.authUserVM.authUser.profileImage
            self.authUserVM.location = self.authUserVM.authUser.location
            self.mapVM.insertProfileLocation(self.authUserVM.authUser)
        }
        .onDisappear {
            
            self.mapVM.deleteProfileLocation(self.authUserVM.authUser)
        }
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() -> AnyView  { AnyView(
        
        ButtonDismiss() {
   
            if let tempImageInfos = self.tempImageInfos {
               
                self.authUserVM.authUser.profileImage = tempImageInfos
            }
        }
    )}
}
