//
//  AppDelegate.swift
//  Nano2ElvinSestomiPersonal
//
//  Created by Elvin Sestomi on 22/05/23.
//

import UIKit
import UserNotifications
import CoreLocation


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Request authorization for notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notification authorization granted")
            } else {
                print("Notification authorization denied")
            }
        }
        
        // Set the delegate of UNUserNotificationCenter
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // Handle the notification presentation as needed
//        // For example, show an alert when the notification is triggered
//        showAlertWithAlarmAction()
//        
//        // Play sound and show alert as default
//        completionHandler([.alert, .sound])
//        
//        // adding haptic feedback
//        provideHapticFeedback()
//    }
    
    
    
    // Implement delegate method to handle notification response when user interacts with the notification
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        // Handle the user's response to the notification
//        // For example, call a custom function
//        let notificationIdentifier = response.notification.request.identifier
//        
//        if notificationIdentifier != "GeofenceNotification" {
//            let coordinate = notificationIdentifier.components(separatedBy: ",")
//            handleAlarmTriggered(latitude: Double(coordinate[0])!, longitude: Double(coordinate[1])!)
//        }
//        
//        completionHandler()
//    }

    // Custom function to execute when the alarm is triggered
//    func handleAlarmTriggered(latitude : Double, longitude : Double) {
//        // Perform your custom actions here
//        let locationManager : LocationManager = LocationManager()
//        
//        locationManager.startMonitoringGeofence(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
//    }

    // Custom function to show an alert when the notification is triggered
//    func showAlertWithAlarmAction() {
//        let alertController = UIAlertController(title: "Alarm", message: "Time to go", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(okAction)
//        
//        // Present the alert
//        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//    }


}

