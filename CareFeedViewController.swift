//
//  HomeViewController.swift
//  App
//
//  Created by Federica on 16/02/23.
//

import UIKit
import CareKit
import CareKitUI
import CareKitStore
import SwiftUI
import Foundation
import ResearchKit
import UserNotifications




class CareFeedViewController: OCKDailyPageViewController,           OCKSurveyTaskViewControllerDelegate {
    
    
    @IBOutlet weak var deviceTokenLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    
        
        
        
    }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        //        overriding the controller for date method, invoked each time the user swiper for a new day
        
        
        checkIfOnboardingIsComplete { isOnboarded in
            //to disallow completition on future date
            let isFuture = Calendar.current.compare(
                date,
                to: Date(),
                toGranularity: .day) == .orderedDescending
        
            let isPast = Calendar.current.compare(date,
                                                  to: Date(),
                                                  toGranularity: .day) == .orderedAscending
            //            based on whether is complete or not it will show the other taks
            guard isOnboarded else {
                let onboardCard = CustomSurveyTaskViewController(
                    taskID: TaskIDs.onboarding,
                    eventQuery: OCKEventQuery(for: date),
                    storeManager: self.storeManager,
                    survey: Surveys.onboardingSurvey(),
                    extractOutcome: { _ in [OCKOutcomeValue(Date())] }
                )
                onboardCard.view.isUserInteractionEnabled = !isFuture
                onboardCard.view.alpha = isFuture ? 0.4 : 1.0
                onboardCard.view.isHidden = isPast
                
                onboardCard.surveyDelegate = self
                
                listViewController.appendViewController(
                    onboardCard,
                    animated: false
                )
                
                return
            }
            // Query and display a card for each task
            
            //fetch all the tasks for the current date
            self.fetchTasks(on: date) { tasks in
                tasks.compactMap {
                    //create a view controller for each task
                    let card = self.taskViewController(for: $0, on: date)
                    //if it is a future date, we'll diasbe interaction with the task card
//                    card?.view.isUserInteractionEnabled = !isFuture
                    //reduces the opacity to visually indicating that it's disable
//                    card?.view.alpha = isFuture ? 0.4 : 1.0
                    
                    
                    return card
                    
                }.forEach {
                    // append the view controller to the list
                    listViewController.appendViewController($0, animated: false)
                }
            }
            
         
            
        }
        func surveyTask(
            viewController: CustomSurveyTaskViewController,
            for task: OCKAnyTask,
            didFinish result: Result<ORKTaskViewControllerFinishReason, Error>) {
                
                if case let .success(reason) = result, reason == .completed {
                    reload()
                }
            }
    }
    //    Define a method that checks if onboarding is complete
    private func checkIfOnboardingIsComplete(_ completion: @escaping(Bool) -> Void){
        
        var query = OCKOutcomeQuery() //for all the outcomes associated wiht the onboardTask
        query.taskIDs = [TaskIDs.onboarding]
        
        storeManager.store.fetchAnyOutcomes(
            query: query,
            callbackQueue: .main) { result in
                
                switch result {
                    
                case .failure:
                    print("Failed to fetch onboarding outcomes!")
                    completion(false)
                    
                case let .success(outcomes):
                    completion(!outcomes.isEmpty) //it means it is not finished yet
                    
                }
            }
    }
//query all the tasks to be displayed on a given date
    private func fetchTasks(
        on date: Date,
        completion: @escaping([OCKAnyTask]) -> Void) {
            
            var query = OCKTaskQuery(for: date)
            query.excludesTasksWithNoEvents = true
            //escludes task that don't have any scheduled events, for tasks that don't happen everyday
            
            
            storeManager.store.fetchAnyTasks(
                query: query,
                callbackQueue: .main){ result in
                    
                    switch result {
                        
                    case .failure:
                        print("Failed to fetch tasks for date \(date)")
                        completion([])
                        
                    case let .success(tasks):
                        completion(tasks)
                    }
                }
        }
 
  
    
    //create a card for a given task
    private func taskViewController(
        for task: OCKAnyTask,
        on date: Date) -> UIViewController? {
            
            let isFuture = Calendar.current.compare(
                date,
                to: Date(),
                toGranularity: .day) == .orderedDescending
            

            let isPast = Calendar.current.compare(date,
                                                  to: Date(),
                                                  toGranularity: .day) == .orderedAscending
        
            
            let isFutureH = Calendar.current.compare(
                Date(),
                to: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: date)!,
                toGranularity: .minute) == .orderedDescending
            
            let isPastH = Calendar.current.compare(
                Date(),
                to: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: date)!,
                toGranularity: .minute) == .orderedAscending
            
            
            
//            print(isPastinDay)

        switch task.id {

        case TaskIDs.checkIn:

            let survey = CustomSurveyTaskViewController(
                task: task,
                eventQuery: OCKEventQuery(for: date),
                storeManager: storeManager,
                survey: Surveys.checkInSurvey(),
                viewSynchronizer: SurveyViewSynchronizer(),
                extractOutcome: Surveys.extractAnswersFromCheckInSurvey
            )

            
            //disable editing of past tasks
            survey.surveyDelegate = self
            

            return survey

        case TaskIDs.rangeOfMotionCheck:
            let survey = CustomSurveyTaskViewController(
                task: task,
                eventQuery: OCKEventQuery(for: date),
                storeManager: storeManager,
                survey: Surveys.rangeOfMotionCheckLeft(),
                extractOutcome: Surveys.extractRangeOfMotionOutcomeLeft
            )
            
            survey.view.isUserInteractionEnabled = !isFuture
            survey.view.alpha =  isFuture ? 0.4 : 1.0
            survey.view.isHidden = isPast

            survey.surveyDelegate = self
            
            return survey
        case TaskIDs.rangeOfMotionCheckOther:
            let survey = CustomSurveyTaskViewController(
                task: task,
                eventQuery: OCKEventQuery(for: date),
                storeManager: storeManager,
                survey: Surveys.rangeOfMotionCheckRight(),
                extractOutcome: Surveys.extractRangeOfMotionOutcomeRight
            )
            
            survey.view.isUserInteractionEnabled = !isFuture
            survey.view.alpha =  isFuture ? 0.4 : 1.0
            survey.view.isHidden = isPast

            survey.surveyDelegate = self
            
            return survey
        
        case TaskIDs.bodyMap:
            let survey = CustomSurveyTaskViewController(
                task: task,
                eventQuery: OCKEventQuery(for: date),
                storeManager: storeManager,
                survey: Surveys.bodyCheck(),
                extractOutcome: Surveys.extractBodyOutcome
            )
            
            
            survey.view.isUserInteractionEnabled = !isFutureH && !isFuture
            survey.view.alpha = isFutureH || isFuture ? 0.4 : 1.0
            survey.view.isHidden = isPast

            
            
            survey.surveyDelegate = self
            return survey
            
        case TaskIDs.bodyMap2:
            let survey = CustomSurveyTaskViewController(
                task: task,
                eventQuery: OCKEventQuery(for: date),
                storeManager: storeManager,
                survey: Surveys.bodyCheck(),
                extractOutcome: Surveys.extractBodyOutcome
            )
            
        
            
            survey.view.isUserInteractionEnabled = !isPastH && !isFuture
            survey.view.alpha = isPastH || isFuture ? 0.4 : 1.0
            survey.view.isHidden = isPast
            
            survey.surveyDelegate = self
            return survey
            
         

        default:
            return nil
        }
    }
    
    //disallowing deleting past outcomes, however we can still redo survey on the current date 
    func surveyTask(
        viewController: OCKSurveyTaskViewController,
        shouldAllowDeletingOutcomeForEvent event: OCKAnyEvent) -> Bool {
            
            event.scheduleEvent.start >= Calendar.current.startOfDay(for: Date())
            //if the date if earlier than today then it means the outcomes cannot be deleted
        }
    
    @IBAction func subscribeToNotifications(_ sender: Any) {
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
        }
    }

    public func showDeviceToken(_ tokenString: String) {
        deviceTokenLabel.text = "Device Token: \n\(tokenString)"
    }
    
    
    
    
}


// Custom View Synchronizer, to view the answer given in a task
final class SurveyViewSynchronizer: OCKSurveyTaskViewSynchronizer {
    
    //update view everytime the data in the store changes
    override func updateView(_ view: OCKInstructionsTaskView,
        context: OCKSynchronizationContext<OCKTaskEvents>) {

        //apply costumization to the view
        super.updateView(view, context: context)

        //applying enhancement, check to see if there is an event with a completed outcome
        if let event = context.viewModel.first?.first, event.outcome != nil {
            view.instructionsLabel.isHidden = false
            
        
            let pain = event.answer(kind: Surveys.checkInPainItemIdentifier)
            let sleep = event.answer(kind: Surveys.checkInSleepItemIdentifier)
            let stress = event.answer(kind: Surveys.checkInStressItemIdentifier)

            //string interpolation to show the answers given afted the completition of the survey, they'll show on the card itself
            view.instructionsLabel.text = """
                Pain: \(Int(pain))
                Sleep: \(Int(sleep)) hours
                Stress: \(Int(stress)) level
                """
        } else {
            view.instructionsLabel.isHidden = true
        }
    }
}

