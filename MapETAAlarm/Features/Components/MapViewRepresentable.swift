//
//  MapView.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import SwiftUI
import MapKit


struct MapViewRepresentable : UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    var size : CGSize
//    var locationService = LocationManager.shared
    
    var userCoordinate : CLLocationCoordinate2D
    @Binding var locationName : String
    @Binding var error : NSError?
    @Binding var selectedTransport : TransportationType
    @Binding var tappedCoordinate : CLLocationCoordinate2D?
    @State var route : MKPolyline?
    @Environment(\.dismiss) private var dismiss
    
    var canUpdate : Bool
    
    func makeUIView(context: Context) -> UIViewType {
        let mkMapview = MKMapView()
        
        mkMapview.delegate = context.coordinator
        mkMapview.frame = CGRect(origin: CGPointZero, size: size)
        
        if canUpdate {
            mkMapview.userTrackingMode = .followWithHeading
            
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            mkMapview.addGestureRecognizer(tapGesture)
        }
        
        return mkMapview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.frame = CGRect(origin: CGPointZero, size: size)
        
        // MARK: update annotation
        context.coordinator.updateAnnotations(mapView: uiView, uCoordinate: userCoordinate , dCoordinate : tappedCoordinate)
        
        // MARK: update Route
        if let coordinate = tappedCoordinate {
//            locationService.startLocationUpdates()
            let userCoordinate = userCoordinate
            
            let request = MKDirections.Request()
            
            // MARK: Source Destination
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
            
            // MARK: Transportation Type
            if selectedTransport == .Walking {
                request.transportType = .walking
            } else {
                request.transportType = .automobile
            }
            
            // MARK: Direction Request
            let direction : MKDirections = MKDirections(request: request)
            
            direction.calculate { resp, err in
                if err != nil {
                    print("Error giving direction Calculation with Err  : \(err!.localizedDescription)")
                    self.error = NSError(domain: "Direction gagal di kalkulasi", code: -100)
                }
                
                guard let route = resp?.routes.first else {
                    print("route tidak ditemukan Error")
                    self.error = NSError(domain: "Route tidak di temukan", code: -99)
                    return
                }
                
//                let region : MKCoordinateRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                
                uiView.removeOverlays(uiView.overlays)
                uiView.addOverlay(route.polyline)
//                uiView.setRegion(region, animated: true)
                
                
            }
        }
        if tappedCoordinate != nil {
            zoomToFit(mapView: uiView, coordinates: [userCoordinate, self.tappedCoordinate!])
        } else {
            zoomToFit(mapView: uiView, coordinates: [userCoordinate])
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator : NSObject, MKMapViewDelegate{
        
        init(_ parent : MapViewRepresentable) {
            self.parent = parent
        }
        var reverseGeocoding = Reversegeocoding.shared
        var parent : MapViewRepresentable
        
        var userAnnotation : MKPointAnnotation?
        var destinationCoordinate : MKPointAnnotation?
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        
        func updateAnnotations(mapView : MKMapView, uCoordinate : CLLocationCoordinate2D, dCoordinate : CLLocationCoordinate2D?) {
            
            // MARK: User Annotation
            if !parent.canUpdate {
                if let userAnnotation =  userAnnotation {
                    userAnnotation.coordinate = uCoordinate
                } else {
                    let newUserAnnotation  = MKPointAnnotation()
                    newUserAnnotation.coordinate = uCoordinate
                    mapView.addAnnotation(newUserAnnotation)
                    userAnnotation = newUserAnnotation;
                }
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
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let mapView = gesture.view as! MKMapView
            let tapPoint = gesture.location(in: mapView)
            let tapCoordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            parent.tappedCoordinate = tapCoordinate
            reverseGeocoding.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: tapCoordinate.latitude, longitude: tapCoordinate.longitude)) { [weak self] placemark in
                
//              Retrieve location name
                if self != nil {
                    if let name = placemark.name, let locality = placemark.locality {
                        self!.parent.locationName = "\(name), \(locality)"
                    } else if let locality = placemark.locality {
                        self!.parent.locationName = locality
                    } else {
                        self!.parent.locationName = "Unknown"
                    }
                } else {
//                  TODO: Handling error
                    fatalError("Self is nill")
                }
                
            }
            
            
            
            withAnimation {
                if parent.canUpdate {
                    parent.dismiss()
                }
            }
        }
    }
    
    func zoomToFit(mapView : UIViewType, coordinates: [CLLocationCoordinate2D]) {
        var minLat: CLLocationDegrees = 90
        var maxLat: CLLocationDegrees = -90
        var minLon: CLLocationDegrees = 180
        var maxLon: CLLocationDegrees = -180
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.4, longitudeDelta: (maxLon - minLon) * 1.4)
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}

