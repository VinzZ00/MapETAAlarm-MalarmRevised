//
//  CLLocation2D+Equitable.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 06/12/23.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D : Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude)
    }
    
    
}
