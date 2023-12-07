//
//  ReverseGeocoding.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 07/12/23.
//

import Foundation
import CoreLocation

class Reversegeocoding {
    
    static let shared = Reversegeocoding()
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D, completion : @escaping (CLPlacemark) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) {
            placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                // Handle error
                print("No PlaceMark For that Coordinate.")
                return
            }
            completion(placemark)
            
            
        }
    }
}
