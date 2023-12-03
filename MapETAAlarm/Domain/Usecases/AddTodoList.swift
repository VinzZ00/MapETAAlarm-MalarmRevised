//
//  AddTodoList.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData

protocol AddTodoListProtocol {
    
}

class AddTodoListUseCase : AddTodoListProtocol {
    var repo = LocalRepository()
    
    func call(moc : NSManagedObjectContext, todoList : TodoListDTO) async throws {
        try await repo.CoreData.saveTodoList(moc: moc, todolist: todoList)
    }
}
