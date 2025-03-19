//
//  OrganizerDetail.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 16.03.25.
//


import SwiftUI


struct OrganizerDetail: ContentView{
    
    @Namespace private var orgSpace
    
    @State private var orgVM: OrganizerVM = .init()
    
    var localKey: String = "title_organizer"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool { false }
    var sourceViewNamespace: Namespace.ID? { self.orgSpace }
    
    var organizerId: String

    private let size: CGSize = CGSize(width: 100, height: 100)
    private let radius: CGFloat = 50
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 165), spacing: 10)
    ]
    
    
    init( _ organizerId: String) {
        
        self.organizerId = organizerId
    }
    
    var content: some View {
        
        VStack {
            
            orgPicture
            
            orgTitle
            
            orgEvents
        }
        .task {
            
            self.orgVM.loadOrg(organizerId)
        }
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() -> AnyView {
        
        AnyView(
            
            ButtonDismiss()
        )
    }
    
    private var orgTitle: some View {
        
        VStack{
            
            Text("\(self.orgVM.org?.companyName ?? "")")
                .darkModeForegroundShadow(26)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("\(self.orgVM.org?.location?.street ?? "")")
                .darkModeForegroundShadow(18)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Text("\(self.orgVM.org?.location?.zipCode ?? "") \(self.orgVM.org?.location?.city ?? "")")
                .darkModeForegroundShadow(18)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    private var orgEvents: some View {
        
        VStack {
            
            Text(self.appLang.localString("title_org_list"))
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .darkModeForegroundShadow(18)
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 5) {
                        
                        ForEach(self.orgVM.orgEvents, id: \.id) { event in
                            
                            NavigationLink(
                                value: NavLinkDash(navObjectId: event.id,
                                                   tabIndex: .detail,
                                                   nameSpace: self.orgSpace),
                                label: {
                                    ListItem(event, CGSize(width: 165, height: 165))
                                        .matchedTransitionSource(
                                            id: event.id,
                                            in: self.orgSpace)
                                }
                            )
                            .buttonStyle(.plain)
                            .padding()
                        }
                    }
                }
                .padding(.bottom, 60)
            }
            .padding(.vertical, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    private var orgPicture: some View {
        
        VStack {
            
            Group {
                
                if let data = self.orgVM.org?.profileImage?.fileData,
                   let uiImage = UIImage(data: data) {
                    
                    Image(uiImage: uiImage)
                        .resizable()
                } else if let imageURL = self.orgVM.org?.profileImage?.url {
                    
                    AsyncImage(url: imageURL) { phase in
                        if let img = phase.image {
                            img.resizable()
                        }
                    }
                } else {
                    
                    Image(systemName: "photo")
                        .font(.system(size: ((self.radius * 2) / 3)))
                }
            }
            .scaledToFill()
            .frame(width: self.size.width, height: self.size.height)
            .tint(colorScheme == .dark ? .gray : .white)
            .foregroundStyle(colorScheme == .dark ? .gray : .white)
            .frame(width: self.size.width, height: self.size.height)
            .clipShape(
                
                RoundedRectangle(cornerRadius: self.radius)
            )
            .overlay(
                
                RoundedRectangle(cornerRadius: self.radius)
                    .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 0.7)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: self.size.height, alignment: .top)
    }
}
