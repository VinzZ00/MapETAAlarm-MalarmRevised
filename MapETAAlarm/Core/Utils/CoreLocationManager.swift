//
//  CoreLocationManagerr.swift
//  MAlarm
//
//  Created by Elvin Sestomi on 26/11/23.
//
import os
import Foundation
import CoreLocation

@MainActor class CoreLocationHandler : ObservableObject {
    var logger :  Logger = Logger(subsystem: "com.AA.ETAMapAlarm", category: "CoreLocationHandler.swift")
    
    static let shared = CoreLocationHandler()
    let manager : CLLocationManager
    var backgroundActivity : CLBackgroundActivitySession?
    
    @Published var updatesStarted : Bool = false
    @Published var lastLocation : CLLocation = CLLocation()
    @Published var isBackgroundActRunning = UserDefaults.standard.bool(forKey: "BGActStarted") {
        didSet {
            isBackgroundActRunning ? self.backgroundActivity = CLBackgroundActivitySession() : self.backgroundActivity?.invalidate()
            UserDefaults.standard.set(backgroundActivity, forKey: "BGActStarted")
        }
    }
    
    init() {
        self.manager = CLLocationManager();
    }
    
    func startLocationUpdates() {
        if self.manager.authorizationStatus == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
        }
        
        Task {
            do {
                self.updatesStarted = true
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if !self.updatesStarted { break }  // End location updates by breaking out of the loop.
                    if let loc = update.location {
                        self.lastLocation = loc;
                    }
                }
            } catch {
                self.logger.error("Could not start location updates")
            }
        }
    }
    
    func stopLocationUpdates() {
        self.logger.info("Stopping location updates")
        self.updatesStarted = false
    }
}
