//
//  CreateEventVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 24.02.25.
//


import SwiftUI
import Observation


@Observable
final class EventVM: ViewModelBaseClass {
    
    var event: Event?
    
    var title: String = "" {
        didSet { self.event?.title = self.title }
    }
    var motto: String = "" {
        didSet { self.event?.motto = self.motto }
    }
    var desc: String = "" {
        didSet { self.event?.desc = self.desc }
    }
    var selectedDate: Date = Date() {
        didSet { self.event?.date = self.selectedDate }
    }
    var maxActorCount: Int = 100 {
        didSet { self.event?.participantRequiredCount = self.maxActorCount }
    }
    var searchActorCount: Int = 30 {
        didSet { self.event?.participantAvailableCount = self.searchActorCount }
    }
    
    private var repo: EventFirebase = .init()
    private var authVM: AuthUserVM
    private var pdfVM: PDFFileVM
    private var mediaVM: MediaFileVM
    private var mapVM: MapVM
    
    
    init( _ authVM: AuthUserVM,
          _ pdfVM: PDFFileVM,
          _ mediaVM: MediaFileVM,
          _ mapVM: MapVM) {
        
        self.authVM = authVM
        self.pdfVM = pdfVM
        self.mediaVM = mediaVM
        self.mapVM = mapVM
        
        super.init()
        self.isWorking = false
    }
    
    func createTempEvent() {
        
        Task {
            
            await self.setIsWorking(true)
            
            do {
                
                self.event = Event(repo.createUniqueId(), self.authVM.authUser.id)
                try repo.insert(self.event!)
                
            } catch {
                
                self.setError(error.localizedDescription)
            }
            
            await self.setIsWorking(false)
        }
    }
    
    func deleteTempEvent() {
        
        if let tempEvent = self.event {
            
            Task {
                
                await self.setIsWorking(true)
                
                print("start delete func()")
                
                do {
                    
                    let store: FlashmobStore = .shared
                    
                    // wait for running upload
                    var isUploadComplete: Int = 0
                    while isUploadComplete < self.mediaVM.uploadedMediaList.count {
                        
                        isUploadComplete = 0
                        for (_, mediaFile) in self.mediaVM.uploadedMediaList {
                            
                            isUploadComplete += mediaFile.isInUploading ? 0 : 1
                        }
                        
                        try await Task.sleep(for: .milliseconds(500))
                        print("wait for media upload end...")
                    }
                    
                    // delete uploaded files
                    for (_, mediaFile) in self.mediaVM.uploadedMediaList {
                        
                        let urlString = mediaFile.url?.absoluteString ?? ""
                        try? await store.deleteFile(urlString,
                                                    FlashmobStoreKey.eventMedia.key,
                                                    self.authVM.authUser.id)
                    }
                    self.mediaVM.uploadedMediaList.removeAll()
                    
                    
                    // wait for running upload
                    isUploadComplete = 0
                    while isUploadComplete < self.pdfVM.uploadedPDFList.count {
                        
                        isUploadComplete = 0
                        for (_, pdfFile) in self.pdfVM.uploadedPDFList {
                            
                            isUploadComplete += pdfFile.isInUploading ? 0 : 1
                        }
                        
                        try await Task.sleep(for: .milliseconds(500))
                        print("wait for pdf upload end...")
                    }
                    
                    // delete uploaded files
                    for (_, pdfFile) in self.pdfVM.uploadedPDFList {
                        
                        let urlString = pdfFile.url?.absoluteString ?? ""
                        try? await store.deleteFile(urlString,
                                                    FlashmobStoreKey.eventPDF.key,
                                                    self.authVM.authUser.id)
                    }
                    self.pdfVM.uploadedPDFList.removeAll()
                    
                    try await repo.delete(tempEvent)
                } catch {
                    
                    self.setError(error.localizedDescription)
                }
                
                print("end delete func()")
                
                await self.setIsWorking(false)
            }
        }
    }
    
    func insertEvent() {
        
        Task {
            
            await self.setIsWorking(true)
            
            do {
                
                if var event = self.event {
                    
                    for (_, mediaFile) in self.mediaVM.uploadedMediaList {
                        
                        event.medias.append(mediaFile)
                    }
                    
                    for (_, pdfFile) in self.pdfVM.uploadedPDFList {
                        
                        event.documents.append(pdfFile)
                    }
                    
                    try self.repo.insert(event)
                }
            } catch {
                
                self.setError(error.localizedDescription)
            }
            
            await self.setIsWorking(false)
        }
    }
    
    func isTitleValid() -> Bool {
        
        RegExpNotation.text.checkValue(event?.title ?? "")
    }
    
    func isMottoValid() -> Bool {
        
        RegExpNotation.text.checkValue(event?.motto ?? "")
    }
    
    func isDescriptionValid() -> Bool {
        
        RegExpNotation.text.checkValue(event?.desc ?? "")
    }
    
    func isDateValid() -> Bool {
        
        event?.date != nil
    }
    
    func isLocationValid() -> Bool {
        
        event?.location != nil
    }
    
    func isTeamValid() -> Bool {
        
        event?.participantAvailableCount ?? 0 > 0
    }
    
    func isMediaFileValid() -> Bool {
        
        for (_, mediaFile) in self.mediaVM.uploadedMediaList {
            
            if mediaFile.isInUploading { return false }
        }
        
        return true
    }
    
    func isPDFFileValid() -> Bool {
        
        for (_, pdfFile) in self.pdfVM.uploadedPDFList {
            
            if pdfFile.isInUploading { return false }
        }
        
        return true
    }
    
    func isFormConform() -> Bool {
        
        guard self.isTitleValid() else {
            
            setError( "Bitte gebe dem Event einen Titel.")
            return false
        }
        
        guard self.isMottoValid() else {
            
            setError( "Bitte gebe dem Event einen Motto.")
            return false
        }
        
        guard self.isDescriptionValid() else {
            
            setError( "Bitte gebe einer Beschreibung für das Event ein.")
            return false
        }
        
        guard self.isDateValid() else {
            setError( "Bitte wähle ein Datum und Uhrzeit für das Event aus.")
            return false
        }
  
        guard self.isLocationValid() else {
            setError("Bitte wähle eine Location für das Event aus.")
            return false
        }
             
        guard self.isTeamValid() else {
            setError("Bitte erstelle ein Team für das Event aus.")
            return false
        }
   
        guard self.mediaVM.uploadedMediaList.count > 0 else {
        
            self.setError("Bitte füge mindestens ein Foto zu den Motivation hinzu.")
            return false
        }
        
        return true
    }
}
