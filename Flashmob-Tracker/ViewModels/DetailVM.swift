//
//  DetailVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 11.03.25.
//


import SwiftUI
import Observation


@Observable
final class DetailVM: ViewModelBaseClass {
    
    var event: Event?
    
    private var repo: EventFirebase = .init()
    private var appUserId: String?
    
    override init() {
        
        super.init()
        self.isWorking = false
    }
    
    func loadEvent( _ eventId: String,
                    _ appUserId: String,
                    onEvent: @escaping (Event) -> Void) async {
        
        await self.setIsWorking(true)
        
        self.appUserId = appUserId
        
        repo.observeOne(eventId) { event in
            
            self.event = event
            onEvent(event)
            
            self.isWorking = false
            
        } onError: { error in
            
            self.setError(error.localizedDescription)
        }
    }
    
    func setMediaFileToTitleTheme( _ mediaFile: FlashmobStoreFile) {
        
        Task {
            
            await self.setIsWorking(true)
            
            do {
                
                if var event = self.event,
                   event.organizerId == self.appUserId,
                   event.medias.contains(where: { $0.id == mediaFile.id }) {
                    
                       event.medias.removeAll(where: { $0.id == mediaFile.id })
                       event.medias.insert(mediaFile, at: 0)
                       
                       try await self.repo.update(event)
                }
            } catch {

                self.setError(error.localizedDescription)
            }
            
            await self.setIsWorking(false)
        }
    }
}
