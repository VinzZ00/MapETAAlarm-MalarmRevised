//
//  TimeEstimationRequest.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 07/12/23.
//

import Foundation
import MapKit

class TimeEstimationRequest {
    static let shared = TimeEstimationRequest()
    func getETA(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, transporationType : TransportationType, completion: @escaping (MKDirections.ETAResponse?, Error?) -> Void) {
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)

        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = transporationType != .Walking ? .automobile : .walking

        let directions = MKDirections(request: request)
        directions.calculateETA { (response, error) in
            completion(response, error)
        }
    }
    
}
