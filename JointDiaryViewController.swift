//
//  JointDiaryViewController.swift
//  Jointwise
//
//  Created by Federica Topazio on 09/03/23.
//



import UIKit
import CareKit
import CareKitUI
import ResearchKit
import CareKitStore
import CareKitFHIR
import Foundation

class Section {
    let title: String
    let options: [OCKCartesianChartViewController]
    var isOpened: Bool = false
    
    init(title: String, options: [OCKCartesianChartViewController], isOpened: Bool = false){
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
    
}

final class JointDiaryViewController:
    OCKListViewController,
    ORKTaskViewControllerDelegate,
        UITableViewDelegate, UITableViewDataSource{
    
    let storeManager: OCKSynchronizedStoreManager
    
    
    init(storeManager: OCKSynchronizedStoreManager) {
        self.storeManager = storeManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    private var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // Set the table view's delegate and data source
                tableView.delegate = self
                tableView.dataSource = self
        
        // Register any necessary cell classes or nibs
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                
                // Add the table view to the view hierarchy
                view.addSubview(tableView)
//        tableView.frame = view.bounds
                
                // Layout the table view using Auto Layout
                tableView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: view.topAnchor),
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
                
                navigationController?.navigationBar.prefersLargeTitles = true
                
        
        let shoulderLSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "LeftShoulder",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ShoulderL")
                if s {

                    let shoulderValue = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
                    print("\n\nQuesto è shoulderValue: \(String(describing: shoulderValue))\n")

                    return shoulderValue ?? 0.0
                }
                return 0.0
            }))
        
        let shoulderLSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ShoulderL")
                if s {

                    let shoulderValue = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
                    print("\n\nQuesto è shoulderValue: \(String(describing: shoulderValue))\n")

                    return shoulderValue ?? 0.0
                }
                return 0.0
            }))

        let shoulderRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightShoulder",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ShoulderR")
                if s {

                    let shoulderValue = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
                    print("\n\nQuesto è shoulderValue: \(String(describing: shoulderValue))\n")

                    return shoulderValue ?? 0.0
                }
                return 0.0
            }))
        
        let shoulderRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ShoulderR")
                if s {

                    let shoulderValue = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
                    print("\n\nQuesto è shoulderValue: \(String(describing: shoulderValue))\n")

                    return shoulderValue ?? 0.0
                }
                return 0.0
            }))


        let shoulderLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [shoulderLSeries1, shoulderLSeries2, shoulderRSeries1, shoulderRSeries2], storeManager: storeManager)


//        appendViewController(shoulderLineChart, animated: false)
        let elbowLSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "LeftElbow",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ElbowL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let elbowLSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ElbowL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))

        let elbowRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightElbow",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ElbowR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        let elbowRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []
//                let match = values.first(where: { $0.stringValue == "shoulders" })

                let s = values.description.contains("ElbowR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)
//                    let shoulderValue = values.first(where: {$0.kind == Surveys.bodyPainItemIdL})?.doubleValue
//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))



        let elbowLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [elbowLSeries1, elbowLSeries2, elbowRSeries1, elbowRSeries2], storeManager: storeManager)
//        appendViewController(elbowLineChart, animated: false)
        let hipRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightHip",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HipR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        let hipRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HipR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))


        let hipLSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "LeftHip",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HipL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let hipLSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HipL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))


       let hipsLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [hipLSeries1, hipLSeries2, hipRSeries1, hipRSeries2], storeManager: storeManager)

//        appendViewController(hipsLineChart, animated: false)
        let handRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightHand",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HandR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        let handRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HandR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))


        let handLSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "LeftHand",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HandL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        let handLSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("HandL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let wristRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightWrist",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("WristR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let wristRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("WristR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let wristLSeries1 = OCKDataSeriesConfiguration(
                taskID: TaskIDs.bodyMap,
                legendTitle: "LeftWrist",
                gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
                gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
                markerSize: 4,
                eventAggregator: .custom({ events in
                    let answer =  events.first

                    let values = answer?.outcome?.values ?? []

                    let s = values.description.contains("WristL")
                    if s {

                        let value = answer?.answer(kind: Surveys.bodyPainItemId)

                        print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                        return value ?? 0.0
                    }
                    return 0.0
                }))
        let wristLSeries2 = OCKDataSeriesConfiguration(
                taskID: TaskIDs.bodyMap2,
                legendTitle: "",
                gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
                gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
                markerSize: 4,
                
                eventAggregator: .custom({ events in
                    let answer =  events.first

                    let values = answer?.outcome?.values ?? []

                    let s = values.description.contains("WristL")
                    if s {

                        let value = answer?.answer(kind: Surveys.bodyPainItemId)

                        print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                        return value ?? 0.0
                    }
                    return 0.0
                }))
        

       let wristsLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [wristLSeries1, wristLSeries2, wristRSeries1, wristRSeries2], storeManager: storeManager)
        
        let handsLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [handLSeries1, handLSeries2, handRSeries1, handRSeries2], storeManager: storeManager)

//        appendViewController(handsLineChart, animated: false)

        let kneeRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightKnee",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("KneeR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)


                    return value ?? 0.0
                }
                return 0.0
            }))

        let kneeRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("KneeR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)


                    return value ?? 0.0
                }
                return 0.0
            }))

        let kneeLSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "LeftKnee",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("KneeL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let kneeLSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("KneeL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))


       let kneesLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [kneeLSeries1, kneeLSeries2, kneeRSeries1, kneeRSeries2], storeManager: storeManager)

//        appendViewController(kneesLineChart, animated: false)

        let footRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightFoot",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("FeetR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)


                    return value ?? 0.0
                }
                return 0.0
            }))
        let footRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("FeetR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)


                    return value ?? 0.0
                }
                return 0.0
            }))
        
        

        let footLSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "LeftFoot",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("FeetL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        let footLSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("FeetL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))


       let feetLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [footLSeries1, footLSeries2, footRSeries1, footRSeries2], storeManager: storeManager)
        
        
        let ankleRSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "RightAnkle",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("AnkleR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)


                    return value ?? 0.0
                }
                return 0.0
            }))
        let ankleRSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.1248728707, green: 0.4315905273, blue: 0.759827435, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("AnkleR")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)


                    return value ?? 0.0
                }
                return 0.0
            }))


        let ankleLSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "LeftAnkle",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("AnkleL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let ankleLSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.2745098039, green: 0.7803921569, blue: 0.6039215686, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("AnkleL")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))


       let ankleLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [ankleLSeries1, ankleLSeries2, ankleRSeries1, ankleRSeries2], storeManager: storeManager)
        
        
        
        
        
        let neckSeries1 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap,
            legendTitle: "Neck",
            gradientStartColor: #colorLiteral(red: 0.8869826794, green: 0.242420584, blue: 0.1372885108, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.8869826794, green: 0.242420584, blue: 0.1372885108, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("Neck")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let neckSeries2 = OCKDataSeriesConfiguration(
            taskID: TaskIDs.bodyMap2,
            legendTitle: "",
            gradientStartColor: #colorLiteral(red: 0.889313221, green: 0.17888695, blue: 0.08540318161, alpha: 1),
            gradientEndColor: #colorLiteral(red: 0.889313221, green: 0.17888695, blue: 0.08540318161, alpha: 1),
            markerSize: 4,
            eventAggregator: .custom({ events in
                let answer =  events.first

                let values = answer?.outcome?.values ?? []

                let s = values.description.contains("Neck")
                if s {

                    let value = answer?.answer(kind: Surveys.bodyPainItemId)

//                    print("\n\nQuesto è shoulderValue: \(String(describing: value))\n")

                    return value ?? 0.0
                }
                return 0.0
            }))
        
        let neckLineChart = OCKCartesianChartViewController(plotType: .scatter, selectedDate: Date(), configurations: [neckSeries1, neckSeries2], storeManager: storeManager)

//        let chartNavigationController = UINavigationController(rootViewController: feetLineChart)
        
        sections = [
            Section(title: "Neck", options: [neckLineChart]),
            Section(title: "Shoulders", options: [shoulderLineChart]),
            Section(title: "Elbows", options: [elbowLineChart]),
            Section(title: "Hands and wrists", options: [handsLineChart, wristsLineChart]),
            Section(title: "Hips", options: [hipsLineChart]),
            Section(title: "Knees", options: [kneesLineChart]),
            Section(title: "Feet and ankles", options: [feetLineChart, ankleLineChart])
            
//            Section(title: "Elbows", options: [elbowLineChart])
//            Section(title: "Elbows", options: [elbowLineChart])
        

        ]
//        view.addSubview(tableView)
//
//
//
        
    }
    

    
    
    //ORKTaskViewControllerDelegate

    func taskViewController(
        _ taskViewController: ORKTaskViewController,
        didFinishWith reason: ORKTaskViewControllerFinishReason,
        error: Error?) {

        taskViewController.dismiss(animated: true, completion: nil)
    }
//    restituisce il numero di sezioni nella tabella, che in questo caso è determinato dalla lunghezza dell'array sections.
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
//    restituisce il numero di righe per ogni sezione della tabella.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return section.options.count + 1
        }
        else {
            return 1
        }
        // il numero di righe è uguale al numero di opzioni nella sezione più una riga per il titolo della sezione. Altrimenti, se la sezione è chiusa, viene restituita solo una riga per il titolo.
//        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        se la riga è la priam della sezione viene impostato il titolo della sezione come testo della cella
        
        // reimposta lo stato della cella e rimuovi il contenuto precedente
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            cell.textLabel?.text = nil
        
        
        if indexPath.row == 0 {
            cell.textLabel?.text = sections[indexPath.section].title
        } else {
            let chartView = sections[indexPath.section].options[indexPath.row - 1].view
            chartView?.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: 200)
            
            if let chartView = chartView {
                cell.contentView.addSubview(chartView)
//                print("cellForRowAt")
                // aggiorna il layout della cella
                            cell.setNeedsLayout()
            }
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        }
        else {
            print("tapped cell")
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
                return 50 // altezza predefinita per la cella di intestazione
            } else {
                let chartView = sections[indexPath.section].options[indexPath.row - 1].view
                return chartView?.frame.height ?? 0
            }
    }
}
