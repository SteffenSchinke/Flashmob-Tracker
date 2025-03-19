//
//  Favorites.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 11.03.25.
//


import FirebaseFirestore
import Observation


@Observable
final class Favorites {
    
    /// Singleton pattern
    static let shared = Favorites()
    private init() {}
    
    var favorites: [String] = []
    var count: Int { self.favorites.count }
    
    private var listener: ListenerRegistration?
    private var appUserId: String?
    private var coll: CollectionReference {
        Firestore.firestore().collection(FireStoreKey.favorites.key)
    }
    
    
    deinit {
        
        self.listener?.remove()
        self.listener = nil
    }
    
    
    func isInFavorites( _ eventId: String) -> Bool {
        
        self.favorites.contains(eventId)
    }
    
    func toggleFavorite( _ eventId: String) {
        
        self.isInFavorites(eventId) ?
            self.removeFavorite(eventId) :
            self.insertFavorite(eventId)
    }
    
    func startObserver(_ appUserId: String) {
        
        guard self.listener == nil else { return }
        
        self.appUserId = appUserId
        
        observeOwner() { favorites in
            
            self.favorites = favorites
        }
    }
    
    private func insertFavorite(_ eventId: String) {
        
        guard let userId = self.appUserId else { return }
        
        self.coll.document(userId).updateData([
                FireStoreKey.favorites.key:
                    FieldValue.arrayUnion([eventId])])
    }
    
    private func removeFavorite(_ eventId: String) {
        
        guard let userId = self.appUserId else { return }
        
        self.coll.document(userId).updateData([
                FireStoreKey.favorites.key:
                    FieldValue.arrayRemove([eventId])])
    }
    
    private func observeOwner(onChange: @escaping ([String]) -> Void) {
        
        guard let userId = self.appUserId else { return }
        
        self.listener = coll.document(userId).addSnapshotListener(
            includeMetadataChanges: false) { snapshot, _ in

            guard let snapshot = snapshot else {
                return
            }

            if let favList = snapshot.data()?[FireStoreKey.favorites.key] as? [String] {

                onChange(favList)
            }
        }
    }
}
