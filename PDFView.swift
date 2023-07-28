
import SwiftUI
import PDFKit
import CareKit
import CareKitStore
import Charts
import UIKit


@MainActor
struct ContentView: View {

    @Binding var monthIndex: Int 
    @Binding var yearIndex: Int
    @Binding var outComeRangeOfMotionCheckRight: [Date : [OCKOutcomeValue]]
    @Binding var outComeRangeOfMotionCheckLeft: [Date : [OCKOutcomeValue]]
    @State var pdfExportEnabled = false
    @State var pdfView: PDFView = PDFView()
    
    let vista: PreviewPDFView
    
        init(monthIndex: Binding<Int>, yearIndex: Binding<Int>, outComeRangeOfMotionCheckRight: Binding<[Date : [OCKOutcomeValue]]>, outComeRangeOfMotionCheckLeft: Binding<[Date : [OCKOutcomeValue]]>) {
            _monthIndex = monthIndex
            _yearIndex = yearIndex
            _outComeRangeOfMotionCheckRight = outComeRangeOfMotionCheckRight
            _outComeRangeOfMotionCheckLeft = outComeRangeOfMotionCheckLeft
            vista = PreviewPDFView(monthIndex: monthIndex, yearIndex: yearIndex, outComeRangeOfMotionCheckRight: outComeRangeOfMotionCheckRight, outComeRangeOfMotionCheckLeft: outComeRangeOfMotionCheckLeft)
        }

    var body: some View {
        
        //        let vista = PreviewPDFView(monthIndex: $monthIndex, yearIndex: $yearIndex, outComeRangeOfMotionCheckRight: $outComeRangeOfMotionCheckRight, outComeRangeOfMotionCheckLeft: $outComeRangeOfMotionCheckLeft)
        
        VStack
        {
            vista.onAppear() {
                DispatchQueue.main.async {
                    let filename = "myPDF"
                    self.pdfView = PDFView(frame: UIScreen.main.bounds)
                    let pdfDocument = PDFDocument(url: URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename + ".pdf"))
                    self.pdfView.document = pdfDocument
                    
                    guard pdfDocument != nil else {
                        print("Errore nella creazione del documento PDF.")
                        return
                    }
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let mainWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
                        mainWindow.rootViewController?.view.addSubview(self.pdfView)
                    }
                    
                    self.pdfExportEnabled = true
                    print("\n\n\npdf creato correttamente\n\n\n\n")
                }
            }


            Button("Export PDF") {
                guard let document = pdfView.document else { return }
                let fileManager = FileManager.default
                let documentsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let pdfURL = documentsURL.appendingPathComponent("myPDF.pdf")
                
                do {
                    try document.write(to: pdfURL, withOptions: nil)
                    print("PDF saved at: \(pdfURL)")
                } catch {
                    print("Error saving PDF: \(error)")
                }
            }


            
            
            
            
        }
    }





     func render() -> URL {
         var url = URL.documentsDirectory.appending(path: "output.pdf")
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             // Aggiungi qui il codice che salva la vista come PDF
             
             
             var renderer = ImageRenderer(content: vista)

             
             // 3: Start the rendering process
             renderer.render { size, context in
                 // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
                 var box = CGRect(x: 0, y: 0, width: 1000 , height: 2000)
                 
                 // 5: Create the CGContext for our PDF pages
                 guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                     return
                 }
                 
                 // 6: Start a new PDF page
                 pdf.beginPDFPage(nil)
                 
                 // 7: Render the SwiftUI view data onto the page
                 
                 context(pdf)
                 
                 // 8: End the page and close the file
                 pdf.endPDFPage()
                 pdf.closePDF()
             }
             
         }

        return url
    }
    
    
}



