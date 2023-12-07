//
//  SearchPageViewModel.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import Foundation
import CoreLocation
import MapKit

class SearchPageViewModel : ObservableObject {
    @Published var searchCompleterObserver : SearchCompleterObserver = {
        let completer = MKLocalSearchCompleter()
        completer.resultTypes = .address
        
        var searchCompleterObserver = SearchCompleterObserver(completer: completer)
        
        return searchCompleterObserver
    }()
    
    var lastCoordinate : CLLocationCoordinate2D?
    
    @Published var locationService = LocationManager.shared
    @Published var error : NSError?
//    @Published var dLatitude : Double?
//    @Published var dlongitude : Double?
    @Published var locationName : String = "";
    @Published var tappedCoordinate : CLLocationCoordinate2D?
    @Published var selectedTransport : TransportationType = .Walking
    @Published var locRegion : MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 0))
}
