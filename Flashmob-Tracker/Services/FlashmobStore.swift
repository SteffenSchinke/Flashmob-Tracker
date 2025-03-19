//
//  FlashmobStore.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 20.02.25.
//


import Foundation


final class FlashmobStore {
    
    /// Singleton pattern
    static let shared = FlashmobStore()
    private init() {}
    
    private var jwt: String?
    var isReady: Bool { jwt != nil }
    
    func deleteFile( _ fileURL: String,
                     _ collection: String,
                     _ appUserId: String) async throws(Error) {
        
        // is service ready
        guard isReady else {
            throw .serviceUnavailable
        }
        
        // body create
        let deleteFileRequest = DeleteFileRequest(
            file_name: fileURL,
            firebase_id: appUserId,
            collection: collection
        )
        guard let body = try? JSONEncoder().encode(deleteFileRequest) else {
            
            throw .requestDataFailed
        }
        
        // request create
        let urlString = "https://flashmob-tracker.com/store/"
        guard let url = URL(string: urlString) else {
            
            throw .invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("https://flashmob-tracker.com", forHTTPHeaderField: "Origin")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let (_, response) = try? await URLSession.shared.upload(for: request, from: body) else {
            
            throw .responseFailed
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw .responseDecodeFailed
        }

        guard httpResponse.statusCode == 200 else {
            
            throw .fileDeleteFailed
        }
        
        print("FlashmobStor::deleteFile(): \(fileURL)")
    }
    
    func uploadFile( _ fileData: Data,
                     _ collectionName: String) async throws(Error) -> FlashmobStoreFile {
       
        
        // is service ready
        guard isReady else {
            throw .serviceUnavailable
        }
        
        // build temp casch
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
               guard ((try? fileData.write(to: fileURL)) != nil) else {
                   throw .cashingFailed
        }
        let fileName = fileURL.lastPathComponent
        let fileExt = fileURL.pathExtension.lowercased()
        let mimeType = FlashmobStoreFileExtension.init(
                        rawValue: fileExt)?.mimeType ?? "application/octet-stream"
        guard let uploadData = try? Data(contentsOf: fileURL) else {
            throw .uploadDataFailed
        }
        
        // build request
        let boundary = UUID().uuidString
        let requestURL = URL(string: "https://www.flashmob-tracker.com/store/")!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("\(self.jwt ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue(collectionName, forHTTPHeaderField: "Collection")
        request.setValue("https://flashmob-tracker.com", forHTTPHeaderField: "Origin")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // build request body
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(uploadData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // file upload
        guard let (data, _) = try? await URLSession.shared.upload(for: request, from: body) else {
            throw .uploadFailed
        }
        
        let decoder = JSONDecoder()
        
        // for date types with format: "2025-02-21T03:24:09Z"
        decoder.dateDecodingStrategy = .iso8601
        guard let decoded = try? decoder.decode(
                    FlashmobStoreResponce.self, from: data) else {
            
            throw .responseDecodeFailed
        }
        
        if decoded.status != 200 {
            throw .statusError("\(decoded.status)")
        }
        
        let uploadFile = decoded.data.first!
        
        print("FlashmobStor::uploadFile(): \(uploadFile.url?.absoluteString ?? "")")
        
        return uploadFile
    }
    
    func registerService( _ firstName: String, _ lastName: String,
                          _ companyName: String, _ email: String,
                          _ pwd: String, _ firebaseId: String) async throws(Error) {
        
        let requestBody = RegisterRequest(
            view: "auth_user",
            action: "register",
            firebase_id: firebaseId,
            first_name: firstName,
            last_name: lastName,
            company_name: companyName,
            email: email,
            pwd: pwd
        )
        
        guard let body = try? JSONEncoder().encode(requestBody) else {
            
            throw .requestDataFailed
        }
        
        let urlString = "https://flashmob-tracker.com/api/?view=auth_user&action=register"
        guard let url = URL(string: urlString) else {
            
            throw .invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("https://flashmob-tracker.com", forHTTPHeaderField: "Origin")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let (_, response) = try? await URLSession.shared.upload(for: request, from: body) else {
            
            throw .responseFailed
        }
            
        guard let httpResponse = response as? HTTPURLResponse else {
            throw .responseDecodeFailed
        }

        guard httpResponse.statusCode == 200 else {
            
            throw .responseError(httpResponse.statusCode)
        }
        
        guard let jwtHeader = httpResponse.value(forHTTPHeaderField: "Authorization") else {
            
            throw .authenticationFailed
        }
        
        guard jwtHeader.starts(with: "Bearer ") else {
            
            throw .authenticationTokenFailed
        }
        
        self.jwt = jwtHeader
        
    }
    
    func authService( _ email: String, _ pwd: String) async throws(Error) {
        
        let urlString = "https://flashmob-tracker.com/api/?view=auth_user&action=login&email=\(email)&pwd=\(pwd)"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("https://flashmob-tracker.com", forHTTPHeaderField: "Origin")
        
        guard let (_, response) = try? await URLSession.shared.data(for: request) else {
            
            throw .responseFailed
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            
            throw .responseDecodeFailed
        }
        
        guard let jwtHeader = httpResponse.value(forHTTPHeaderField: "Authorization") else {
            
            throw .authenticationFailed
        }
        
        guard jwtHeader.starts(with: "Bearer ") else {
            
            throw .authenticationTokenFailed
        }
        
        self.jwt = jwtHeader
        
    }
    
    enum Error: LocalizedError {
        
        case responseFailed
        case responseError( _ reason: Int)
        case responseDecodeFailed
        case uploadFailed
        case uploadDataFailed
        case statusError( _ reason: String)
        case cashingFailed
        case serviceUnavailable
        case requestDataFailed
        case invalidURL
        case authenticationFailed
        case authenticationTokenFailed
        case fileDeleteFailed
         
        // TODO sts 22.02.2025 - error message localize
        var errorDescription: String? {
            
            switch self {
                
                case .responseFailed:
                        "Responce fehlgeschlagen!"
                case .responseError( let reason):
                        "Responce Error: \(reason)!"
                case .responseDecodeFailed:
                        "Responce decode fehlgeschlagen!"
                case .uploadFailed: 
                        "Upload fehlgeschlagen!"
                case .statusError( let reason): 
                        "Server Status Error: \(reason)!"
                case .uploadDataFailed: 
                        "Uplaod Data decode fehlgeschlagen!"
                case .cashingFailed: 
                        "Data Cashing  fehlgeschlagen!"
                case .serviceUnavailable:
                        "Upload Service Unavailable"
                case .requestDataFailed:
                        "Request Data Encode fehlgeschlagen!"
                case .invalidURL:
                        "Invalid URL"
                case .authenticationFailed:
                        "Authentifikation fehlgeschlagen!"
                case .authenticationTokenFailed:
                        "Authentifikation Token fehlt!"
                case .fileDeleteFailed:
                        "Löschen der Datei fehlgeschlagen!"
            }
        }
    }
    
    struct RegisterRequest: Codable {
        
        let view: String
        let action: String
        let firebase_id: String
        let first_name: String
        let last_name: String
        let company_name: String
        let email: String
        let pwd: String
    }
    
    struct DeleteFileRequest: Codable {
        
        let file_name: String
        let firebase_id: String
        let collection: String
    }
}
