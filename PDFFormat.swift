//
//  PreviewPDFView.swift
//  Jointwise
//
//  Created by Federica Topazio on 17/04/23.
//

import SwiftUI
import Charts
import CareKitStore
import PDFKit
import UIKit

struct Series : Identifiable {
    let giorno : String
    let valore : Int
    let posizione : String
    
    var id : String { giorno }
}



struct PreviewPDFView: View {
    
    
    @State var outComeRangeOfMotionCheckRight: [Date : [OCKOutcomeValue]]
    @State var outComeRangeOfMotionCheckLeft: [Date : [OCKOutcomeValue]]
    
    @State private var pdfData: Data?


    
    
    var body: some View {
        
        let Right = createSeriesArray(from: self.outComeRangeOfMotionCheckRight, posizione: "Right")
        let Left = createSeriesArray(from: self.outComeRangeOfMotionCheckLeft, posizione: "Left")
        
            
        VStack (alignment: .leading){
            
            Text("Range Of Motion Right and Left knee")
                .font(.system(size: 22, weight: .bold))
                .padding()
            
                         Chart {
            
                                    ForEach(Right) { series in
                                        BarMark(
                                            x: .value("Valore", series.valore),
                                            y: .value("Giorno", series.giorno),
                                            width: .inset(6)
                                        ).cornerRadius(5)
                                            .foregroundStyle(by: .value("Posizione", series.posizione))
                                    }
            
                                    ForEach(Left) { series in
                                        BarMark(
                                            x: .value("Valore", series.valore),
                                            y: .value("Giorno", series.giorno),
                                            width: .inset(6)
                                        ).cornerRadius(5)
                                            .foregroundStyle(by: .value("Posizione", series.posizione))
                                    }
            
                                }
                                .padding()
                                .frame(minWidth: 100, maxWidth: 380,minHeight: 350,idealHeight: 600 ,maxHeight: 750)
            
        }
        
        
    }
    
    
    func createSeriesArray(from outcomeTuples: [Date : [OCKOutcomeValue]], posizione: String) -> [Series] {
        var valori = [Series]()
        
        let SortoutcomeTuples = outcomeTuples.sorted { $0.key < $1.key }
        
        
        for (date, values) in SortoutcomeTuples {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let dayString = dateFormatter.string(from: date)
            let series = Series(giorno: dayString, valore: Int(values.first?.doubleValue ?? 0), posizione: posizione)
                valori.append(series)
        }
        
        
        return valori
    }

}



