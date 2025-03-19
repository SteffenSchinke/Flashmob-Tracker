//
//  DocumentVM.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 26.02.25.
//


import Foundation
import Observation
import UIKit
import PDFKit


@Observable
final class PDFFileVM: ViewModelBaseClass {
    
    var uploadedPDFList: [String: FlashmobStoreFile] = [:]
    var selectedPDFURL: URL?
    
    func uploadPDFDocument() {
        
        Task {
            
            do {
                if let url = selectedPDFURL {
                    
                    let uuid = UUID().uuidString
                    let tempDoc = FlashmobStoreFile(uuid)
                    self.uploadedPDFList[uuid] = tempDoc
                    
                    let fileStore: FlashmobStore = .shared
                    let fileData = try Data(contentsOf: url)
                    var newFile = try await fileStore.uploadFile(
                        fileData,
                        FlashmobStoreKey.eventPDF.key)
                    
                    newFile.id = uuid
                    if let newUrl = newFile.url {
                        
                        newFile.thumbnail = generatePDFThumbnail(newUrl)
                    }
                    newFile.isInUploading = false
                    
                    // TODO sts 04.03.25 - eventVM doesn't get any updates
                    Task { @MainActor in
                        
                        self.uploadedPDFList.removeValue(forKey: uuid)
                        self.uploadedPDFList[uuid] = newFile
                        self.selectedPDFURL = nil
                    }
                }
            } catch {
                
                self.setError(error.localizedDescription)
            }
        }
    }
    
    func deletePDFDocument( _ item: FlashmobStoreFile, _ appUserId: String) {
        
        if let url = item.url {
           
            Task {
                
                do {
                    
                    let fileStore: FlashmobStore = .shared
                    try await fileStore.deleteFile(url.lastPathComponent,
                                                   FlashmobStoreKey.eventPDF.key,
                                                   appUserId)
                    
                    self.uploadedPDFList.removeValue(forKey: item.id)
                } catch {
                    
                    self.setError(error.localizedDescription)
                }
            }
        }
    }
    
    func generatePDFThumbnail( _ url: URL, size: CGSize = CGSize(width: 60, height: 90)) -> UIImage? {
        
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
}
