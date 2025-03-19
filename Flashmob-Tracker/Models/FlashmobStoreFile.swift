//
//  FlashmobStoreFile.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 20.02.25.
//


import Foundation
import FirebaseFirestore
import AVKit
import PDFKit


struct FlashmobStoreFile: Codable, Identifiable {
    
    enum FlashmobStoreResponceKey: String, CodingKey {
        
        case url, size, ext, source, uploadedAt, isChanged
    }
    
    var id: String = UUID().uuidString
    var url: URL?
    var size: Int?
    var ext: FlashmobStoreFileExtension = .none
    var source: FlashmobStoreFileSource = .custom
    var uploadedAt: Date?
    var isChanged: Bool = false
    var isInUploading: Bool = true
    
    // use by cashing
    private var _fileData: Data?
    var fileData: Data? {
        
        get { _fileData }
        set { _fileData = newValue }
    }
    
    // use by cashing
    private var _thumbnail: UIImage?
    var thumbnail: UIImage? {
        
        get { _thumbnail }
        set { _thumbnail = newValue }
    }
    
    // use by cashing
    private var _avPlayer: AVPlayer?
    var avPlayer: AVPlayer? {
        
        get { _avPlayer }
        set { _avPlayer = newValue }
    }
    
    init() {}
    
    init( _ url: URL?, _ ext: FlashmobStoreFileExtension) {
        
        self.id = UUID().uuidString
        self.url = url
        self.ext = ext
    }
    
    
    init( _ id: String) { self.id = id }
    
    // protocol codable implements
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: FlashmobStoreResponceKey.self)
        
        self.url = try container.decodeIfPresent(URL.self, forKey: .url) ?? nil
        self.size = try container.decodeIfPresent(Int.self, forKey: .size) ?? 0
        self.ext = try container.decodeIfPresent(FlashmobStoreFileExtension.self, forKey: .ext) ?? .none
        self.source = try container.decodeIfPresent(FlashmobStoreFileSource.self, forKey: .source) ?? .custom
        self.uploadedAt = try container.decodeIfPresent(Date.self, forKey: .uploadedAt)
        
        if let url = self.url,
           self.ext == .pdf {
            
            self.thumbnail = self.generatePDFThumbnail(url)
        }
    }
    
    init( _ id: String, _ imageUrl: URL) async {
        
        self.id = id
        self.url = imageUrl
        self.size = 0
        
        guard case let (fileSize?, fileExtension?, imageData?) = await downloadFileInfo(imageUrl) else {
            return
        }
        
        self._fileData = imageData
        self.size = fileSize
        self.ext = fileExtension
        
        if fileExtension == .pdf {
            
            self._thumbnail = self.generatePDFThumbnail(imageData)
        }
    }
    
    // protocol codable implements
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: FlashmobStoreResponceKey.self)
        
        try container.encode(self.url, forKey: .url)
        try container.encode(self.size, forKey: .size)
        try container.encode(self.ext, forKey: .ext)
        try container.encode(self.source, forKey: .source)
        try container.encode(Date.now, forKey: .uploadedAt)
    }
    
    private func downloadFileInfo( _ imageUrl: URL) async ->
        (size: Int?, fileExtension: FlashmobStoreFileExtension?, imageData: Data?) {
        
        guard let (data, response) = try? await URLSession.shared.data(from: imageUrl) else {
            return (size: nil, fileExtension: nil, imageData: nil)
        }
        
        let fileSize = data.count
        let fileExtensionString = 
                response.suggestedFilename?.components(separatedBy: ".").last ?? ""
        let fileExtension: FlashmobStoreFileExtension =
                FlashmobStoreFileExtension(rawValue: fileExtensionString) ?? .jpg
                            
        return (size: fileSize,
                fileExtension: fileExtension,
                imageData: data)
    }
    
    func generatePDFThumbnail( _ url: URL,
                               size: CGSize = CGSize(width: 60, height: 90)) -> UIImage? {
        
        guard let pdfDocument = PDFDocument(url: url),
              let pdfPage = pdfDocument.page(at: 0) else {
            
            return nil
        }

        let pdfRect = pdfPage.bounds(for: .mediaBox)

        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: size.width / pdfRect.width, y: -size.height / pdfRect.height)

        pdfPage.draw(with: .mediaBox, to: context)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    func generatePDFThumbnail( _ data: Data,
                               size: CGSize = CGSize(width: 60, height: 90)) -> UIImage? {
        
        guard let pdfDocument = PDFDocument(data: data),
              let pdfPage = pdfDocument.page(at: 0) else {
            
            return nil
        }

        let pdfRect = pdfPage.bounds(for: .mediaBox)

        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        context.setFillColor(UIColor.white.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: size.width / pdfRect.width, y: -size.height / pdfRect.height)

        pdfPage.draw(with: .mediaBox, to: context)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

struct FlashmobStoreResponce: Codable {
    
    var status: Int
    var message: String
    var data: [FlashmobStoreFile]
}
