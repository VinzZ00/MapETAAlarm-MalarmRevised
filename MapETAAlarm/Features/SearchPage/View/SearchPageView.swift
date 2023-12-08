//
//  SearchPageView.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import SwiftUI
import MapKit


struct SearchPageView: View {
    @State var searchText: String = ""
    @ObservedObject var viewModel : SearchPageViewModel
    let geoCoder : CLGeocoder = CLGeocoder();
    
    @State var showMap : Bool = false;
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
                TextField((viewModel.locationName != "") ? viewModel.locationName : "Search" , text: $searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                (colorScheme == .dark) ? .white.opacity(0.6) : .gray.opacity(0)
                                , lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .onChange(of: searchText, perform: { value in
                        viewModel.searchCompleterObserver.completer.queryFragment = value
                    })
                if viewModel.searchCompleterObserver.completions.isEmpty {
                    HStack{
                        Spacer()
                        NavigationLink(destination: {
                            return GeometryReader { prox in
                                GeometryReader { prox in
                                    MapViewRepresentable(size: prox.size, userCoordinate: viewModel.locationService.lastLocation.coordinate, locationName: $viewModel.locationName, error: $viewModel.error, selectedTransport: $viewModel.selectedTransport, tappedCoordinate: $viewModel.tappedCoordinate, canUpdate: true)
                                        .navigationTitle("Map")
                                        .navigationBarTitleDisplayMode(.inline)
                                }
                            }
                        }()
                            .onAppear{
                                viewModel.lastCoordinate = viewModel.tappedCoordinate
                            }
                            .onDisappear{
                                if let lCoord = viewModel.lastCoordinate {
                                    if lCoord != viewModel.tappedCoordinate {
                                        dismiss()
                                    }
                                } else {
                                    if viewModel.tappedCoordinate != nil {
                                        dismiss()
                                    }
                                }
                            }
                        ) {
                            Text("Find It on map?")
                                .font(.system(size: 20))
                                .foregroundColor((colorScheme == .dark) ? .gray.opacity(0.6) : .black.opacity(0.6))
                                .padding()
                        }
                        Spacer()
                    }
                    
                    .background((colorScheme == .dark) ? .white.opacity(0.2) : .gray.opacity(0.2))
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                List(viewModel.searchCompleterObserver.completions, id: \.self) { completion in
                    Text(completion.title)
                        .onTapGesture {
                            // Handle selection of autocomplete result
                            // You can access the coordinate using completion.coordinate
                            
                            searchText = completion.title
                            viewModel.locationName = searchText
                            
                            viewModel.locationName = searchText
                            geoCoder.geocodeAddressString(viewModel.locationName) { (placemarks, error) in
                                if let error = error {
                                    print("Geocoding error: \(error.localizedDescription)")
                                    return
                                }
                                
                                guard let placemark = placemarks?.first else {
                                    print("No coordinates found for the place name.")
                                    return
                                }
                                
                                if let coordinate = placemark.location?.coordinate {
                                    viewModel.locRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
                                    
                                    viewModel.tappedCoordinate = coordinate;
                                    
                                    print(coordinate)
                                    
                                    dismiss()
                                }
                                
                            }
                            
                            
                        }
                }
                
                Spacer()
                
            }
            .navigationTitle("Search Page")
            .padding(.vertical)
        }
    }
}



