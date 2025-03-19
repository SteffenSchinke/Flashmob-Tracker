//
//  AppUserFirebase.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 18.02.25.
//


import FirebaseFirestore


final class AppUserFirebase: Repository {
    
    private let collection = Firestore.firestore().collection(FireStoreKey.appUsers.key)
    
    func fetch<T>( _ type: T.Type, _ id: String) async throws(Error) -> T where T : Decodable {
        
        do {
            
            return try await collection.document(id).getDocument().data(as: type)
        } catch {
            
            throw .failedFetch(error.localizedDescription)
        }
    }
    
    func fetchAll<T>(_ type: T.Type) async throws(Error) -> [T] where T : Decodable {
        
        do {
            
            let snapshot = try await collection
                .whereField("userRule", isEqualTo: "organizer")
                .getDocuments()
            
            return try snapshot.documents.map { try $0.data(as: T.self) }
        } catch {
            
            throw .failedFetch(error.localizedDescription)
        }
    }
    
    func insert<T>( _ object: T) throws(Error) where T: Encodable, T: Identifiable, T.ID == String {
        
        do {
            
            try collection.document(object.id).setData(from: object)
        } catch {
            
            throw .failedInsert(error.localizedDescription)
        }
    }
    
    func delete<T>(_ object: T) async throws(Error) where T: Identifiable, T.ID == String {
        
        do {
            
            try await collection.document(object.id).delete()
        } catch {
            
            throw .failedDelete(error.localizedDescription)
        }
    }
    
    func update<T>(_ object: T) async throws(Error) where T: Encodable, T: Identifiable, T.ID == String  {
        
        do {
            
            try collection.document(object.id).setData(from: object)
        } catch {
            
            throw .failedUpdate(error.localizedDescription)
        }
    }
    
    enum Error: LocalizedError {
        
        // TODO sts 18.02.2025 - error message locate
        case failedUniqueId
        case failedFetch( _ reason: String)
        case failedInsert( _ reason: String)
        case failedDelete( _ reason: String)
        case failedUpdate( _ reason: String)
        
        var errorDescription: String? {
            
            switch self {
                
                case .failedUniqueId: "Unique ID failed"
                case .failedFetch(let reason): "Fetch failed: \(reason)"
                case .failedInsert(let reason): "Insert failed: \(reason)"
                case .failedDelete(let reason): "Delete failed: \(reason)"
                case .failedUpdate(let reason): "Update failed: \(reason)"
            }
        }
    }
}
