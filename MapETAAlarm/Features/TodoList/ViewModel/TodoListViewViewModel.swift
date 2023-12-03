//
//  TodoListPageViewModel.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData

class TodoListViewViewModel : ObservableObject {
    @Published var todolists : [TodoListDTO] = []
    lazy var getUseCase : FetchTodoListUseCase = FetchTodoListUseCase()
    @Published var err : Error?
    
    func getTodoList(moc : NSManagedObjectContext) async {
        do {
            self.todolists = try await getUseCase.call(moc: moc)
        } catch let err{
            self.err = err
        }
    }
    
    
}
