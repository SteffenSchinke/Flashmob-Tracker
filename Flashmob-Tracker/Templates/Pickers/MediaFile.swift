//
//  Media.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 26.02.25.
//


import SwiftUI
import PhotosUI
import AVKit


struct MediaFile: View {
    
    @Environment(AuthUserVM.self) private var authUserVM
    @Environment(MediaFileVM.self) private var mediaVM
    
    @State private var showMediaPicker: Bool = false
    
    var body: some View {
        
        @Bindable var mediaVM = self.mediaVM
        
        HStack(alignment: .top) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    
                    ForEach(Array(self.mediaVM.uploadedMediaList), id: \.key) { key, media in
                        
                        ZStack {
                            
                            if let url = media.url,
                               media.ext == .mp4 {
                                
                                VideoPlayer(player: AVPlayer(url: url))
                                    .frame(width: 90, height: 90)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                                
                                Button( action: { self.mediaVM.deleteMediaFile(media, self.authUserVM.authUser.id) }) {
                                    
                                    Image(systemName: "trash.circle")
                                        .darkModeForegroundShadow(24)
                                }
                                .position(x: 18, y: 18)
                            } else if let data = media.fileData,
                                      let uiImage = UIImage(data: data) {
                                
                                let image = Image(uiImage: uiImage)
                                
                                image
                                    .resizable()
                                    .dynamicSizeModifier(uiImage)
                                    .scaledToFill()
                                
                                Button( action: {
                                    self.mediaVM.deleteMediaFile(
                                        media,
                                        self.authUserVM.authUser.id) }) {
                                    
                                    Image(systemName: "trash.circle")
                                        .darkModeForegroundShadow(24)
                                }
                                .position(x: 18, y: 18)
                            } else {
                                
                                ProgressView()
                                    .progressViewStyle()
                                    .frame(width: 90, height: 90)
                            }
                        }
                        .frame(width: 90, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.colorScheme == .light ?
                                        Color.white.opacity(0.4) :
                                            Color.gray.opacity(0.4), lineWidth: 0.8)
                                .frame(width: 90, height: 90)
                        )
                    }
                }
            }
            Button( action: {
                
                showMediaPicker = true
            }) {
                
                Image(systemName: "plus.circle")
                    .darkModeForegroundShadow(24)
            }
            .frame(width: 30, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, maxHeight: 98)
        .photosPicker(isPresented: self.$showMediaPicker,
                      selection: $mediaVM.selectedMedia,
                      matching: .any(of: [.images, .videos]))
        .onChange(of: self.mediaVM.selectedMedia) { _, _ in
            
            if let _ = self.mediaVM.selectedMedia {
                
                self.mediaVM.uploadMediaFile()
            }
        }
    }
}
