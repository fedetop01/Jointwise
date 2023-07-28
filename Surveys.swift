//
//  Surveys.swift
//  App
//
//  Created by Federica Topazio on 22/02/23.
//

import Foundation
import ResearchKit
import CareKit
import CareKitStore

struct Surveys {
    
    private init() {}
    
    // MARK: - OnBoarding Survey
    
    static func onboardingSurvey() -> ORKTask {
        
        // The Welcome Instruction step.
        let welcomeInstructionStep = ORKInstructionStep(
            identifier: "onboarding.welcome"
        )
        
        welcomeInstructionStep.title = "Welcome!"
        welcomeInstructionStep.detailText = "Thank you for joining our study. Tap Next to learn more before signing up."
        welcomeInstructionStep.image = UIImage(named: "welcome-image")
        welcomeInstructionStep.imageContentMode = .scaleAspectFill
        
        // The Informed Consent Instruction step.
        let studyOverviewInstructionStep = ORKInstructionStep(
            identifier: "onboarding.overview"
        )
        
        studyOverviewInstructionStep.title = "Before You Join"
        studyOverviewInstructionStep.iconImage = UIImage(systemName: "checkmark.seal.fill")
        
        let heartBodyItem = ORKBodyItem(
            text: "The study will ask you to share some of your health data.",
            detailText: nil,
            image: UIImage(systemName: "heart.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        let completeTasksBodyItem = ORKBodyItem(
            text: "You will be asked to complete various tasks over the duration of the study.",
            detailText: nil,
            image: UIImage(systemName: "checkmark.circle.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        let signatureBodyItem = ORKBodyItem(
            text: "Before joining, we will ask you to sign an informed consent document.",
            detailText: nil,
            image: UIImage(systemName: "signature"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        let secureDataBodyItem = ORKBodyItem(
            text: "Your data is kept private and secure.",
            detailText: nil,
            image: UIImage(systemName: "lock.fill"),
            learnMoreItem: nil,
            bodyItemStyle: .image
        )
        
        studyOverviewInstructionStep.bodyItems = [
            heartBodyItem,
            completeTasksBodyItem,
            signatureBodyItem,
            secureDataBodyItem
        ]
        
        // The Signature step (using WebView).
        let webViewStep = ORKWebViewStep(
            identifier: "onboarding.signatureCapture",
            html: informedConsentHTML
        )
        
        webViewStep.showSignatureAfterContent = true //this allows to show the box for the signature box
        
        // The Request Permissions step.
        let healthKitTypesToWrite: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]
        
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .appleStandTime)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.quantityType(forIdentifier: .height)!,
            HKObjectType.quantityType(forIdentifier: .bodyMass)!
            
        ]
        
        let healthKitPermissionType = ORKHealthKitPermissionType(
            sampleTypesToWrite: healthKitTypesToWrite,
            objectTypesToRead: healthKitTypesToRead
        )
        
        let notificationsPermissionType = ORKNotificationPermissionType(
            authorizationOptions: [.alert, .badge, .sound]
        )
        
        let motionPermissionType = ORKMotionActivityPermissionType()
        
        let requestPermissionsStep = ORKRequestPermissionsStep(
            identifier: "onboarding.requestPermissionsStep",
            permissionTypes: [
                healthKitPermissionType,
                notificationsPermissionType,
                motionPermissionType
            ]
        )
        
        requestPermissionsStep.title = "Health Data Request"
        requestPermissionsStep.text = "Please review the health data types below and enable sharing to contribute to the study."
        //        Tutorial step
                let tutorialStep = ORKWebViewStep(
                    identifier: "onboarding.tutorialStep",
                    html: tutorialHTML)
                tutorialStep.title = "App Tutorial"

        
        // Completion Step
        let completionStep = ORKCompletionStep(
            identifier: "onboarding.completionStep"
        )
        
        completionStep.title = "Enrollment Complete"
        completionStep.text = "Thank you for enrolling in this study. Your participation will contribute to meaningful research!"
        
        let surveyTask = ORKOrderedTask(
            identifier: "onboard",
            steps: [
                welcomeInstructionStep,
                studyOverviewInstructionStep,
                webViewStep,
                requestPermissionsStep,
                tutorialStep,
                completionStep
            ]
        )
        
        return surveyTask
    }

    
    // MARK: - Check-in Survey

    
    static let checkInIdentifier = "checkin"
    static let checkInFormIdentifier = "checkin.form"
    static let checkInPainItemIdentifier = "checkin.form.pain"
    static let checkInSleepItemIdentifier = "checkin.form.sleep"
    static let checkInStressItemIdentifier = "checkin.form.stress"
    
    //create the survey
    static func checkInSurvey() -> ORKTask {
        
        let painAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 10,
            minimumValue: 1,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: "Very painful",
            minimumValueDescription: "No pain"
        )
        
        let painItem = ORKFormItem(
            identifier: checkInPainItemIdentifier,
            text: "How would you rate your overnight pain?",
            answerFormat: painAnswerFormat
            //what kind of answer do we expect and how to prompt the user to answer it
        )
        painItem.isOptional = false
        //cannot submit the form without the answer to this item
        
        let sleepAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 12,
            minimumValue: 0,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: nil,
            minimumValueDescription: nil
        )
        //informazione che va presa dai dati dell'applewatch/healthkit se disponibile
        let sleepItem = ORKFormItem(
            identifier: checkInSleepItemIdentifier,
            text: "How many hours of sleep did you get last night?",
            answerFormat: sleepAnswerFormat
        )
        sleepItem.isOptional = false
        
        
        let stressAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 10,
            minimumValue: 0,
            defaultValue: 0,
            step: 1,
            vertical: false,
            maximumValueDescription: nil,
            minimumValueDescription: nil
        )
        
        let stressItem = ORKFormItem(
            identifier: checkInStressItemIdentifier,
            text: "How would you rate your stress level?",
            answerFormat: stressAnswerFormat
        )
        stressItem.isOptional = false
        
        
        
        //create a form with 2 questions
        let formStep = ORKFormStep(
            identifier: checkInFormIdentifier,
            title: "Check In",
            text: "Please answer the following questions."
        )
        
        formStep.formItems = [painItem, sleepItem, stressItem]
        //is not optional, so the form will not be skippable
        formStep.isOptional = false
        
        let surveyTask = ORKOrderedTask(
            identifier: checkInIdentifier,
            steps: [formStep]
        )
        
        return surveyTask
    }
    
    // MARK: - Extract Check-in Survey
    
    static func extractAnswersFromCheckInSurvey(
        _ result: ORKTaskResult) -> [OCKOutcomeValue]? {
            
            guard
                let response = result.results?
                    .compactMap({ $0 as? ORKStepResult })
                    .first(where: { $0.identifier == checkInFormIdentifier }),
                
                    let scaleResults = response
                    .results?.compactMap({ $0 as? ORKScaleQuestionResult }),
                
                    let painAnswer = scaleResults
                    .first(where: { $0.identifier == checkInPainItemIdentifier })?
                    .scaleAnswer,
                
                    let sleepAnswer = scaleResults
                    .first(where: { $0.identifier == checkInSleepItemIdentifier })?
                    .scaleAnswer,
                    
                    let stressAnswer = scaleResults
                    .first(where: { $0.identifier == checkInStressItemIdentifier })?
                    .scaleAnswer
                    
            else {
                assertionFailure("Failed to extract answers from check in survey!")
                return nil
            }
            
            var painValue = OCKOutcomeValue(Double(truncating: painAnswer))
            painValue.kind = checkInPainItemIdentifier
            
            var stressValue = OCKOutcomeValue(Double(truncating: stressAnswer))
            stressValue.kind = checkInStressItemIdentifier
            
            var sleepValue: OCKOutcomeValue?
            
            let dispatchGroup = DispatchGroup() // Creazione dell'oggetto DispatchGroup
                    
                    
                    dispatchGroup.enter() // Indicazione dell'avvio di una chiamata asincrona
                    
                    sleepingDataAcquisition { value in // Chiamata asincrona
                        sleepValue = value // Assegnazione del valore di ritorno alla variabile sleepValue
                        dispatchGroup.leave() // Indicazione della fine della chiamata asincrona
                    }
                    
                    dispatchGroup.wait() // Blocco dell'esecuzione del codice fino a quando la chiamata asincrona non viene completata
                    
           
            sleepValue?.kind = checkInSleepItemIdentifier
            
            if let sleepValue = sleepValue,
               let sleepDoubleValue = sleepValue.value as? Double,
               sleepDoubleValue > 0.0 {
                return [painValue, sleepValue, stressValue]
            } else {
                sleepValue = OCKOutcomeValue(Double(truncating: sleepAnswer))
                sleepValue?.kind = checkInSleepItemIdentifier
            }
            
            
            
            return [painValue, sleepValue ?? OCKOutcomeValue(0.0), stressValue]
        }
    
    
    
    // MARK: - Range of Motion Left
    
    static let rangeOfMotionLeft = "rangeOfMotion.left"
    static let rangeOfMotionRight = "rangeOfMotion.right"
    
    
    static func rangeOfMotionCheckLeft() -> ORKTask {
        
        let rangeOfMotionOrderedTask = ORKOrderedTask.kneeRangeOfMotionTask(
            withIdentifier: rangeOfMotionLeft,
            limbOption: .left,
            intendedUseDescription: nil,
            options: [.excludeConclusion] //omit the standard complition step
        )
        
        let completionStep = ORKCompletionStep(identifier: "rom.completion")
        completionStep.title = "All done!"
        completionStep.detailText = "Don't give up, we know it can be tough."
        
        //        rangeOfMotionOrderedTask.appendSteps([completionStep])
        
        rangeOfMotionOrderedTask.addSteps(from: [completionStep])
        
        return rangeOfMotionOrderedTask
    }
    
    // MARK: - Extract Range of Motion Left
    
    static func extractRangeOfMotionOutcomeLeft(
        _ result: ORKTaskResult) -> [OCKOutcomeValue]? {
            
            guard let motionResult = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .compactMap({ $0.results })
                .flatMap({ $0 })
                .compactMap({ $0 as? ORKRangeOfMotionResult })
                .first else {
                
                assertionFailure("Failed to parse range of motion result")
                return nil
            }
            //motionResult= how much the user was able to bend their knee in degree
            var range = OCKOutcomeValue(motionResult.range)
           range.kind = #keyPath(ORKRangeOfMotionResult.range)
            //set the kind to look at it later, in an easier way
            
//            range.kind = rangeOfMotionLeft
            
            return [range]
        }
    
    
    // MARK: - Range of Motion Right
    
    static func rangeOfMotionCheckRight() -> ORKTask {
        
        let rangeOfMotionOrderedTask = ORKOrderedTask.kneeRangeOfMotionTask(
            withIdentifier: rangeOfMotionRight,
            limbOption: .right,
            intendedUseDescription: nil,
            options: [.excludeConclusion] //omit the standard complition step
        )
        
        let completionStep = ORKCompletionStep(identifier: "rom.completion")
        completionStep.title = "All done!"
        completionStep.detailText = "Don't give up, we know it can be tough."
        
        
        
        rangeOfMotionOrderedTask.addSteps(from: [completionStep])
        
        return rangeOfMotionOrderedTask
    }
    
    // MARK: - Extract Range of Motion Right
    
    static func extractRangeOfMotionOutcomeRight(
        _ result: ORKTaskResult) -> [OCKOutcomeValue]? {
            
            guard let motionResult = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .compactMap({ $0.results })
                .flatMap({ $0 })
                .compactMap({ $0 as? ORKRangeOfMotionResult })
                .first else {
                
                assertionFailure("Failed to parse range of motion result")
                return nil
            }
            //motionResult= how much the user was able to bend their knee in degree
            var range = OCKOutcomeValue(motionResult.range)
         range.kind = #keyPath(ORKRangeOfMotionResult.range)
            //set the kind to look at it later, in an easier way
//            range.kind = rangeOfMotionRight
            
            
            return [range]
        }
    
    // MARK: - Body Check
    
    static let bodyTaskId = "bodyTask"
    static let bodyCustomId = "bodyTask.custom"
    static let bodyFormId = "bodyTask.form"
    static let bodyPainItemId = "bodyTask.form.pain"
    static let BodyPartSelectedId = "bodyTask.BodyPartSelected"
    static let BodyView = BodyCheckView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
    
    //create a static function to define the body check task and its corresponding outcome extraction function
    static func bodyCheck() -> ORKTask {
        
        // Crea un passo personalizzato contenente la tua view personalizzata
        let BodyStep = ORKCustomStep(identifier: bodyCustomId)
        BodyStep.isOptional = false
        BodyStep.title = "Body Check"

        
        // Aggiungi la tua view personalizzata come subview del passo personalizzato
        BodyStep.contentView = BodyView

        
        let PainAnswerFormat = ORKAnswerFormat.scale(
            withMaximumValue: 10,
            minimumValue: 1,
            defaultValue: 1,
            step: 1,
            vertical: false,
            maximumValueDescription: "highly painful",
            minimumValueDescription: "slightly painful"
        )
        //informazione che va presa dai dati dell'applewatch/healthkit se disponibile
        let PainItem = ORKFormItem(
            identifier: bodyPainItemId,
            text: "How would you rate your overall pain?",
            answerFormat: PainAnswerFormat
        )
        PainItem.isOptional = false
        
        
        
        let formStep = ORKFormStep(
            identifier: bodyFormId,
            title: "Check In",
            text: "Please answer the following question."
        )
        
        
        
        
        formStep.formItems = [PainItem]
        //is not optional, so the form will not be skippable
        formStep.isOptional = false
        
        
        
        
        // Crea una task e aggiungi il passo personalizzato come suo unico passo
        let task = ORKOrderedTask(identifier: "myBodyCheckTask", steps: [BodyStep, formStep])
        return task
    }
    
    
    // MARK: - Extract Body Check
    
    static func extractBodyOutcome(_ result: ORKTaskResult) -> [OCKOutcomeValue]? {
        
        let bodyPartSelected = BodyView.WhatIsSelected()
        var arrayResult = [ORKResult]()
        
        for partSelected in bodyPartSelected {
            let resulte = ORKTextQuestionResult(identifier: BodyPartSelectedId)
            resulte.textAnswer = partSelected
            arrayResult.append(resulte)
        }
        
        
        result.results?.append(ORKStepResult(stepIdentifier: "BodyStep", results: arrayResult))
        
        
        guard
            let response = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .first(where: {$0.identifier == bodyFormId}),
            
                let scaleResults = response.results?
                .compactMap({ $0 as? ORKScaleQuestionResult }),
            
                let painAnswer = scaleResults
                .first(where: { $0.identifier == bodyPainItemId })?
                .scaleAnswer
            
                
                

        else {
            assertionFailure("Failed to extract answers from check in survey!")
            return nil
        }
        
        
        var painValue = OCKOutcomeValue(Double(truncating: painAnswer))
        painValue.kind = bodyPainItemId
        

        
        guard
            let responsePart = result.results?
                .compactMap({ $0 as? ORKStepResult })
                .first(where: {$0.identifier == "BodyStep"}),

                let bodyResult = responsePart.results?
            .compactMap({ $0 as? ORKTextQuestionResult }),


                !bodyResult.isEmpty else {
                        assertionFailure("Failed to extract answers from check in survey!")
                        return nil
                    }

                let bodyPart = bodyResult.compactMap({ $0.textAnswer })
    
        var arrayOutComeValue = [OCKOutcomeValue]()
        
        for part in bodyPart {
            var bodyPartValue = OCKOutcomeValue(part)
            arrayOutComeValue.append(bodyPartValue)
        }
        
        arrayOutComeValue.append(painValue)
        
        print("Il Risultato è: ", arrayOutComeValue)
        
        
        return arrayOutComeValue
    }
    
    

}

//consigliato l'uso dell'apple watch per una maggiore aderenza alle ore di sonno effettuate 

    // MARK: - Sleeping Data Acquisition

func sleepingDataAcquisition(completion: @escaping (OCKOutcomeValue?) -> Void) {
    
    let calendar = Calendar.current
    let now = Date()
    let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
    let predicate = HKQuery.predicateForSamples(withStart: yesterday, end: now, options: .strictStartDate)

    let query = HKSampleQuery(sampleType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, results, error) in
        guard let samples = results as? [HKCategorySample], error == nil else {
            print("Error: \(error!.localizedDescription)")
            completion(nil)
            return
        }

        var totalSleepDuration = 0.0

        
        for sample in samples {
            
            if (sample.value == HKCategoryValueSleepAnalysis.asleepDeep.rawValue) || (sample.value == HKCategoryValueSleepAnalysis.asleepCore.rawValue) || (sample.value == HKCategoryValueSleepAnalysis.asleepREM.rawValue)
            {
                
                let duration = sample.endDate.timeIntervalSince(sample.startDate)
                totalSleepDuration += duration
                
            }
        }

        let hoursOfSleep = totalSleepDuration / 3600.0
        print("Last night, you slept for \(String(describing: hoursOfSleep)) hours.")
        
        let sleepValue = OCKOutcomeValue(hoursOfSleep)
        completion(sleepValue)
    }

    HKHealthStore().execute(query)
    
}



































