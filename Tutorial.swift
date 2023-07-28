
//  Tutorial.swift
//  Jointwise
//
//  Created by Federica Topazio on 15/05/23.
//

import Foundation

let tutorialHTML = """
    <!DOCTYPE html>
        <html lang="en" xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta charset="utf-8" />
        <style type="text/css">

            body {
                box-sizing: border-box;
              font-family: Arial, sans-serif;
              margin: 20px;
            }
            
            h1 {
              color: #333;
              font-size: 24px;
              margin-bottom: 10px;
            }
            
            .step {
              margin-bottom: 30px;
            }
            
            .step h2 {
              color: #333;
              font-size: 20px;
              margin-bottom: 10px;
            }
            
            .step p {
              color: #666;
              font-size: 16px;
              margin-bottom: 15px;
            }
            
            .highlight {
              background-color: #f7f7f7;
              padding: 10px;
              border-radius: 5px;
            }
          </style>
        </head>
        <body>
          <h1>App Tutorial</h1>
          
          <div class="step">
            <h2>Step 1: Daily Task - Sleep Hours, Pain, and Stress</h2>
            <p>Check and log your sleep hours, pain level, and stress level on a daily basis through the questionnaire.</p>
            <p class="highlight">Note: If you have an Apple Watch, your sleep data will be more accurate when integrated with the app.</p>
          </div>
          
          <div class="step">
            <h2>Step 2: Range of Motion Task - Knees Mobility</h2>
            <p>On alternative days, perform a range of motion task to assess your knees' mobility, the task will guide you throughout all the excercise.</p>
          </div>
          
          <div class="step">
            <h2>Step 3: Joint Pain Check for RA</h2>
            <p>Twice a day, use the app to assess and monitor your joint pain.</p>
          </div>
          
          <div class="step">
            <h2>Step 4: Export Monthly Charts as PDF</h2>
            <p>Generate monthly charts based on your logged data. Export these charts as PDF files to show to your physician.</p>
          </div>
          
          <div class="step">
            <h2>Step 5: Export Weekly Charts as PDF</h2>
            <p>Additionally, you can generate weekly charts to track your progress over shorter intervals.</p>
          </div>
          
          <div class="step">
            <h2>Step 6: Monitor Disease Progress</h2>
            <p>Check the dedicated views in the app to monitor the progression of your disease over time, through the Diary, which shows the pain experienced on the specified joints, and an InsightsView, which shows the correlation between sleep, pain, stress, and the Range of Montion outcomes.</p>
            <br><br><br>
          </div>
        </body>
        </html>
    """
