//
//  SIgnUp.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI


struct SignUp: ContentView {
    
    @Namespace private var signupSpace
    
    @Environment(AuthUserVM.self) private var authUserVM
    
    @State private var showAGBSheet: Bool = false
    @State private var isExpanded1: Bool = false
    @State private var isExpanded2: Bool = false
    @State private var isExpanded3: Bool = false
    
    var localKey: String = "title_sign_up"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool { false }
    var sourceViewNamespace: Namespace.ID?  { self.signupSpace }
    
    var content: some View {
        
        @Bindable var authUserVM = self.authUserVM
        
        VStack {
            
            VStack {
                
                ProfileImageFile(authUserVM, 60)
                
                Text(appLang.localString(
                    authUserVM.userRule == .organizer ?
                        "title_logo_company" :
                        "title_logo_profile"))
                .font(.caption)
                .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity,
                   maxHeight: 150,
                   alignment: .top)
            
            VStack {
                Picker(selection: $authUserVM.userRule,
                       content: {
                    ForEach(AppUserRule.allCases, id: \.self) {  rule in
                        
                        Text(appLang.localString(rule.localKey)).tag(rule)
                    }},
                       label: {}
                )
                .background(Color.clear)
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity,
                   maxHeight: 40,
                   alignment: .top)
            
            Form {
                
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded1,
                        content: {
                            
                            VStack {
                                
                                if authUserVM.userRule == .organizer {
                                    
                                    BorderTextField(
                                        $authUserVM.companyName,
                                        "ph_company_name", "tip_company_name") {
                                            authUserVM.isCompanyNameValid() }
                                }
                                
                                BorderTextField(
                                    $authUserVM.firstName,
                                    "ph_first_name", "tip_name") {
                                        authUserVM.isFirstNameValid() }
                                
                                BorderTextField(
                                    $authUserVM.lastName,
                                    "ph_last_name", "tip_name") {
                                        authUserVM.isLastNameValid() }
                            }
                            .padding(.top, 25)
                            .listRowBackground(Color.clear)
                        },
                        label: {
                            Label(self.appLang.localString("title_profile"),
                                  systemImage: SFIcon.person.key)
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
                                
                                MapRect(.constant(true),
                                        .constant(false),
                                        .constant(false),
                                        .constant(false),
                                        .constant(true),
                                        self.sourceViewNamespace! ) { location in
                                            
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
                .listRowBackground(isExpanded2 ?
                                   Color.gray.opacity(0.3) :
                                    Color.clear)
                
                Section {
                    
                    DisclosureGroup(
                        isExpanded: $isExpanded3,
                        content: {
                            
                            VStack {
                                
                                BorderTextField(
                                    $authUserVM.email, "ph_email",
                                    "tip_email", .emailAddress) { authUserVM.isEmailValid() }
                                
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
                .listRowBackground(isExpanded3 ?
                                        Color.gray.opacity(0.3) :
                                        Color.clear)
                
                Toggle(isOn: $authUserVM.isAcceptedAGB) {
                    
                    VStack {
                        
                        Text(appLang.localString("agb_info1"))
                            .font(.custom("NovaSquare", size: 10))
                        
                        Text(appLang.localString("agb_title"))
                            .font(.custom("NovaSquare", size: 10))
                            .foregroundColor(.blue)
                            .underline()
                            .onTapGesture {
                                showAGBSheet = true
                            }
                        
                        Text(appLang.localString("agb_info2"))
                            .font(.custom("NovaSquare", size: 10))
                    }
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden, edges: .all)
                
                VStack {
                    
                    ButtonRect("btn_sign_up") {
                        
                        if authUserVM.isSignUpConform() {
                            
                            authUserVM.signUp()
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
            .frame(maxWidth: .infinity, maxHeight: .infinity,
                   alignment: .top)
            .scrollContentBackground(.hidden)
            .foregroundStyle(.black.opacity(
                    colorScheme == .dark ? 0.9 : 0.6))
        }
        .sheet(isPresented: $showAGBSheet) {
            
            SheetViewer("title_agb", "agb_complete")
        }
        .alert(appLang.localString(authUserVM.errorMessage),
               isPresented: $authUserVM.hasError) {}
    }
    
    func getLeadingMenu() -> AnyView {
        
        AnyView(
            
            Button(
                action: { authUserVM.authState = .inSignIn },
                label: {
                    
                    Label(appLang.localString("btn_back"),
                          systemImage: SFIcon.back.key)
                        .darkModeTintShadow()
                        .labelStyle(.iconOnly)
                }
            )
            .padding(.leading, 20)
        )
    }
    
    func getTrailingMenu() -> EmptyView  { EmptyView() }
}
