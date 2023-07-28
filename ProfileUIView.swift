//
//  ProfileUIView.swift
//  Jointwise
//
//  Created by Federica&Biagio on 15/04/23.
//

import SwiftUI
import Charts
import CareKitStore
import PDFKit
import UIKit

struct ProfileInfoRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
            
        }
    }
}


struct ProfileUIView: View {
    
    @EnvironmentObject var storeManagerWrapper: StoreManagerWrapper
    
    @StateObject public var patientB : Patient = Patient(firstName: "John", lastName: "Doe", sex: "M", birthDate: Date())
    
    @State private var isPresented = false
    
    @State var monthIndex: Int = 0
    @State var yearIndex: Int = 0
    @State var outComeRangeOfMotionCheckRight: [Date: [OCKOutcomeValue]] = [:]
    
    @State var outComeRangeOfMotionCheckLeft: [Date: [OCKOutcomeValue]] = [:]
    
    @State var outComeBody1: [Date: [OCKOutcomeValue]] = [:]
    @State var outComeBody2: [Date: [OCKOutcomeValue]] = [:]
    
    @State var generatePDFURL: URL?
    
    let monthSymbols = Calendar.current.monthSymbols
    let years = Array(Date().year..<Date().year+10)
    
    var body: some View {
        
        List{
            
            SwiftUI.Section
            {
                ProfileInfoRow(title: "First Name: ", value: $patientB.firstName.wrappedValue)
                ProfileInfoRow(title: "Last Name: ", value: $patientB.lastName.wrappedValue)
                ProfileInfoRow(title: "Sex: ", value: $patientB.sex.wrappedValue)
                ProfileInfoRow(title: "Birth Date: ", value: dateFormatter.string(from: patientB.birthDate))
            } header: {
                Text("Your information")
            }.onAppear{
                                
                                let storeManager = storeManagerWrapper.storeManager
                                var query = OCKPatientQuery(id: "patientId")
                                query.limit = 1
                                query.sortDescriptors = [.effectiveDate(ascending: false)]

                                storeManager.store.fetchAnyPatients(query: query, callbackQueue: .main) { result in
                                    switch result {
                                    case .success(let patients):
                                        if let patient = patients.first {
                                            // usa il paziente trovato
                                            print(patientB.firstName)
                                            self.patientB.birthDate = patient.birthday!
                                            self.patientB.sex = patient.sex!.rawValue
                                            self.patientB.firstName = patient.name.givenName!
                                            self.patientB.lastName = patient.name.familyName!
                                            print(patientB.firstName)
                                        }
                                    case .failure(let error):
                                        // gestisci l'errore
                                        print(error)
                                    }
                                }
                            }
            
            
            SwiftUI.Section{
                    HStack{
                        Picker(selection: self.$monthIndex.onChange(self.monthChanged), label: Text("")) {
                            ForEach(0..<self.monthSymbols.count) { index in
                                Text(self.monthSymbols[index])
                            }
                        }
                        //                        .frame(maxWidth: geometry.size.width / 2,alignment: Alignment.center).clipped()
                        Picker(selection: self.$yearIndex.onChange(self.yearChanged), label: Text("")) {
                            ForEach(0..<self.years.count) { index in
                                Text(String(self.years[index]))
                            }
                        }
                       
                    }
                
                
                Button(action: {
                    
                    fetchOutcomeValues(for: TaskIDs.rangeOfMotionCheckOther, in: monthIndex + 1 ,year: years[yearIndex]) { outcome in
                        print(outcome)
                        outComeRangeOfMotionCheckRight = outcome
                    }
                    
                    fetchOutcomeValues(for: TaskIDs.rangeOfMotionCheck, in: monthIndex + 1 ,year: years[yearIndex]) { outcome in
                        outComeRangeOfMotionCheckLeft = outcome
                    }
                    
                    fetchOutcomeValues(for: TaskIDs.bodyMap, in: monthIndex + 1 ,year: years[yearIndex]) { outcome in
                        outComeBody1 = outcome
                    }
                    
                    fetchOutcomeValues(for: TaskIDs.bodyMap2, in: monthIndex + 1 ,year: years[yearIndex]) { outcome in
                        outComeBody2 = outcome
                    }
                    
                    exportPDF(monthIndex: monthIndex, yearIndex: yearIndex, outComeRangeOfMotionCheckRight: outComeRangeOfMotionCheckRight, outComeRangeOfMotionCheckLeft: outComeRangeOfMotionCheckLeft, outComeBody1: outComeBody1, outComeBody2: outComeBody2) { success in
                                    if success {
                                        // Export succeeded
                                    } else {
                                        // Export failed
                                    }
                                }
                            }) {
                    Text("Export PDF")
                }
            }header:{
                Text("PDF")
            }
                
        }
        .sheet(isPresented: $isPresented) {
            ProfileSettingsView(Nome: $patientB.firstName, Cognome: $patientB.lastName, Sesso: $patientB.sex, Compleanno: $patientB.birthDate, isPresented: $isPresented)
            
        }

        .navigationBarTitle("Profile")
        .navigationBarItems(
            trailing: Button(action: {
                self.isPresented = true
            }) {
                Text("Edit")
            }
        )
        
    }
                   
                   
    func monthChanged(_ index: Int) {
        print("\(years[yearIndex]), \(index+1)")
        print("Month: \(monthSymbols[index])")
    }
    func yearChanged(_ index: Int) {
        print("\(years[index]), \(monthIndex+1)")
        print("Month: \(monthSymbols[monthIndex])")
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    func getMonthName(from monthNumber: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
         let date = Calendar.current.date(from: DateComponents(month: monthNumber))
        
        return dateFormatter.string(from: date!)

    }
    
    func fetchOutcomeValues(for taskID: String, in month: Int, year: Int, completion: @escaping ([Date: [OCKOutcomeValue]]) -> Void) {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = 1
        let startDate = calendar.date(from: dateComponents)!
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
        var outcomeValuesByDate: [Date: [OCKOutcomeValue]] = [:]
            
        // Recursive function to fetch outcome values for each day in the month
        func fetchOutcomeValuesForDay(_ day: Date) {
            var query = OCKOutcomeQuery(for: day)
            query.taskIDs = [taskID]
            storeManagerWrapper.storeManager.store.fetchAnyOutcomes(query: query, callbackQueue: .main) { result in
                switch result {
                case .success(let outcomes):
                    let outcomeValues = outcomes.flatMap { $0.values }
                    outcomeValuesByDate[day] = outcomeValues
                    let nextDay = calendar.date(byAdding: .day, value: 1, to: day)!
                    if nextDay <= endDate {
                        fetchOutcomeValuesForDay(nextDay)
                    } else {
                        completion(outcomeValuesByDate)
                    }
                case .failure(let error):
                    print("Error fetching outcomes: \(error.localizedDescription)")
                    completion(outcomeValuesByDate)
                }
            }
        }
        fetchOutcomeValuesForDay(startDate)
    }





    
    func exportPDF(monthIndex: Int, yearIndex: Int, outComeRangeOfMotionCheckRight: [Date : [OCKOutcomeValue]], outComeRangeOfMotionCheckLeft: [Date : [OCKOutcomeValue]], outComeBody1: [Date : [OCKOutcomeValue]], outComeBody2: [Date : [OCKOutcomeValue]], completion: @escaping (Bool) -> Void){
        

      
                let pdfView = PDFView()
                let pdfDocument = PDFDocument()
        
        
        let page = PDFPage() // This will create a default page size (usually US Letter or A4)
           pdfDocument.insert(page, at: pdfDocument.pageCount)
        
        
           // Create the title annotation
           let titleBounds = CGRect(x: 10, y: page.bounds(for: .mediaBox).height - 260, width: page.bounds(for: .mediaBox).width - 20, height: 50)
           let titleAnnotation = PDFAnnotation(bounds: titleBounds, forType: .freeText, withProperties: nil)
           titleAnnotation.font = UIFont.boldSystemFont(ofSize: 36)
           titleAnnotation.fontColor = UIColor.black
           titleAnnotation.contents = "JOINTWISE"
            titleAnnotation.color = UIColor.white
        titleAnnotation.alignment = .center
           page.addAnnotation(titleAnnotation)
        
            let EstrapolazioneBounds = CGRect(x: 10, y: page.bounds(for: .mediaBox).height - 310, width: page.bounds(for: .mediaBox).width - 20, height: 50)
            let EstrapolazioneAnnotation = PDFAnnotation(bounds: EstrapolazioneBounds, forType: .freeText, withProperties: nil)
            EstrapolazioneAnnotation.font = UIFont.boldSystemFont(ofSize: 32)
            EstrapolazioneAnnotation.fontColor = UIColor.black
            EstrapolazioneAnnotation.contents = "Monthly data extrapolation"
            EstrapolazioneAnnotation.color = UIColor.white
            EstrapolazioneAnnotation.alignment = .center
            page.addAnnotation(EstrapolazioneAnnotation)

           // Create the patient name annotation
           let patientNameBounds = CGRect(x: 10, y: page.bounds(for: .mediaBox).height - 410, width: page.bounds(for: .mediaBox).width - 20, height: 80)
           let patientNameAnnotation = PDFAnnotation(bounds: patientNameBounds, forType: .freeText, withProperties: nil)
           patientNameAnnotation.font = UIFont.systemFont(ofSize: 24)
           patientNameAnnotation.fontColor = UIColor.black
           patientNameAnnotation.contents = "User \n Name: \(patientB.firstName)        Surname: \(patientB.lastName)"
           patientNameAnnotation.color = UIColor.white
           patientNameAnnotation.alignment = .center
           page.addAnnotation(patientNameAnnotation)
        
            let PeriodoBounds = CGRect(x: 10, y: page.bounds(for: .mediaBox).height - 480, width: page.bounds(for: .mediaBox).width - 20, height: 50)
            let PeriodoAnnotation = PDFAnnotation(bounds: PeriodoBounds, forType: .freeText, withProperties: nil)
            PeriodoAnnotation.font = UIFont.boldSystemFont(ofSize: 24)
            PeriodoAnnotation.fontColor = UIColor.black
            PeriodoAnnotation.contents = "The month considered is: \(String(describing: getMonthName(from: monthIndex + 1))) \(years.first! + yearIndex) "
            PeriodoAnnotation.color = UIColor.white
            PeriodoAnnotation.alignment = .center
            page.addAnnotation(PeriodoAnnotation)
        
        
        
        
        let chartController = UIHostingController(rootView: PreviewPDFView(outComeRangeOfMotionCheckRight: outComeRangeOfMotionCheckRight, outComeRangeOfMotionCheckLeft: outComeRangeOfMotionCheckLeft))
        
                    let chartView = chartController.view!
               
        
        let chartSnapshot = self.snapshot(of: chartView)
                    let pdfPage = PDFPage(image: chartSnapshot)
                    pdfDocument.insert(pdfPage!, at: pdfDocument.pageCount)
        
        
        
        
        
        
        let datahandler = DataHandler(outComeBody: outComeBody1,outComeBody2: outComeBody2)
        
        let chartController2 = UIHostingController(rootView: BodyPDF(dataHandler: datahandler))
        
                    let chartView2 = chartController2.view!
               
        
        
        let chartSnapshot2 = self.snapshot(of: chartView2)
                    let pdfPage2 = PDFPage(image: chartSnapshot2)
                    pdfDocument.insert(pdfPage2!, at: pdfDocument.pageCount)

        
        
        
                // Save the PDF file to a temporary URL
                pdfView.document = pdfDocument
                let pdfData = pdfView.document?.dataRepresentation()
                let temporaryURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("JointWise.pdf")
                try? pdfData?.write(to: temporaryURL, options: .atomic)

                
                let activityVC = UIActivityViewController(activityItems: [temporaryURL], applicationActivities: nil)
                activityVC.completionWithItemsHandler = { _, _, _, _ in
                    do {
                        try FileManager.default.removeItem(at: temporaryURL)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
                
           
            
        
    }

    func snapshot(of view: UIView) -> UIImage {
        let size = CGSize(width: view.intrinsicContentSize.width + 200, height: view.intrinsicContentSize.height + 300)
        view.bounds = CGRect(origin: .zero, size: size)
        view.backgroundColor = .white
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }

    
//
    func pdfData(from view: UIView) -> Data {
        let pdfPageBounds = CGRect(x: 0, y: 0, width: 8.5 * 72.0, height: 11 * 72.0)
        let pdfData = NSMutableData()

        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPage()
        guard let pdfContext = UIGraphicsGetCurrentContext() else { fatalError("Unable to get PDF context") }

        view.layer.render(in: pdfContext)

        UIGraphicsEndPDFContext()

        return pdfData as Data
    }

    }
    
    





extension Binding {
    func onChange(_ completion: @escaping (Value) -> Void) -> Binding<Value> {
        .init(get:{ self.wrappedValue }, set:{ self.wrappedValue = $0; completion($0) })
    }
}
extension Date {
    var year: Int { Calendar.current.component(.year, from: self) }
}


