//
//  AppDelegate.swift
//  Location and Notification
//
//  Created by Maks on 13.03.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestAutorization()
        notificationCenter.delegate = self
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
    
//  Getting permission to use notifications
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print ("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings ) in
            print("Notification settings: \(settings)")
        }
    }
//    Creating notification
    func createNotification(isEnter: Bool){
        let content = UNMutableNotificationContent()
        content.title = "Phone sound"
        content.sound = UNNotificationSound.default
        if isEnter {
            content.body = "You have arrived at the university. We recommend putting your phone in silent mode"
        } else {
            content.body = "You left the university. You can turn on the sound if it is muted"
        }
        
        
        
        //        let center = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
        //        let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
        //        region.notifyOnEntry = true
        //        region.notifyOnExit = false
        //        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifire = "Local Notification"
        
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print ("Error: \(error.localizedDescription)")
            }
        }
    }
    
}

//  Show notifications when the application is running
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
}
