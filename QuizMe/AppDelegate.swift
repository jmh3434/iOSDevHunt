//
//  AppDelegate.swift
//  QuizMe
//
//  Created by James Hunt on 3/4/17.
//  Copyright © 2017 James Hunt. All rights reserved.
//

import UIKit
import Firebase
import Parse
import FBSDKCoreKit
var notificationMessage = ""
var IAnotherUserMadeAQuiz = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize Parse.
        let configuration = ParseClientConfiguration {
            $0.applicationId = "R88YwDu1g1WOTR508ncmJxGqMBoQUFOwO01vmpY5"
            $0.clientKey = "gS4SIBNBapzMAS4bSd4q1IIK0WewOjPh2rWhPFFW"
            $0.server = "https://parseapi.back4app.com"
        }
        
        Parse.initialize(with: configuration)
        // Override point for customization after application launch.
        FIRApp.configure()
        
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

   

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

