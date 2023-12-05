//
//  FormViewModel.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import MapKit
import CoreData

class FormViewModel : ObservableObject {
    lazy var saveTodoList = AddTodoListUseCase()
    
    @Published var searchPageViewModel : SearchPageViewModel = SearchPageViewModel()
    @Published var error : NSError?
    @Published var eventName : String = "";
    @Published var eventDescription : String = "";
    @Published var selectedTime : Date = Date();
    @Published var locationManager = CoreLocationHandler.shared
    
    func saveToCoreData(todolist : TodoListDTO, moc : NSManagedObjectContext) async {
        do {
            try await saveTodoList.call(moc: moc, todoList: todolist)
        } catch {
            // TODO: Handle this error
            fatalError("Failed to save to coreData")
        }
    }
    
    func getETA(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (MKDirections.ETAResponse?, Error?) -> Void) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculateETA { (response, error) in
            completion(response, error)
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
    
}
