//
//  SceneDelegate.swift
//  App
//
//  Created by Federica&Biagio on 16/02/23.
//

import UIKit
import CareKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var storeManager: OCKSynchronizedStoreManager {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.storeManagerWrapper.storeManager
    }
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
        
        let feed = CareFeedViewController(storeManager: appDelegate.storeManagerWrapper.storeManager)
        feed.title = "Care Feed"
        feed.tabBarItem = UITabBarItem(
            title: "Care Feed",
            image: UIImage(systemName: "heart.text.square"),
            tag: 0
        )

        let insights = InsightsViewController(storeManager: appDelegate.storeManagerWrapper.storeManager)
        insights.title = "Insights"
        insights.tabBarItem = UITabBarItem(
            title: "Insights",
            image: UIImage(systemName: "waveform.path.ecg"),
            tag: 2
        )
        
        let jointDiary = JointDiaryViewController(storeManager: appDelegate.storeManagerWrapper.storeManager)
//        let jointDiary = JointDiaryViewController()
        jointDiary.title = "Joint Diary"
        jointDiary.tabBarItem = UITabBarItem(
            title: "Joint Diary",
            image: UIImage(systemName: "figure.arms.open"),
            tag: 1)
        
        
        
        
        
        let mySwiftUIView = ProfileUIView()
        let contentView = mySwiftUIView.environmentObject(appDelegate.storeManagerWrapper) // Passa lo store manager alla vista ContentView
                
        let hostingController = UIHostingController(rootView: contentView)

        
        
        let profile = hostingController
        profile.title = "Profile"
        profile.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 4

        )
      
        
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.3873358071, green: 0.1713117063, blue: 0.9851005673, alpha: 1)

        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UITabBar.appearance().backgroundColor = UIColor.systemBackground

        
        
        let root = UITabBarController()
        let feedTab = UINavigationController(rootViewController: feed)
        let insightsTab = UINavigationController(rootViewController: insights)
        let jointDiaryTab = UINavigationController(rootViewController: jointDiary)
        let profileTab = UINavigationController(rootViewController: profile)

        root.setViewControllers([feedTab, jointDiaryTab, insightsTab, profileTab], animated: false)

        
        
        
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.rootViewController = root
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

