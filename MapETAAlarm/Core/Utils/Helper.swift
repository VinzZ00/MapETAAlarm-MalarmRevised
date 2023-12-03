import UserNotifications
import UIKit
import CoreLocation

func provideHapticFeedback() {
    let feedbackGenerator = UINotificationFeedbackGenerator()
    feedbackGenerator.prepare()
    feedbackGenerator.notificationOccurred(.warning)
}

func scheduleAlarm(coordinate : CLLocationCoordinate2D,day: Int, month: Int, year: Int, hour: Int, minute: Int, title : String, description : String) {
    // Create notification content
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = description
    content.sound = .defaultCritical
    
    
    // Create date components for the alarm time
    var dateComponents = DateComponents()
    dateComponents.day = day
    dateComponents.month = month
    dateComponents.year = year
    dateComponents.hour = hour
    dateComponents.minute = minute
    
    // Create notification trigger with calendar-based trigger
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    let identifier : String = "\(coordinate.latitude),\(coordinate.longitude)"
    
    // Create a notification request
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    // Schedule the notification
    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error scheduling notification: \(error)")
        } else {
            print("Notification scheduled successfully")
        }
    }
}
