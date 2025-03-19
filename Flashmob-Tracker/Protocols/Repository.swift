//
//  Repository.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 19.02.25.
//


protocol Repository {
    
    func fetch<T>(_ type: T.Type,  _ id: String) async throws -> T where T: Decodable
    
    func fetchAll<T>(_ type: T.Type) async throws -> [T] where T: Decodable

    func insert<T>(_ object: T) throws where T: Encodable, T: Identifiable, T.ID == String
    
    func delete<T>(_ object: T ) async throws where T: Identifiable, T.ID == String
    
    func update<T>(_ object: T) async throws where T: Encodable, T: Identifiable, T.ID == String
}
