//
//  PictureVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 12.02.25.
//


import SwiftUI
import PhotosUI
import Observation


@Observable
final class ProfileImageFileVM: ViewModelBaseClass {
    
    var authUserVM: AuthUserVM
    var selectedPhoto: PhotosPickerItem?
    
    init( _ authUserVm: AuthUserVM) {
        
        self.authUserVM = authUserVm
    }
    
    func loadImagefromPicker() {
        
        Task {
            
            if let item = selectedPhoto,
               let data = try? await item.loadTransferable(type: Data.self) {
                
                var newImgInfos: FlashmobStoreFile = .init(authUserVM.authUser.id)
            
                newImgInfos.size = data.count
                newImgInfos.fileData = data
                newImgInfos.source = .custom
                newImgInfos.isChanged = true
                newImgInfos.uploadedAt = .now
                
                self.authUserVM.authUser.profileImage = newImgInfos
            }
        }
    }
}
