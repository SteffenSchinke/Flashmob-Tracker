//
//  MediaVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 26.02.25.
//


import SwiftUI
import PhotosUI
import Observation


@Observable
final class MediaFileVM: ViewModelBaseClass {
    
    var uploadedMediaList: [String: FlashmobStoreFile] = [:]
    var selectedMedia: PhotosPickerItem?
    
    func uploadMediaFile() {
        
        Task {
            
            do {
                
                if let item = self.selectedMedia,
                   let data = try await item.loadTransferable(type: Data.self) {
                    
                    let uuid = UUID().uuidString
                    let tempMedia = FlashmobStoreFile(uuid)
                    self.uploadedMediaList[uuid] = tempMedia
                    
                    let fileStore: FlashmobStore = .shared
                    var newFile = try await fileStore.uploadFile(data, FlashmobStoreKey.eventMedia.key)
                    
                    newFile.id = uuid
                    newFile.fileData = data
                    newFile.isInUploading = false
                    
                    // TODO sts 04.03.25 - eventVM doesn't get any updates
                    Task { @MainActor in
                        
                        self.uploadedMediaList.removeValue(forKey: uuid)
                        self.uploadedMediaList[uuid] = newFile
                        self.selectedMedia = nil
                    }
                }
            } catch {
                
                // TODO error handling
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteMediaFile( _ item: FlashmobStoreFile, _ appUserId: String) {
        
        if let url = item.url {
           
            Task {
                
                do {
                    
                    let fileStore: FlashmobStore = .shared
                    try await fileStore.deleteFile(url.lastPathComponent,
                                                   FlashmobStoreKey.eventMedia.key,
                                                   appUserId)
                    
                    self.uploadedMediaList.removeValue(forKey: item.id)
                } catch {
                    
                    // TODO error handling
                    print(error.localizedDescription)
                }
            }
        }
    }
}
