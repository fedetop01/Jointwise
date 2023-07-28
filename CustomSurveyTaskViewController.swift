//
//  CustomSurveyTaskViewController.swift
//  App
//
//  Created by Federica on 23/02/23.
//

import Foundation
import CareKitUI
import CareKit
import CareKitStore
import UIKit

class CustomSurveyTaskViewController: OCKSurveyTaskViewController {
    
    
    
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        
        var detailImageFileName: String
        var summary: String

        

        switch self.survey.identifier {
        
        case "onboard":
            detailImageFileName = "consent"
            summary = "This informed consent document outlines the expectations and requirements of participating in a study for individuals already diagnosed with Arthritis's disease."
          
        case "checkin":
            detailImageFileName = "checkIn"
            summary = "This daily task involves completing a brief survey to track the progression of your arthritis. You will be asked general questions about your overall condition every day. This will help us monitor your symptoms and identify any changes or patterns over time."
        
        case "rangeOfMotion.right":
            detailImageFileName = "rangeMotion"
            summary = "The range of motion task involves providing participants with instructions that are spoken by Siri, while they execute a series of steps to capture data on the maximum extension of the knee or shoulder.\n This data is collected using the accelerometer and gyroscope sensors of the participant's mobile device. By following the instructions and performing the steps correctly, participants can help researchers gain a better understanding of their range of motion of their rigth knee and improve the accuracy of their measurements."
        case "rangeOfMotion.left":
            detailImageFileName = "rangeMotion"
            summary = "The range of motion task involves providing participants with instructions that are spoken by Siri, while they execute a series of steps to capture data on the maximum extension of the knee or shoulder.\n This data is collected using the accelerometer and gyroscope sensors of the participant's mobile device. By following the instructions and performing the steps correctly, participants can help researchers gain a better understanding of their range of motion their left knee and improve the accuracy of their measurements."
            
        case "myBodyCheckTask":
            detailImageFileName = "bodyCheck"
            summary = "The body check-up task requires necessitates that you identify the specific joint that are causing you pain. Subsequently, you will be prompted to rate the level of pain experienced in both the left and right joints that have been identified."
            
        default:
            return
        }
        
        do {
                    let detailsViewController = try controller.initiateDetailsViewController(forIndexPath: eventIndexPath)
            detailsViewController.detailView.imageView.image = UIImage(named: detailImageFileName)
            detailsViewController.detailView.bodyLabel.text = summary
                    present(detailsViewController, animated: true)
                } catch {
                    if delegate == nil {
                        print("CareKit error: A task error occurred, but no delegate was set to forward it to! \(error)")
                    }
                    delegate?.taskViewController(self, didEncounterError: error)
                }
    }
}
