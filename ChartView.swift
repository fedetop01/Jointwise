//
//  ChartView.swift
//  Jointwise
//
//  Created by Federica Topazio on 17/04/23.
//

import SwiftUI
import Charts
import CareKitStore

struct ChartDataModel: Identifiable {
    let id = UUID()
    let day: Int
    let value: Double
}
struct ChartView: View {
    @EnvironmentObject var storeManagerWrapper: StoreManagerWrapper
    
    @State var monthIndex: Int = 0
    @State var yearIndex: Int = 0
    @State var chartData: [ChartDataModel] = []
    
    var body: some View {
//        BarChartView(data: ChartData(points: chartData.map { ($0.day, $0.value) }), title: "Range of Motion")
        Text("Hello World")

    }
//    func fetchChartData() -> [ChartDataModel] {
//        var chartData: [ChartDataModel] = []
//
//        // Get the start and end date of the selected month
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.year = years[yearIndex]
//        dateComponents.month = monthIndex + 1
//        dateComponents.day = 1
//        let startDate = calendar.date(from: dateComponents)!
//        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate)!
//        let dateInterval = DateInterval(start: startDate, end: endDate)
//
//        // Fetch the outcome values for the selected task ID in the selected date range
//        let taskID = "your-task-id-here"
//        storeManagerWrapper.storeManager.fetchOutcomeValues(forTaskID: taskID, inDateInterval: dateInterval) { result in
//            switch result {
//            case .failure(let error):
//                print("Failed to fetch outcome values: \(error.localizedDescription)")
//            case .success(let outcomeValues):
//                // Convert the outcome values to ChartDataModel objects
//                chartData = outcomeValues.map { outcomeValue in
//                    let day = calendar.component(.day, from: outcomeValue.date)
//                    let value = Double(outcomeValue.valueString)!
//                    return ChartDataModel(day: day, value: value)
//                }
//            }
//        }
//
//        return chartData
//    }
//    func updateChartData() {
//        chartData = fetchChartData()
//    }

}


