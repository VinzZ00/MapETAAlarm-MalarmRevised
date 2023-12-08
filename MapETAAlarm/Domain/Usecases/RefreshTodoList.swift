//
//  RefreshTodoList.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 08/12/23.
//

import Foundation
import CoreData

class RefreshTodoListUsecase {
    var repo = LocalRepository()
    
    func call(moc : NSManagedObjectContext) async throws {
        switch await repo.CoreData.getRecord(moc: moc) {
        case .success(let data):
            try data.forEach { tdList in
                if tdList.dateTime! < Date() {
                    tdList.status = "Complete"
                }
                
                do {
                    try tdList.managedObjectContext?.save()
                } catch {
                    throw error
                }
                
            }
        case .failure(let err):
            throw err
        }
    }
}
