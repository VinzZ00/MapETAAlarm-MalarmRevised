//
//  CoreDataManager.swift
//  Nano2ElvinSestomiPersonal
//
//  Created by Elvin Sestomi on 20/05/23.
//

import Foundation
import CoreData

class CoreDataManager : ObservableObject {

    lazy var container : NSPersistentContainer = {
        var container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { _, err in
            if let err = err {
                fatalError("Error : Container tidak terload)");
            }
        }
        return container
    }()
    
}
