//
//  FormViewModel.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreLocation
import CoreData
import UserNotifications

class FormViewModel : ObservableObject {
    @Published var searchPageViewModel : SearchPageViewModel = SearchPageViewModel()
    @Published var showAlert : Bool = false
    @Published var error : NSError?
    @Published var eventName : String = "";
    @Published var eventDescription : String = "";
    @Published var selectedTime : Date = Date();
    @Published var locationService = LocationManager.shared
    
    lazy var saveTodoList = AddTodoListUseCase()
    lazy var timeEstimationCalculation = TimeEstimationRequest.shared
    
    func saveToCoreData(todolist : TodoList, moc : NSManagedObjectContext) async {
        do {
            try await saveTodoList.call(moc: moc, todoList: todolist)
        } catch {
            // TODO: Handle this error
            fatalError("Failed to save to coreData")
        }
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
        
        let identifier : String = UUID().uuidString
        
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
        
        let debugNotif = UNUserNotificationCenter.getPendingNotificationRequests(UNUserNotificationCenter.current())
        
        debugNotif{
            nr in
            print("nr count : \(nr.count)")
            nr.forEach { n in
                print("n id : \(n.identifier)")
                print("n trigger : \(n.trigger.debugDescription)")
            }
        }
    }
    
}
