//
//  TodoListObject.swift
//  MAlarm
//
//  Created by Elvin Sestomi on 26/11/23.
//

import Foundation
import CoreData

struct TodoListDTO : Identifiable, Hashable {
    
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
}
