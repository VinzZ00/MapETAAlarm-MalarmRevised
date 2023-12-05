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
    
    @Binding var error : NSError?
    @Binding var selectedTransport : Int
    @Binding var tappedCoordinate : CLLocationCoordinate2D?
    @State var route : MKPolyline?;
    var canUpdate : Bool;
    
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
        context.coordinator.updateAnnotations(mapView: uiView, uCoordinate: locationService.lastLocation.coordinate , dCoordinate : tappedCoordinate)
        
        // MARK: update Route
        if let coordinate = tappedCoordinate {
            let userCoordinate = locationService.lastLocation.coordinate
            
            let request = MKDirections.Request()
            
            // MARK: Source Destination
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            
            // MARK: Transportation Type
            if selectedTransport == 0 {
                request.transportType = .walking
            } else {
                request.transportType = .automobile
            }
            
            // MARK: Direction Request
            let direction : MKDirections = MKDirections(request: request)
            
            direction.calculate { resp, err in
                if let err = err {
                    print("Error giving direction Calculation")
                    self.error = NSError(domain: "Direction gagal di kalkulasi", code: -100)
                }
                
                guard let route = resp?.routes.first else {
                    print("route tidak ditemukan Error")
                    self.error = NSError(domain: "Route tidak di temukan", code: -99)
                    return
                }
                
                let region : MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

                uiView.removeOverlays(uiView.overlays)
                uiView.addOverlay(route.polyline)
                uiView.setRegion(region, animated: true)
                
                
            }
        }
        
    }
    
    
}

