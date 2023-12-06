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

var x : CoreDataDataSourceProtocol = CoreDataDataSource();

func aaa() {
    if x is CoreDataDataSource {
        (x as! CoreDataDataSource)
    }
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
    
    func saveTodoList(moc : NSManagedObjectContext, todolist : TodoList) async throws {
        let nsTodolist = todolist.intoNS(moc: moc);
        try moc.save()
    }
    
    func updateTodoList(moc : NSManagedObjectContext, todolist : TodoList) async throws {
        
        var datas : [TodoListNS]?
        
        switch await self.GetTodoList(moc: moc) {
        case .success(let fdata):
            datas = fdata
        case .failure(let failure):
            throw failure
        }
        
        var data = datas?.first(where: { tdls in
            tdls.uuid == todolist.id
        })
        
        data?.dLatitude = todolist.dLatitude!
        data?.dLongitude = todolist.dLongitude!
        data?.uLatitude = todolist.uLatitude!
        data?.uLongitude = todolist.uLongitude!
        data?.dateTime = todolist.dateTime
        data?.eventDescription = todolist.eventDescription
        data?.name = todolist.name
        data?.status = todolist.status
        data?.transportationType = todolist.transportationType
        
    }
    
}
