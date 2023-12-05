//
//  SearchPageView.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import SwiftUI
import MapKit
import Combine

struct SearchPageView: View {
    @State var searchText: String = ""
//    @ObservedObject var searchCompleterObserver: SearchCompleterObserver
//    @EnvironmentObject var appViewModel : AppViewModel
    
    @ObservedObject var viewModel : SearchPageViewModel
    let geoCoder : CLGeocoder = CLGeocoder();
    
    @State var showMap : Bool = false;
    @Environment(\.colorScheme) var colorScheme
    
//    init() {
//        let completer = MKLocalSearchCompleter()
//        completer.resultTypes = .address
//        searchCompleterObserver = SearchCompleterObserver(completer: completer)
//    }
    
    var body: some View {
        if showMap {
            GeometryReader(content: { prox in
                MapViewRepresentable(size: prox.size, error: $viewModel.error, selectedTransport: $viewModel.selectedTransport, tappedCoordinate: $viewModel.tappedCoordinate, canUpdate: true)
                    .transition(.slide)
            })
        } else {
            NavigationView{
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
                        Button{
                            withAnimation {
                                showMap = true
                            }
                        } label: {
                            HStack{
                                Spacer()
                                Text("Find It on map?")
                                    .font(.system(size: 20))
                                    .foregroundColor((colorScheme == .dark) ? .gray.opacity(0.6) : .black.opacity(0.6))
                                    .padding()
                                Spacer()
                            }
                            .background((colorScheme == .dark) ? .white.opacity(0.2) : .gray.opacity(0.2))
                            .cornerRadius(20)
                        }.padding()
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
                                    }
                                }
                                withAnimation {
                                    viewModel.searchPage = false;
                                }
                            }
                    }
                }.padding(.vertical)
                    .navigationBarItems(leading:
                                            Button{
                        withAnimation {
                            viewModel.searchPage = false;
                        }
                    } label : {
                        Text("Back")
                    }
                    )
                    .navigationTitle("Search Page")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}



