//
//  DeleteTodoList.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 07/12/23.
//

import Foundation
import CoreData

class DeleteTodoListUseCase {
    var repository = LocalRepository()
    
    func call(moc : NSManagedObjectContext, todolist : TodoList) async throws{
        try await repository.CoreData.deleteTodoList(moc: moc, todolist: todolist)
    }
}


