//
//  EventFirebase.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 02.03.25.
//


import FirebaseFirestore


final class EventFirebase: Repository {
    
    private let collection = Firestore.firestore().collection(FireStoreKey.events.key)
    
    private var listenerAll: ListenerRegistration?
    private var listenerOne: ListenerRegistration?
    
    deinit {
        
        self.listenerAll?.remove()
        self.listenerOne?.remove()
        
        self.listenerAll = nil
        self.listenerOne = nil
    }
    
    func fetch<T>( _ type: T.Type, _ id: String) async throws(Error) -> T where T : Decodable {
        
        do {
            
            return try await collection.document(id).getDocument().data(as: type)
        } catch {
            
            throw .failedFetch(error.localizedDescription)
        }
    }
    
    func fetchAll<T>( _ type: T.Type) async throws(Error) -> [T] where T : Decodable {
        
        do {
            
            let snapshot = try await collection.order(
                    by: "createdAt", descending: true).getDocuments()
            
            return try snapshot.documents.map { try $0.data(as: T.self) }
        } catch {
            
            throw .failedFetch(error.localizedDescription)
        }
    }
    
    func fetchOrgEvents<T>( _ type: T.Type, _ orgId: String) async throws(Error) -> [T] where T : Decodable {
        
        do {
            
            let snapshot = try await collection
                .whereField("organizerId", isEqualTo: orgId)
                .getDocuments()
            
            return try snapshot.documents.map { try $0.data(as: T.self) }
        } catch {
            
            throw .failedFetch(error.localizedDescription)
        }
    }
    
    func insert<T>( _ object: T) throws(Error) where T : Encodable, T : Identifiable, T.ID == String {
        
        do {
            
            try collection.document(object.id).setData(from: object)
            
            print("EventFirebase::insert: \(object.id)")
        } catch {
            
            throw .failedInsert(error.localizedDescription)
        }
    }
    
    func delete<T>( _ object: T) async throws(Error) where T: Identifiable, T.ID == String {
        
        do {
            
            try await collection.document(object.id).delete()
            
            print("EventFirebase::delete: \(object.id)")
        } catch {
            
            throw .failedDelete(error.localizedDescription)
        }
    }
    
    func update<T>( _ object: T) async throws(Error) where T: Encodable, T: Identifiable, T.ID == String  {
        
        do {
            
            try collection.document(object.id).setData(from: object)
        } catch {
            
            throw .failedUpdate(error.localizedDescription)
        }
    }
    
    func observeAll(onChange: @escaping ([Event]) -> Void) {
        
        self.listenerAll = collection.addSnapshotListener(
                                includeMetadataChanges: false) { snapshot, _ in
                                        
            guard let snapshot = snapshot else { 
                onChange([])
                return }
            
            let events = snapshot.documents.compactMap { document in
                try? document.data(as: Event.self)
            }
            
            onChange(events)
        }
    }
    
    func observeOne( _ eventId: String,
                     onChange: @escaping (Event) -> Void,
                     onError: @escaping (Error) -> Void) {
        
        self.listenerOne =
            collection.document(eventId).addSnapshotListener { snapshot, _ in
            
            guard let snapshot = snapshot else {
                
                onError(.failedSnapshot)
                return
            }
            
            guard let event = try? snapshot.data(as: Event.self) else {
                
                onError(.failedDecode)
                return
            }
                    
            onChange(event)
        }
    }
    
    func createUniqueId() -> String {
        
        let newDocument = collection.document()
        return newDocument.documentID
    }
    
    enum Error: LocalizedError {
        
        // TODO sts 18.02.2025 - error message locate
        case failedUniqueId
        case failedFetch( _ reason: String)
        case failedInsert( _ reason: String)
        case failedDelete( _ reason: String)
        case failedUpdate( _ reason: String)
        case failedDecode
        case failedSnapshot
        case eventIdNotFound
        
        var errorDescription: String? {
            
            switch self {
                
                case .failedUniqueId: "Unique ID failed"
                case .failedFetch(let reason): "Fetch failed: \(reason)"
                case .failedInsert(let reason): "Insert failed: \(reason)"
                case .failedDelete(let reason): "Delete failed: \(reason)"
                case .failedUpdate(let reason): "Update failed: \(reason)"
                case .failedDecode: "Decode failed"
                case .failedSnapshot: "Snapshot failed"
                case .eventIdNotFound: "Event ID not found"
            }
        }
    }
}
