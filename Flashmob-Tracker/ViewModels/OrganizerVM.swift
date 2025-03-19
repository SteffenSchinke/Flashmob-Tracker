//
//  OrganizerVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 16.03.25.
//


import Observation


@Observable
final class OrganizerVM: ViewModelBaseClass {
    
    private let repoOrg: AppUserFirebase = .init()
    private let repoEvents: EventFirebase = .init()
    
    var org: Organizer?
    var orgEvents: [Event] = []
    
    override init() {
        
        super.init()
        self.isWorking = false
    }
    
    func loadOrg( _ organizerId: String) {
        
        Task {
            
            await self.setIsWorking(true)
            
            self.org = try await self.repoOrg.fetch(Organizer.self, organizerId)
            self.orgEvents = try await self.repoEvents.fetchOrgEvents(Event.self, organizerId)
            
            await self.setIsWorking(false)
        }
    }
}
