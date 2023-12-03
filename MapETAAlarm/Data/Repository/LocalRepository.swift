//
//  MapKitServerRepository.swift
//  ETAMapAlarm
//
//  Created by Elvin Sestomi on 03/12/23.
//

import Foundation
import os

class LocalRepository {
    let logger : Logger = Logger(subsystem: "com.AA.ETAMapAlarm", category: "MapKitServerRepository")
    let CoreData = CoreDataDataSource()
}
