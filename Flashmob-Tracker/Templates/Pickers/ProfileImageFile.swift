//
//  ProfilePicture.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI
import PhotosUI


struct ProfileImageFile: View {
    
    @Environment(AppSettingsVM.self) private var appSettingsVM
    @Bindable var authUserVM: AuthUserVM
    @State private var pictureVM: ProfileImageFileVM
    
    private var isEnabled: Bool = false
    private var radius: CGFloat
    private var size: CGSize
    
    init( _ authUserVm: AuthUserVM, _ radius: CGFloat, _ isEnabled: Bool = true) {
        
        self.isEnabled = isEnabled
        self.radius = radius
        self.size = CGSize(width: radius * 2, height: radius * 2)
        self.authUserVM = authUserVm
        self.pictureVM = .init(authUserVm)
    }
    
    var body: some View {
        
        ZStack {
            
            if self.isEnabled {
                
                self.imageViewer
                if self.authUserVM.authUser.profileImage.source != .sozialMedia {
                    
                    self.pickerViewer
                }
            } else {
                
                self.imageViewer
            }
        }
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
        .onChange(of: pictureVM.selectedPhoto) { _, _ in
            
            pictureVM.loadImagefromPicker()
        }
    }
    
    private var imageViewer: some View {
        
        Group {
            
            if let data = self.authUserVM.authUser.profileImage.fileData,
               let uiImage = UIImage(data: data) {
                
                Image(uiImage: uiImage)
                    .resizable()
            } else if let imageURL = self.authUserVM.authUser.profileImage.url {
                
                AsyncImage(url: imageURL) { phase in
                    if let img = phase.image {
                        img.resizable()
                    }
                }
            } else {
                
                Image(systemName: authUserVM.userRule == .organizer ? "photo" : "person.circle")
                    .font(.system(size: ((self.radius * 2) / 3)))
            }
        }
        .scaledToFill()
        .frame(width: self.size.width, height: self.size.height)
    }
    
    private var pickerViewer: some View {
        
        PhotosPicker(
            selection: $pictureVM.selectedPhoto,
            matching: .images,
            photoLibrary: .shared(),
            label: {
                
                Image(systemName: authUserVM.userRule == .organizer ? "photo" : "person.circle")
                    .font(.system(size: ((self.radius * 2) / 3)))
            })
    }
}
