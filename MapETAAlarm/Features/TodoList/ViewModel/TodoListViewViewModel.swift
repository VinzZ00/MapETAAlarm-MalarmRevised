//
//  TodoListPageViewModel.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreData

@MainActor class TodoListViewViewModel : ObservableObject {
    @Published var todolists : [TodoListDTO] = []
    @Published var showForm : Bool = false
    lazy var getUseCase : FetchTodoListUseCase = FetchTodoListUseCase()
    @Published var err : Error?
    @Published var formViewModel : FormViewModel = FormViewModel()
    
    func getTodoList(moc : NSManagedObjectContext) async {
        do {
            self.todolists = try await getUseCase.call(moc: moc)
        } catch let err{
            self.err = err
        }
    }
    
    
}
