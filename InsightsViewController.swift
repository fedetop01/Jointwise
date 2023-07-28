/*
 Copyright © 2021 Apple Inc. All rights reserved.

 Apple permits redistribution and use in source and binary forms, with or without
 modification, providing that you adhere to the following conditions:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions, and the following disclaimer in the documentation and
 other distributed materials.

 3. You may not use the name of the copyright holders nor the names of any contributors
 to endorse or promote products that derive from this software without specific prior
 written permission. Apple does not grant license to the trademarks of the copyright
 holders even if this software includes such marks.

 THE COPYRIGHT HOLDERS AND CONTRIBUTORS PROVIDE THIS SOFTWARE "AS IS”, AND DISCLAIM ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
 OR CONSEQUENTIAL  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) WHATEVER THE CAUSE AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF YOU
 ADVISE THEM OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import CareKit
import CareKitUI
import ResearchKit
import CareKitStore
import CareKitFHIR
import UserNotifications


class MyChartDelegate: NSObject, OCKChartViewControllerDelegate {
    func chartViewController<C, VS>(_ viewController: CareKit.OCKChartViewController<C, VS>, didEncounterError error: Error) where C : CareKit.OCKChartController, VS : CareKit.OCKChartViewSynchronizerProtocol {
        print("Chart error: \(error)")
    }
    
    func chartViewController(_ chartViewController: OCKCartesianChartViewController, didFailWithError error: Error) {
        print("Chart error: \(error)")
    }
}



final class InsightsViewController:
    OCKListViewController,
    ORKTaskViewControllerDelegate {

    let storeManager: OCKSynchronizedStoreManager
    
    

    init(storeManager: OCKSynchronizedStoreManager) {
        self.storeManager = storeManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save as PDF", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        


        appendView(saveButton, animated: false)
        // A spacer view.
        appendView(UIView(), animated: false)
        
        //Pain and sleep and stress bar chart
        let painSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.checkIn, //which task data to dispaly on the chart
            legendTitle: "Pain (1-10)",
            gradientStartColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),
            markerSize: 10, //how lage the bar will be
            //it determines what Y-value should be used on the given date
            eventAggregator: .custom({ events in
                events
                    .first? //one event per day, in  this case
                    .answer(kind: Surveys.checkInPainItemIdentifier)
                ?? 0
            })
        )

        let sleepSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.checkIn,
            legendTitle: "Sleep (hours)",
            gradientStartColor: UIColor.systemBlue,
            gradientEndColor: UIColor.systemBlue,
            markerSize: 10,
            eventAggregator: .custom({ events in
             let ans =   events
                    .first?
                    .answer(kind: Surveys.checkInSleepItemIdentifier)
                ?? 0
//                print("events.first of sleep: \(String(describing: events.first))")
                return ans
            })
        )

        let stressSeries = OCKDataSeriesConfiguration(
            taskID: TaskIDs.checkIn, //which task data to dispaly on the chart
            legendTitle: "Stress (1-10)",
            gradientStartColor: #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1),
            markerSize: 10, //how lage the bar will be
            //it determines what Y-value should be used on the given date
            eventAggregator: .custom({ events in
                events
                    .first? //one event per day, in  this case
                    .answer(kind: Surveys.checkInStressItemIdentifier)
                ?? 0
            })
        )
        
        
        
        let barChart = OCKCartesianChartViewController(
            plotType: .bar,
            selectedDate: Date(),
            configurations: [painSeries, sleepSeries, stressSeries],
            storeManager: storeManager //to keep the content uptodate
        )

        barChart.title = "Pain, Sleep and Stress Correlation"
        appendViewController(barChart, animated: false)
        
        
        
//Range of motion Scatter plot
        let rangeSeriesL = OCKDataSeriesConfiguration(
            taskID: TaskIDs.rangeOfMotionCheck,
            legendTitle: "RoM Left (degrees)",
            gradientStartColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),
            markerSize: 3,
            eventAggregator: .custom({ events in
                let event = events.first?.answer(kind: #keyPath(ORKRangeOfMotionResult.range))
                print(event ?? 0.0)
                
//                    .answer(kind: Surveys.rangeOfMotionLeft)
                    
                return event ?? 0
            })
        )
        
        //Range of motion Scatter plot
                let rangeSeriesR = OCKDataSeriesConfiguration(
                    taskID: TaskIDs.rangeOfMotionCheckOther,
                    legendTitle: "RoM Right (degrees)",
                    gradientStartColor: #colorLiteral(red: 0.233736366, green: 0.6245343685, blue: 0.3227830231, alpha: 1),
                    gradientEndColor: #colorLiteral(red: 0.233736366, green: 0.6245343685, blue: 0.3227830231, alpha: 1),
                    markerSize: 3,
                    eventAggregator: .custom({ events in
                        let event = events.first?.answer(kind: #keyPath(ORKRangeOfMotionResult.range))
                        print(event ?? 0.0)
                        
        //                    .answer(kind: Surveys.rangeOfMotionLeft)
                            
                        return event ?? 0
                    })
                )
// view controller, with one data series
        let scatterChart = OCKCartesianChartViewController(
            plotType: .scatter,
            selectedDate: Date(),
            configurations: [rangeSeriesL, rangeSeriesR],
            storeManager: storeManager
        )
        scatterChart.title = "Right and Left knees Range of Motion task results"
        scatterChart.delegate = MyChartDelegate()
        appendViewController(scatterChart, animated: false)

        // A spacer view.
       appendView(UIView(), animated: false)
        
    }
    

    func taskViewController(
        _ taskViewController: ORKTaskViewController,
        didFinishWith reason: ORKTaskViewControllerFinishReason,
        error: Error?) {

        taskViewController.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveAsPDF(filename: "example.pdf")
    }
    

   




    
}

extension UIViewController {
    
    
    func saveAsPDF(filename: String) {
        let pdfData = NSMutableData()
        let pdfBounds = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4 size in points
        UIGraphicsBeginPDFContextToData(pdfData, pdfBounds, nil)
        UIGraphicsBeginPDFPage()

        let pdfContext = UIGraphicsGetCurrentContext()!
        
        // Render view to PDF
        view.layer.render(in: pdfContext)
        
        
        // Draw text
        let stringToDraw = "Weekly Charts:\n"
        let string1 = "1. Correlation between Pain, Sleep and Stress Levels\n"
        let string2 = "2. Range of Motion of both knees\n"
        
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20)]
        let stringRect = CGRect(x: 50, y: 10, width: 400, height: 25)
        let stringRect1 = CGRect(x: 50, y: 35, width: 400, height: 25)
        let stringRect2 = CGRect(x: 50, y: 60, width: 400, height: 25)
        stringToDraw.draw(in: stringRect, withAttributes: attributes)
        string1.draw(in: stringRect1, withAttributes: attributes)
        string2.draw(in: stringRect2, withAttributes: attributes)
        
        UIGraphicsEndPDFContext()
        // Save PDF to temporary file and present document picker
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename + ".pdf")
        
        do {
            try pdfData.write(to: tempURL)
        } catch {
            print("Error writing PDF file: \(error.localizedDescription)")
            return
        }

        let documentPicker = UIDocumentPickerViewController(forExporting: [tempURL], asCopy: true)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        
        present(documentPicker, animated: true, completion: nil)
    }


}

extension UIViewController: UIDocumentPickerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedUrl = urls.first else {
            print("No URL selected")
            return
        }
        
        do {
            let pdfData = try NSData(contentsOf: selectedUrl) as Data
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let documentURL = documentDirectory.appendingPathComponent(selectedUrl.lastPathComponent)
            try pdfData.write(to: documentURL)
            print("Saved PDF file to \(documentURL.absoluteString)")
        } catch {
            print("Error writing PDF file: \(error.localizedDescription)")
        }
    }
}




