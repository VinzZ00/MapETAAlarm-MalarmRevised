//
//  UpdateTodoList.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData

protocol  UpdateTodoListProtocol {

}

class UpdateTodoListUseCase : UpdateTodoListProtocol {
    var repo = LocalRepository()
//    static let shared = UpdateTodoListUseCase()
    
    func call(moc : NSManagedObjectContext, todolist : TodoList) async throws {
        
        try await repo.CoreData.updateTodoList(moc: moc, todolist: todolist)
    }
}
