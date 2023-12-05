//
//  FetchingTodoList.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData

protocol FetchTodoListProtocol {
    
}

class FetchTodoListUseCase : FetchTodoListProtocol {
    let repository : LocalRepository = LocalRepository()
//    static let shared = FetchTodoListUseCase()
    
    func call(moc : NSManagedObjectContext) async throws -> [TodoListDTO]{
        switch await repository.CoreData.GetTodoList(moc: moc) {
        case .success(let data):
            return data.map{$0.intoDTO()}
        case .failure(let failure):
            throw failure
        }
    }
}
