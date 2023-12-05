//
//  TodoListDTO+TodoListNS.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData

extension TodoListDTO {
    func intoNS(moc : NSManagedObjectContext) -> TodoListNS? {
        let tdList = TodoListNS(context: moc)
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

extension TodoListNS {
    func intoDTO() -> TodoListDTO {
        return TodoListDTO(dateTime: self.dateTime!,
                           eventDescription: self.eventDescription!,
                           id: self.uuid!,
                           uLatitude: self.uLatitude,
                           uLongitude: self.uLongitude,
                           dLatitude: self.dLatitude,
                           dLongitude: self.dLongitude,
                           name: self.name!,
                           status: self.status!,
                           transportationType: self.transportationType!)
    }
}
