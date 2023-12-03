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
    
    func call(moc : NSManagedObjectContext, todolist : TodoListDTO) async throws {
        try await repo.CoreData.updateTodoList(moc: moc, todolist: todolist)
    }
}
