//
//  DetailViewModel.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 07/12/23.
//

import Foundation
import CoreLocation

class DetailTodoListViewModel : ObservableObject {
    var reverseGeocoding = Reversegeocoding.shared
    @Published var alert = false
    @Published var MapKitError : NSError?
    @Published var estimatedTime : Int = 0
    lazy var timeEstimationCalculation = TimeEstimationRequest.shared
    lazy var deleteTodoList : DeleteTodoListUseCase = DeleteTodoListUseCase()
    
    
}
