//
//  Nano2ElvinSestomiPersonalApp.swift
//  Nano2ElvinSestomiPersonal
//
//  Created by Elvin Sestomi on 19/05/23.
//

import SwiftUI

@main
struct MapETAAlarmApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var coreDataManager : CoreDataManager = CoreDataManager();
    
    var body: some Scene {
        WindowGroup {
//            ToDoListView()
//                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
