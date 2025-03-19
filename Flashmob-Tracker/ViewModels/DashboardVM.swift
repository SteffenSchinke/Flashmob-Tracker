//
//  DashboardVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 05.03.25.
//


import SwiftUI
import Observation


@Observable
final class DashboardVM: ViewModelBaseClass {
    
    var events: [Event] = []
    var organizers: [Organizer] = []
    
    private var repoEvent: EventFirebase = .init()
    private var repoOrganizer: AppUserFirebase = .init()
    
    override init() {
        
        super.init()
        observeEvents()
    }
    
    func loadOrganizers( _ appUserId: String) async {
        
        await self.setIsWorking(true)
        
        do {
            
            self.organizers =
                    try await self.repoOrganizer.fetchAll(Organizer.self)
            self.organizers.removeAll { $0.id == appUserId }
        } catch {
            
            setError(error.localizedDescription)
        }
        
        await self.setIsWorking(false)
    }
    
    func loadEvents() async {
        
        await self.setIsWorking(true)
        
        do {
            
            self.events = try await self.repoEvent.fetchAll(Event.self)
        } catch {
            
            setError(error.localizedDescription)
        }
        
        await self.setIsWorking(false)
    }
    
    private func observeEvents() {
        
        self.isWorking = true
        
        repoEvent.observeAll() { events in
            
            self.events = events
            self.isWorking = false
        }
    }
}
