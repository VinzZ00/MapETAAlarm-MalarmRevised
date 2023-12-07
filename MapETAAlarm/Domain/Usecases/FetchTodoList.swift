//
//  FetchingTodoList.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData



class FetchTodoListUseCase {
    let repository : LocalRepository = LocalRepository()
//    static let shared = FetchTodoListUseCase()
    
    func call(moc : NSManagedObjectContext) async throws -> [TodoList]{
        switch await repository.CoreData.getRecord(moc: moc) {
        case .success(let data):
            return data.map{$0.intoDTO()}
        case .failure(let failure):
            throw failure
        }
    }
}
