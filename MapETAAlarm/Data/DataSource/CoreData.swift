//
//  CoreData.swift
//  ETAMapAlarm
//
//  Created by Elvin Sestomi on 03/12/23.
//

import Foundation
import CoreData

protocol CoreDataDataSourceProtocol {
    func GetTodoList(moc : NSManagedObjectContext) async -> Result<[TodoListNS], Error> 
}

class CoreDataDataSource : CoreDataDataSourceProtocol {
    
    func GetTodoList(moc : NSManagedObjectContext) async -> Result<[TodoListNS], Error> {
        
        let fetchRequest = TodoListNS.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key : "dateTime", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let fetchedItems = try moc.fetch(fetchRequest)
            return .success(fetchedItems);
        } catch let err {
            return .failure(err)
        }
    }
    
    func saveTodoList(moc : NSManagedObjectContext, todolist : TodoListDTO) async throws {
        let nsTodolist = todolist.intoNS(moc: moc);
        try moc.save()
    }
}
