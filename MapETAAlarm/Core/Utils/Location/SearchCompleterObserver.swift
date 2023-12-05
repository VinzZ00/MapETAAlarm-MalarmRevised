//
//  SearchCompleterObserver.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 05/12/23.
//

import Foundation
import MapKit
import SwiftUI

class SearchCompleterObserver: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    var completer: MKLocalSearchCompleter
    
    @Published var completions: [MKLocalSearchCompletion] = []
    
    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Handle error
        print("Autocomplete error: \(error.localizedDescription)")
    }
}
