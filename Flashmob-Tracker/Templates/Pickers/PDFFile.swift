//
//  PickerDocument.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 26.02.25.
//


import SwiftUI
import PhotosUI


struct PDFFile: View {
    
    @Environment(AuthUserVM.self) private var authUserVM
    @Environment(PDFFileVM.self) private var pdfFileVM
    @State private var showPDFPicker: Bool = false
    
    var body: some View {
        
        HStack(alignment: .top) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    
                    ForEach(Array(self.pdfFileVM.uploadedPDFList), id: \.key) { key, doc in
                        
                        ZStack {
                           
                            if let thumb = doc.thumbnail {
                                
                               Image(uiImage: thumb)
                                
                                Button( action: { self.pdfFileVM.deletePDFDocument(doc, self.authUserVM.authUser.id) }) {
                                    
                                    Image(systemName: "trash.circle")
                                        .darkModeForegroundShadow(24)
                                }
                                .position(x: 18, y: 18)
                            } else {
                                
                                ProgressView()
                                    .progressViewStyle()
                            }
                        }
                        .frame(width: 60, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(self.colorScheme == .light ?
                                        Color.white.opacity(0.4) :
                                        Color.gray.opacity(0.4), lineWidth: 0.8)
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button( action: {
                
                showPDFPicker = true
            }) {
                
                Image(systemName: "plus.circle")
                    .darkModeForegroundShadow(24)
            }
            .frame(width: 40, alignment: .trailing)
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .sheet(isPresented: $showPDFPicker) {
            DocumentPicker { url in
                
                self.pdfFileVM.selectedPDFURL = url
                self.pdfFileVM.uploadPDFDocument()
            }
        }
    }
    
    struct DocumentPicker: UIViewControllerRepresentable {
        
        var completion: (URL) -> Void

        func makeCoordinator() -> Coordinator {
            
            Coordinator(completion: completion)
        }

        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            
            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
            picker.delegate = context.coordinator
            
            return picker
        }

        func updateUIViewController(_ uiViewController: UIDocumentPickerViewController,
                                    context: Context) {}

        class Coordinator: NSObject, UIDocumentPickerDelegate {
            
            var completion: (URL) -> Void

            init(completion: @escaping (URL) -> Void) {
                
                self.completion = completion
            }

            func documentPicker(_ controller: UIDocumentPickerViewController,
                                didPickDocumentsAt urls: [URL]) {
                
                if let url = urls.first {
                    
                    completion(url)
                }
            }
        }
    }
}
