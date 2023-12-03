//
//  TodoListObject.swift
//  MAlarm
//
//  Created by Elvin Sestomi on 26/11/23.
//

import Foundation
import CoreData

struct TodoListDTO : Identifiable {
    var dateTime : Date?
    var eventDescription : String?
    var id : UUID
    var uLatitude : Double?
    var uLongitude : Double?
    var dLatitude : Double?
    var dLongitude : Double?
    var name : String?
    var status : String?
    var transportationType : String?
    
    init(dateTime: Date, eventDescription: String, id: UUID, uLatitude: Double, uLongitude: Double, dLatitude : Double, dLongitude : Double, name: String, status: String, transportationType: String) {
        self.dateTime = dateTime
        self.eventDescription = eventDescription
        self.id = id
        self.uLatitude = uLatitude
        self.uLongitude = uLongitude
        self.dLatitude = dLatitude
        self.dLongitude = dLongitude
        self.name = name
        self.status = status
        self.transportationType = transportationType
    }
    
    init(dateTime: Date, eventDescription: String, uLatitude: Double, uLongitude: Double, dLatitude : Double, dLongitude : Double, name: String, status: String, transportationType: String) {
        self.dateTime = dateTime
        self.eventDescription = eventDescription
        self.id = UUID()
        self.uLatitude = uLatitude
        self.uLongitude = uLongitude
        self.dLatitude = dLatitude
        self.dLongitude = dLongitude
        self.name = name
        self.status = status
        self.transportationType = transportationType
    }
    
    
    func intoNS(moc : NSManagedObjectContext) -> TodoListNS? {
        var tdList = TodoListNS(context: moc)
        tdList.dateTime = self.dateTime
        tdList.eventDescription = self.eventDescription
        
        
        // MARK: User
        if self.uLatitude != nil && self.uLongitude != nil {
            tdList.uLatitude = self.uLatitude!
            tdList.uLongitude = self.uLongitude!
        } else {
            print("Todolist Latitude and longitude is still nil")
            return nil
        }
        
        // MARK: Destination
        if self.dLatitude != nil && self.dLongitude != nil {
            tdList.dLatitude = self.dLatitude!
            tdList.dLongitude = self.dLongitude!
        } else {
            print("Todolist Latitude and longitude is still nil")
            return nil
        }
        
        tdList.name = self.name
        tdList.status = self.status
        tdList.transportationType = self.transportationType
        tdList.uuid = self.id
        return tdList
    }
}
