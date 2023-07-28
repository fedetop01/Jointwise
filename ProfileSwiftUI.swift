import SwiftUI
import ResearchKit
import Charts


struct PDFViewer: UIViewControllerRepresentable {
    let pdfURL: URL
    
    func makeUIViewController(context: Context) -> ORKTaskViewController {
        let pdfStep = ORKPDFViewerStep(identifier: "pdfViewerStep", pdfURL: pdfURL)
        let pdfTask = ORKOrderedTask(identifier: "pdfTask", steps: [pdfStep])
        let pdfTaskVC = ORKTaskViewController(task: pdfTask, taskRun: nil)
        pdfTaskVC.delegate = context.coordinator
        return pdfTaskVC
    }
    
    func updateUIViewController(_ uiViewController: ORKTaskViewController, context: Context) {
        // Non serve fare nulla qui
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, ORKTaskViewControllerDelegate {
        func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
            taskViewController.dismiss(animated: true, completion: nil)
        }
    }
}

struct UserProfileView: View {
    // ...

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                // ...

                NavigationLink(
                    destination: PDFViewer(pdfURL: URL(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!),
                    label: {
                        Text("Apri PDF Viewer")
                    })
            }
            .padding()
            .navigationBarTitle("Profilo", displayMode: .inline)
        }
    }
}




func urlPDF(completion: @escaping (URL?) -> Void) {
    let pdfData = createFlyer()
    let tempDirURL = FileManager.default.temporaryDirectory
    let pdfURL = tempDirURL.appendingPathComponent("myPDF.pdf")
    do {
        try pdfData.write(to: pdfURL)
        completion(pdfURL)
    } catch {
        completion(nil)
    }
}


func createFlyer() -> Data {
    // 1
    let pdfMetaData = [
        kCGPDFContextCreator: "Flyer Builder",
        kCGPDFContextAuthor: "raywenderlich.com"
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
    // 2
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
    // 3
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    // 4
    let data = renderer.pdfData { (context) in
        // 5
        context.beginPage()
        // 6
        let attributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)
        ]
        let text = "I'm a PDF!"
        text.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
    }
    
    return data
}
