//
//  CoreData.swift
//  ETAMapAlarm
//
//  Created by Elvin Sestomi on 03/12/23.
//

import Foundation
import CoreData

protocol CoreDataDataSourceProtocol {
    func getRecord(moc : NSManagedObjectContext) async -> Result<[TodoListNS], Error>
    
    func saveRecord(moc : NSManagedObjectContext, todolist : TodoList) async throws
    
    func updateRecord(moc : NSManagedObjectContext, todolist : TodoList) async throws
}

class CoreDataDataSource : CoreDataDataSourceProtocol {
    
    func getRecord(moc : NSManagedObjectContext) async -> Result<[TodoListNS], Error> {
        
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
    
    func saveRecord(moc : NSManagedObjectContext, todolist : TodoList) async throws {
        guard let nsTodolist = todolist.intoNS(moc: moc) else {
            fatalError("todo list can't be converted into NSObject")
        }
        
        try nsTodolist.managedObjectContext?.save()
        
    }
    
    func updateRecord(moc : NSManagedObjectContext, todolist : TodoList) async throws {
        
        var datas : [TodoListNS]?
        
        switch await self.getRecord(moc: moc) {
        case .success(let fdata):
            datas = fdata
        case .failure(let failure):
            throw failure
        }
        
        let data = datas?.first(where: { tdls in
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
        
        if let newRec = data {
            try newRec.managedObjectContext?.save()
        }
        
    }
    
    func deleteTodoList(moc : NSManagedObjectContext, todolist : TodoList) async throws {
        var datas : [TodoListNS]?
        
        switch await self.getRecord(moc: moc) {
        case .success(let fdata):
            datas = fdata
        case .failure(let failure):
            throw failure
        }
        
        if datas != nil {
            if let willBeDeleted = datas?.first(where: { tdlist in
                tdlist.uuid! == todolist.id
            }) {
                moc.delete(willBeDeleted)
            }
        }
    }
}
