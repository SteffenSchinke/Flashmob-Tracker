//
//  PDFViewer.swift
//  Flashmob-Tracker
//
//  Created by Steffen Steffen on 17.03.25.
//


import SwiftUI
import PDFKit


struct PDFViewer: ContentView {
    
    @Namespace private var pdfSpace
    
    @State private var pdfDocument: PDFDocument? = nil
    @State private var isLoading = false
    
    var localKey: String = "title_pdf"
    var headerMode: HeaderDisplayMode = .visible
    var isViewModelinWorking: Bool { self.isLoading }
    var sourceViewNamespace: Namespace.ID? { self.pdfSpace }
    
    private var pdfURL: URL
    
    init( _ pdfURL: URL) {
        
        self.pdfURL = pdfURL
    }
    
    var content: some View {
        
        
        VStack {
            
            if let pdfDocument = self.pdfDocument {
                
                PDFKitView(document: pdfDocument)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .top)
        .task {
            
            //try? await Task.sleep(nanoseconds: 1_000_000_000)
            await downloadPDF()
        }
    }
    
    func getLeadingMenu() -> EmptyView  { EmptyView() }
    func getTrailingMenu() ->  AnyView  {
        
        AnyView(
            
            ButtonDismiss() { }
        )
    }
    
    @MainActor
    private func downloadPDF() async {
        
        isLoading = true
        defer { isLoading = false }
        
        guard let document = PDFDocument(url: pdfURL) else { return }
        pdfDocument = document
    }
}

struct PDFKitView: UIViewRepresentable {
    
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.backgroundColor = .clear
        pdfView.isOpaque = false
        
        if let scrollView =
            pdfView.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = true
            scrollView.isScrollEnabled = true
            scrollView.alwaysBounceHorizontal = false
        }
        
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
