//
//  BodyPDF.swift
//  Jointwise
//
//  Created by Biagio Marra on 13/06/23.
//

import SwiftUI
import CareKitStore

class DataHandler: ObservableObject {
    
    @Published var kneeL: [Double] = [0.0]
    @Published var kneeR: [Double] = [0.0]
    @Published var hipR: [Double] = [0.0]
    @Published var hipL: [Double] = [0.0]
    @Published var handR: [Double] = [0.0]
    @Published var handL: [Double] = [0.0]
    @Published var neck: [Double] = [0.0]
    @Published var elbowR: [Double] = [0.0]
    @Published var elbowL: [Double] = [0.0]
    @Published var shoulderR: [Double] = [0.0]
    @Published var shoulderL: [Double] = [0.0]
    @Published var feetR : [Double] = [0.0]
    @Published var feetL : [Double] = [0.0]
    @Published var ankleR : [Double] = [0.0]
    @Published var ankleL : [Double] = [0.0]
    @Published var wristL : [Double] = [0.0]
    @Published var wristR : [Double] = [0.0]

    init(outComeBody: [Date : [OCKOutcomeValue]], outComeBody2: [Date : [OCKOutcomeValue]]) {
        EstrazioneDati(outComeBody: outComeBody, outComeBody2: outComeBody2)
    }

    func EstrazioneDati(outComeBody: [Date : [OCKOutcomeValue]], outComeBody2: [Date : [OCKOutcomeValue]]) {
        
        for (_,values) in outComeBody{
            var number: Double = 0.0
            
            for value in values {
                if ((value.value as? String) != nil) {
                    
                } else if ((value.value as? Double) != nil) {
                    number = value.doubleValue!
                }
            }
            
            for value in values {
                if ((value.value as? String) != nil) {
                    let parteCorpo = value.stringValue
                    
                    switch parteCorpo {
                    case "KneeL":
                        kneeL.append(number)
                    case "KneeR":
                        kneeR.append(number)
                    case "HipR":
                        hipR.append(number)
                    case "HipL":
                        hipL.append(number)
                    case "HandR":
                        handR.append(number)
                    case "HandL":
                        handL.append(number)
                    case "Neck":
                        neck.append(number)
                    case "ElbowR":
                        elbowR.append(number)
                    case "ElbowL":
                        elbowL.append(number)
                    case "ShoulderR":
                        shoulderR.append(number)
                    case "ShoulderL":
                        shoulderL.append(number)
                    case "FeetR":
                        feetR.append(number)
                    case "FeetL":
                        feetL.append(number)
                    case "WristR":
                        wristR.append(number)
                    case "WristL":
                        wristL.append(number)
                    case "AnkleR":
                        ankleR.append(number)
                    case "AnkleL":
                        ankleL.append(number)
                    default:
                        print("Il frutto non è riconosciuto")
                    }
                    
                }
                
            }
            
        }
        
        for (_,values) in outComeBody2{
            var number: Double = 0.0
            
            for value in values {
                if ((value.value as? String) != nil) {
                    
                } else if ((value.value as? Double) != nil) {
                    number = value.doubleValue!
                }
            }
            
            for value in values {
                if ((value.value as? String) != nil) {
                    let parteCorpo = value.stringValue
                    
                    switch parteCorpo {
                    case "KneeL":
                        kneeL.append(number)
                    case "KneeR":
                        kneeR.append(number)
                    case "HipR":
                        hipR.append(number)
                    case "HipL":
                        hipL.append(number)
                    case "HandR":
                        handR.append(number)
                    case "HandL":
                        handL.append(number)
                    case "Neck":
                        neck.append(number)
                    case "ElbowR":
                        elbowR.append(number)
                    case "ElbowL":
                        elbowL.append(number)
                    case "ShoulderR":
                        shoulderR.append(number)
                    case "ShoulderL":
                        shoulderL.append(number)
                    case "FeetR":
                        feetR.append(number)
                    case "FeetL":
                        feetL.append(number)
                    case "WristR":
                        wristR.append(number)
                    case "WristL":
                        wristL.append(number)
                    case "AnkleR":
                        ankleR.append(number)
                    case "AnkleL":
                        ankleL.append(number)
                    default:
                        print("Il frutto non è riconosciuto")
                    }
                    
                }
                
            }
            
        }
        
    }
}

struct BodyPDF: View {
    
    @ObservedObject var dataHandler: DataHandler
    
    
    var body: some View {
        
        VStack{
            Text("Body Check")
                .font(.system(size: 22, weight: .bold))
                .padding()
            ZStack{
                
                Image("BodyPDF")
                    .resizable()
                    .scaledToFit()
                
                Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.wristL)))")
                    .foregroundColor(.black)
                    .position(x: 77, y: 335)
                
                Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.wristR)))")
                    .foregroundColor(.black)
                    .position(x: 438, y: 333)
                
                Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.elbowL)))")
                    .foregroundColor(.black)
                    .position(x: 73, y: 247)
                
                Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.elbowR)))")
                    .foregroundColor(.black)
                    .position(x: 448, y: 245)
                
                Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.shoulderL)))")
                    .foregroundColor(.black)
                    .position(x: 73, y: 140)
                
                Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.shoulderR)))")
                    .foregroundColor(.black)
                    .position(x: 440, y: 141)
                
                Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.neck)))")
                    .foregroundColor(.black)
                    .position(x: 400, y: 82)
                
                ZStack{
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.hipL)))")
                        .foregroundColor(.black)
                        .position(x: 34, y: 297)
                
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.hipR)))")
                        .foregroundColor(.black)
                        .position(x: 487, y: 299)
                    
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.handL)))")
                        .foregroundColor(.black)
                        .position(x: 84, y: 408)
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.handR)))")
                        .foregroundColor(.black)
                        .position(x: 447, y: 404)
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.kneeL)))")
                        .foregroundColor(.black)
                        .position(x: 100, y: 483)
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.kneeR)))")
                        .foregroundColor(.black)
                        .position(x: 423, y: 483)
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.ankleL)))")
                        .foregroundColor(.black)
                        .position(x: 100, y: 618)
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.ankleR)))")
                        .foregroundColor(.black)
                        .position(x: 417, y: 618)
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.feetL)))")
                        .foregroundColor(.black)
                        .position(x: 76, y: 658)
                    
                    Text("\(String(format: "%.2f", calculateAverage(excludingZero: dataHandler.feetR)))")
                        .foregroundColor(.black)
                        .position(x: 443, y: 658)
                }
                
            }.frame(width: 519, height: 700)
        }
    }
    
    func calculateAverage(excludingZero values: [Double]) -> Double {
        // Filtra i valori che non sono 0.0
        let nonZeroValues = values.filter { $0 != 0.0 }
        
        // Calcola la somma dei valori non zero
        let sum = nonZeroValues.reduce(0, +)
        
        // Calcola la media. Se non ci sono valori non zero, restituisce 0.0
        let average = nonZeroValues.isEmpty ? 0.0 : sum / Double(nonZeroValues.count)
        
        return average
    }
    
}
