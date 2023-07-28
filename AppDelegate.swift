//
//  AppDelegate.swift
//  App
//
//  Created by Federica&Biagio on 16/02/23.
//

import UIKit
import CareKit
import CareKitStore
import Foundation
import ResearchKit
import os.log
import UserNotifications
import BackgroundTasks

class Patient: ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    @Published var sex: String
    @Published var birthDate: Date

    init(firstName: String, lastName: String, sex: String, birthDate: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.sex = sex
        self.birthDate = birthDate
    }
    
}


class StoreManagerWrapper: ObservableObject {
    @Published var storeManager: OCKSynchronizedStoreManager
    
    init(storeManager: OCKSynchronizedStoreManager) {
        self.storeManager = storeManager
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    app delegate is where we interact with carekitstore
    
    lazy private(set) var coreDataStore = OCKStore(name: "MyStore", type: .onDisk())
    
    lazy private(set) var storeManagerWrapper = StoreManagerWrapper(
        storeManager: {
            let coordinator = OCKStoreCoordinator()
            coordinator.attach(store: coreDataStore)
            return OCKSynchronizedStoreManager(wrapping: coordinator)
        }()
    )
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        coreDataStore.populateSampleData()
        UNUserNotificationCenter.current().delegate = self
        scheduleNotidications()
        return true
    }
    

    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
   
}

func scheduleNotidications(){
    
    // Imposta il contenuto della notifica
    let content = UNMutableNotificationContent()
    content.title = "Reminder"
    content.body = "Today's tasks are now available. Let's do them!"
    content.sound = .default
    
    // Imposta il trigger per far scattare la notifica alle 7:00
    var dateComponents = DateComponents()
    dateComponents.hour = 08
    dateComponents.minute = 00
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    
    // Imposta l'identificatore della notifica e il request
    let request = UNNotificationRequest(identifier: "morningNotification", content: content, trigger: trigger)
    
    // Aggiunge la notifica al centro di notifica
    let center = UNUserNotificationCenter.current()
    center.add(request) { (error) in
        if let error = error {
            print("Errore nell'aggiungere la notifica: \(error.localizedDescription)")
        }else {
            print("Morning notification scheduled")
        }
    }
    
}


    private extension OCKStore{
        func populateSampleData() {


            
            var patient = OCKPatient(id: "patientId", givenName: "?", familyName: "?")
                patient.birthday = Date()
                patient.sex = OCKBiologicalSex(rawValue: "M")
            
            addAnyPatient(patient, callbackQueue: .main) { result in
                switch result {
                case .success(let anyPatient):
                    print("Patient saved: \(anyPatient)")
                case .failure(let error):
                    print("Error saving patient: \(error.localizedDescription)")
                }
            }


            
            //   onborading will be prompted everyday until they give the consent
            var onboardTask = OCKTask(
                id: TaskIDs.onboarding,
                title: "Informed Consent",
                carePlanUUID: nil,
                schedule: .dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: "Task Due!")
            )
            

            onboardTask.instructions = "You'll need to agree to some terms and conditions before we get started!"
            onboardTask.impactsAdherence = false //onboard will not affect the complition ring
            
            
            //add checkin task, so we''ll create a schedule and a task, it will be a daily checkin
            let checkInSchedule = OCKSchedule.dailyAtTime(
                hour: 6, minutes: 0,
                start: Date(), end: nil,
                text: nil
            )
//            it will be displayed each day at 6 am
            

            let checkInTask = OCKTask(
                id: TaskIDs.checkIn,
                title: "Check In",
                carePlanUUID: nil,
                schedule: checkInSchedule
            )
            
            
            let thisMorning = Calendar.current.startOfDay(for: Date())
            let beforeBreakfast = Calendar.current.date(byAdding: .hour, value: 5, to: thisMorning)!
            let afterLunch = Calendar.current.date(byAdding: .hour, value: 8, to: thisMorning)!
            let before = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: thisMorning)!
            let endbefore = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: thisMorning)!
            
            
            let after = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: thisMorning)!
            let endafter = Calendar.current.date(bySettingHour: 23, minute: 0, second: 0, of: thisMorning)!
            
            
            let bodyScheduleElement1 = OCKScheduleElement(start: before, end: nil, interval: DateComponents(day: 1), duration: .hours(8))
            
            let bodyScheduleElement2 =  OCKScheduleElement(start: after, end: nil, interval: DateComponents(day: 1), duration: .minutes(539))
            
            
            let bodySchedule1 = OCKSchedule(composing: [bodyScheduleElement1])
            let bodySchedule2 = OCKSchedule(composing: [bodyScheduleElement2])

            
            
            var bodyTask1 = OCKTask(
                id: TaskIDs.bodyMap,
                title: "Body check",
                carePlanUUID: nil,
                schedule: bodySchedule1
            )
            bodyTask1.impactsAdherence = true
            
            let bodyTask2 = OCKTask(
                id: TaskIDs.bodyMap2,
                title: "Body check",
                carePlanUUID: nil,
                schedule: bodySchedule2
            )
            
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            
            let monday = Calendar.current.nextDate(after: Date(), matching: DateComponents(weekday: 2), matchingPolicy: .nextTime)!
            
            let tuesday = Calendar.current.nextDate(after: Date(), matching: DateComponents(weekday: 3), matchingPolicy: .nextTime)!
            
            let wednesday = Calendar.current.nextDate(after: Date(), matching: DateComponents(weekday: 4), matchingPolicy: .nextTime)!
            
            let thursday = Calendar.current.nextDate(after: Date(), matching: DateComponents(weekday: 5), matchingPolicy: .nextTime)!

            let today = OCKScheduleElement(start: Date(), end: nextDay, interval: DateComponents(weekday: 4, weekOfYear: 1), duration: .allDay)
            
            let weeklyElementL1 = OCKScheduleElement(
                start: monday,
                end: nil,
                interval: DateComponents(weekday: 2, weekOfYear: 1), //repeats every week, on Monday
                text: nil,
                targetValues: [],
                duration: .allDay
            )
            let weeklyElementL2 = OCKScheduleElement(
                start: wednesday,
                end: nil,
                interval: DateComponents(weekday: 4, weekOfYear: 1), //repeats every week, on Thursday
                text: nil,
                targetValues: [],
                duration: .allDay
            )
            let weeklyElementR1 = OCKScheduleElement(
                start: tuesday,
                end: nil,
                interval: DateComponents(weekday: 3, weekOfYear: 1), //repeats every week, on Monday
                text: nil,
                targetValues: [],
                duration: .allDay
            )
            let weeklyElementR2 = OCKScheduleElement(
                start: thursday,
                end: nil,
                interval: DateComponents(weekday: 5, weekOfYear: 1), //repeats every week, on Monday
                text: nil,
                targetValues: [],
                duration: .allDay
            )
            //create a schedule
            let rangeOfMotionCheckScheduleL = OCKSchedule(
                composing: [today, weeklyElementL1, weeklyElementL2]
            )
            //create a schedule
            let rangeOfMotionCheckScheduleR = OCKSchedule(
                composing: [today, weeklyElementR1, weeklyElementR2]
            )
            
            //create a new task using that schedule
            let rangeOfMotionCheckTaskL = OCKTask(
                id: TaskIDs.rangeOfMotionCheck,
                title: "Range Of Motion left knee",
                carePlanUUID: nil,
                schedule: rangeOfMotionCheckScheduleL
            )
            
            //create a new task using that schedule
            let rangeOfMotionCheckTaskR = OCKTask(
                id: TaskIDs.rangeOfMotionCheckOther,
                title: "Range Of Motion right knee",
                carePlanUUID: nil,
                schedule: rangeOfMotionCheckScheduleR
            )
            

            //add the tasks to the store , to make it persistent
       addAnyTasks([onboardTask, checkInTask, rangeOfMotionCheckTaskL, bodyTask1, rangeOfMotionCheckTaskR, bodyTask2], callbackQueue: .main) { result in
                
                switch result {
                case let .success(tasks):
                    print("Seeded \(tasks.count) tasks")
                case let .failure(error):
                    print("Failed to seed tasks: \(error as NSError)")
                }
            }
        }
    }

    


