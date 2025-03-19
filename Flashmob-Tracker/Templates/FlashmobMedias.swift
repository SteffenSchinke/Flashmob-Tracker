//
//  File.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 06.03.25.
//


import SwiftUI
import AVKit


struct FlashmobMedias: View {
    
    @State var avPlayer: AVPlayer?
    @State var isLoading: Bool = false
    
    private var mediaFile: FlashmobStoreFile?
    private var size: CGSize
    private var volume: Float = 0.0
    
    var twoTapGestureAction: (FlashmobStoreFile) -> Void
    
    init( _ mediaFile: FlashmobStoreFile?,
          _ size: CGSize = CGSize(width: 160, height: 160),
          _ videoVolume: Float = 0.0,
          _ twoTapGestureAction: @escaping (FlashmobStoreFile) -> Void = { _ in } ) {
        
        self.mediaFile = mediaFile
        self.size = size
        self.volume = videoVolume
        self.twoTapGestureAction = twoTapGestureAction
    }
    
    var body: some View {
        
        HStack {
            
            if let media = mediaFile,
               let url = media.url {
                
                if [.mov, .mp4].contains(where: { $0 == media.ext}) {
                    
                    
                    ScaledVideoPlayer(self.avPlayer)
                        .frame(width: self.size.width,
                               height: self.size.height)
                        .clipped()
                        .task {
                            
                            self.setUrlForAVPlayer(url)
                            self.avPlayer?.play()
                        }
                        .onDisappear {
                            
                            self.avPlayer?.pause()
                        }
                        .overlay {
                            
                            if self.isLoading {
                                
                                ProgressView()
                                    .progressViewStyle()
                            }
                        }
                } else if media.ext == .pdf {
                    
                    if let thumb = media.thumbnail {
                        
                       Image(uiImage: thumb)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: self.size.width, maxHeight: self.size.height)
                    } else {
                        
                        ProgressView()
                            .progressViewStyle()
                    }
                
                } else {
                    
                    AsyncImage(url: url) { image in
                        image
                            .resizable(resizingMode: .stretch)
                            .scaledToFill()
                    } placeholder: {
                        
                        ProgressView()
                            .progressViewStyle()
                    }
                    .frame(maxWidth: self.size.width, maxHeight: self.size.height)
                }
            }
        }
        .foregroundStyle(colorScheme == .dark ? .gray : .white)
        .frame(maxWidth: self.size.width, maxHeight: self.size.height)
        .clipShape(
            
            RoundedRectangle(cornerRadius: 8)
        )
        .overlay(
            
            RoundedRectangle(cornerRadius: 8)
                .stroke(colorScheme == .dark ? .gray : .white, lineWidth: 0.7)
        )
        .onTapGesture(count: 2,
                      perform: { if let event = self.mediaFile {
                          self.twoTapGestureAction(event) }}
        )
    }
    
    private func setUrlForAVPlayer( _ url: URL ) {
        
        Task { @MainActor in
            
            self.isLoading = true
            
            let playerItem = AVPlayerItem(url: url)
            let player = AVPlayer(playerItem: playerItem)
            self.avPlayer = player
            player.volume = self.volume
            player.play()
            
            do {
                
                while playerItem.status != .readyToPlay {
                    
                    try await Task.sleep(for: .milliseconds(500))
                }
            } catch {
                
                print(error.localizedDescription)
            }
            
            self.isLoading = false
        }
    }
    
    struct ScaledVideoPlayer: UIViewControllerRepresentable {
        
       var player: AVPlayer?
        
        init( _ player: AVPlayer? = nil) {
            
            self.player = player
        }
        
        func makeUIViewController(context: Context) -> UIViewController {
            
            let controller = UIViewController()
            let playerLayer = AVPlayerLayer(player: player)
            
            playerLayer.videoGravity = .resizeAspectFill
            controller.view.layer.addSublayer(playerLayer)

            return controller
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            
            if let playerLayer = uiViewController.view.layer.sublayers?.first as? AVPlayerLayer {
                
                playerLayer.player = player
                playerLayer.frame = uiViewController.view.bounds
            }
        }
    }
}

