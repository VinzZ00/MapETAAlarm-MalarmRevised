//
//  MapKitRepresentableUI.swift
//  Nano2ElvinSestomiPersonal
//
//  Created by Elvin Sestomi on 19/05/23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var canUpdate : Bool
    @EnvironmentObject var appViewModel : AppViewModel
    @State var route : MKPolyline?;
    
    init(canUpdate : Bool = true) {
        self.canUpdate = canUpdate;
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator;
        
        if canUpdate {
            let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
            mapView.addGestureRecognizer(tapGesture)
        }
        
        
        
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        
        context.coordinator.updateAnnotation(mapView: mapView, coordinate: appViewModel.tappedCoordinate, userCoordinate : appViewModel.locationManager.region.center)
        
        
        if let tappedCoordinate = appViewModel.tappedCoordinate {
            print("Masuk tapped coordinate didapatkan")
            print("Tapped coordinate : \(appViewModel.tappedCoordinate)")
            let userCoordinate = appViewModel.locationManager.region.center
            
            let request = MKDirections.Request()
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: tappedCoordinate))
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
            if appViewModel.selectedTransport == 0 {
                request.transportType = .walking
            } else {
                request.transportType = .automobile
            }
            
            let direction : MKDirections = MKDirections(request: request)
            direction.calculate{ response, error in
                print("Masuk ke direction Calculation")
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                guard let route = response?.routes.first else {
                    print("route tidak ditemukan Error")
                    return }
                
                print("Route Di temukan")
                
                var region : MKCoordinateRegion = MKCoordinateRegion(center: tappedCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                
                mapView.removeOverlays(mapView.overlays)
                mapView.addOverlay(route.polyline)
                mapView.setRegion(region, animated: true)
            }
        }
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(tappedCoordinate: $appViewModel.tappedCoordinate, locationName: $appViewModel.locationName, searchPageIsShown: $appViewModel.searchPage)
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var tappedCoordinate: CLLocationCoordinate2D?
        private var annotation: MKPointAnnotation?
        private var userAnnotation : MKPointAnnotation?
        @Binding var locationName : String;
        @Binding var searchPageIsShown : Bool;
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        
        
        func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    // Handle error
                    print("No PlaceMark For that Coordinate.")
                    return
                }
                
                // Retrieve location name
                if let name = placemark.name, let locality = placemark.locality {
                    self.locationName = "\(name), \(locality)"
                    print(self.locationName)
                } else if let locality = placemark.locality {
                    self.locationName = locality
                    print(self.locationName)
                } else {
                    self.locationName = "Unknown"
                    print(self.locationName)
                }
            }
            print("Return locationname", self.locationName)
        }
        
        
        init(tappedCoordinate: Binding<CLLocationCoordinate2D?>, locationName : Binding<String>, searchPageIsShown :Binding< Bool>) {
            _tappedCoordinate = tappedCoordinate
            _locationName = locationName
            _searchPageIsShown = searchPageIsShown
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let mapView = gesture.view as! MKMapView
            let tapPoint = gesture.location(in: mapView)
            let tapCoordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            tappedCoordinate = tapCoordinate
            reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: tapCoordinate.latitude, longitude: tapCoordinate.longitude))
            
            withAnimation {
                searchPageIsShown = false;
            }
            
            
        }
        
        func updateAnnotation(mapView: MKMapView, coordinate: CLLocationCoordinate2D?, userCoordinate : CLLocationCoordinate2D) {
            
            if let userAnnotation =  userAnnotation {
                userAnnotation.coordinate = userCoordinate
            } else {
                let newUserAnnotation  = MKPointAnnotation()
                newUserAnnotation.coordinate = userCoordinate
                mapView.addAnnotation(newUserAnnotation)
                userAnnotation = newUserAnnotation;
            }
            
            
            if let coordinate = coordinate {
                if let existingAnnotation = annotation {
                    existingAnnotation.coordinate = coordinate
                } else {
                    let newAnnotation = MKPointAnnotation()
                    newAnnotation.coordinate = coordinate
                    mapView.addAnnotation(newAnnotation)
                    annotation = newAnnotation
                }
            } else {
                if let existingAnnotation = annotation {
                    mapView.removeAnnotation(existingAnnotation)
                    annotation = nil
                }
            }
        }
    }
}

