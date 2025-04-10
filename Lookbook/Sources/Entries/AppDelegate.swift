//
//  AppDelegate.swift
//  Lookbook
//
//  Created by Doyoung on 5/9/24.
//

import UIKit
#if RELEASE
import FirebaseCore
#endif
//import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        GADMobileAds.sharedInstance().start(completionHandler: nil)
#if RELEASE
        FirebaseApp.configure()
#endif
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

