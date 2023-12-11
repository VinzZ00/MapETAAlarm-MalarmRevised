//
//  FormView.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import SwiftUI

struct FormView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var viewModel : FormViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var availableTransportation : [String] = ["Walking", "Auto Mobile"];
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    VStack(alignment: .leading) {
                        TextField("Input the Event Name ", text: $viewModel.eventName)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        (colorScheme == .dark) ? .white : .gray.opacity(0.6)
                                        , lineWidth: 1)
                            )
                            .padding(.bottom, 8)
                        
                        DatePicker(
                            "Select Time",
                            selection: $viewModel.selectedTime,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .padding(.bottom, 8)
                        
                        NavigationLink(destination: SearchPageView(viewModel: viewModel.searchPageViewModel)) {
                            TextField((viewModel.searchPageViewModel.locationName != "") ? viewModel.searchPageViewModel.locationName : "Search", text: $viewModel.searchPageViewModel.locationName)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            (colorScheme == .dark) ? .white : .gray.opacity(0.6)
                                            , lineWidth: 1)
                                )
                                .multilineTextAlignment(.leading)
                        }
                        
                            if viewModel.searchPageViewModel.tappedCoordinate != nil {
                            
                            GeometryReader { prox in
                                MapViewRepresentable(size: prox.size, userCoordinate: viewModel.locationService.lastLocation.coordinate, locationName : $viewModel.searchPageViewModel.locationName, error: $viewModel.error, selectedTransport: $viewModel.searchPageViewModel.selectedTransport, tappedCoordinate: $viewModel.searchPageViewModel.tappedCoordinate, canUpdate : false)
                                    .cornerRadius(10)
                                    .shadow(radius: 2, x: 2, y: 1)
                                    .padding(.bottom, 8)
                            }
                            .frame(height: 250)
                            .padding(.top, 8)
                            
                        }
                        
                        HStack{
                            Text("Want to go by?")
                            Spacer()
                            Picker("Transportation type", selection: $viewModel.searchPageViewModel.selectedTransport) {
                                
                                ForEach(availableTransportation, id : \.self) {
                                    trans in
                                    Text(trans)
                                        .tag(TransportationType(rawValue: trans)!)
                                }
                            }.pickerStyle(.menu)
                        }.padding(.bottom, 8)
                        
                        Text("Description")
                        TextEditor(text: $viewModel.eventDescription)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        (colorScheme == .dark) ? .white : .black,
                                        lineWidth: 1
                                    )
                            )
                            .frame(height: 150)
                    }
                }
                Spacer()
            }
            .navigationTitle("Form")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                        // TODO: create TodolistDTO and then save to coreData
                        guard let tappedCoordinate = viewModel.searchPageViewModel.tappedCoordinate else {
                            //TODO: Remove when the error has been handled
                            viewModel.error = NSError(domain: "no latitude and longitude found for destination", code: 96)
                            fatalError("Tapped Coordinate is not available")
                        }
                        
                        let todolist : TodoList = TodoList(dateTime: viewModel.selectedTime, eventDescription: viewModel.eventDescription, uLatitude: viewModel.locationService.lastLocation.coordinate.latitude, uLongitude: viewModel.locationService.lastLocation.coordinate.longitude, dLatitude: tappedCoordinate.latitude, dLongitude: tappedCoordinate.longitude, name: viewModel.eventName, status: "Incomplete", transportationType: (viewModel.searchPageViewModel.selectedTransport == .Walking) ? "Walking" : "Auto Mobile")
                        
                        viewModel.timeEstimationCalculation.getETA(source: viewModel.locationService.lastLocation.coordinate, destination: viewModel.searchPageViewModel.tappedCoordinate!, transporationType: viewModel.searchPageViewModel.selectedTransport) {
                            response, err in
                            if let error  = err {
                                print("Error calculate ETA, with Description : \(error.localizedDescription)")
                            }
                            
                            if let resp = response {
                                
                                let calendar : Calendar = Calendar.current
                                
                                let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: viewModel.selectedTime.addingTimeInterval(-resp.expectedTravelTime))
                                
                                
                                
                                viewModel.scheduleAlarm(coordinate: viewModel.searchPageViewModel.tappedCoordinate!, day: dateComponent.day!, month: dateComponent.month!, year: dateComponent.year!, hour: dateComponent.hour!, minute: dateComponent.minute!, title: viewModel.eventName, description: viewModel.eventDescription)
                                
                                print("alarm scheduled")
                            }
                        }
                        
                        Task {
                            await viewModel.saveToCoreData(todolist: todolist, moc: moc)
                        }
                        
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size : 16, weight: .regular))
                            .foregroundColor(Color.blue)
                        
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.locationService.startLocationUpdates()
            }
            .onDisappear {
                viewModel.locationService.stopLocationUpdates()
            }
        }
    }
}
