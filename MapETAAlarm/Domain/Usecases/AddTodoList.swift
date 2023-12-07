//
//  AddTodoList.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData


class AddTodoListUseCase {
    var repo = LocalRepository()
//    static let shared = AddTodoListUseCase()
    
    func call(moc : NSManagedObjectContext, todoList : TodoList) async throws {
        try await repo.CoreData.saveRecord(moc: moc, todolist: todoList)
    }
}
