//
//  MapView.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import SwiftUI
import MapKit



struct MapViewRepresentable : UIViewRepresentable {
    
    
    class Coordinator : NSObject, MKMapViewDelegate{
        
        var userAnnotation : MKPointAnnotation?
        var destinationCoordinate : MKPointAnnotation?
        
        func updateAnnotations(mapView : MKMapView, uCoordinate : CLLocationCoordinate2D, dCoordinate : CLLocationCoordinate2D?) {
            
            // MARK: User Annotation
            if let userAnnotation =  userAnnotation {
                userAnnotation.coordinate = uCoordinate
            } else {
                let newUserAnnotation  = MKPointAnnotation()
                newUserAnnotation.coordinate = uCoordinate
                mapView.addAnnotation(newUserAnnotation)
                userAnnotation = newUserAnnotation;
            }
            
            // MARK: Destination Annotation
            if let coordinate = dCoordinate {
                if let existingAnnotation = destinationCoordinate {
                    existingAnnotation.coordinate = coordinate
                } else {
                    let newAnnotation = MKPointAnnotation()
                    newAnnotation.coordinate = coordinate
                    mapView.addAnnotation(newAnnotation)
                    destinationCoordinate = newAnnotation
                }
            } else {
                if let existingAnnotation = destinationCoordinate {
                    mapView.removeAnnotation(existingAnnotation)
                    destinationCoordinate = nil
                }
            }
            
        }
        
        
    }
    
    typealias UIViewType = MKMapView
    
    var size : CGSize
    var locationService = CoreLocationHandler.shared
    
    @Binding var tappedCoordinate : CLLocationCoordinate2D
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> UIViewType {
        var mkMapview = MKMapView()
        mkMapview.frame = CGRect(origin: CGPointZero, size: size)
        return mkMapview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.frame = CGRect(origin: CGPointZero, size: size)
        
        // MARK: update annotation
        context.coordinator.updateAnnotations(mapView: uiView, uCoordinate: tappedCoordinate , dCoordinate : locationService.lastLocation.coordinate)
        
        // MARK: update tappedCoordinate
        
    }
    
    
}

