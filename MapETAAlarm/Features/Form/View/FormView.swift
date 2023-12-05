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
    
    var availableTransportation : [String] = ["Walking", "Car"];
    
    var body: some View {
        if (viewModel.searchPageViewModel.searchPage) {
            VStack{
                SearchPageView()
                    .transition(.slide)
//                    .environmentObject(appViewModel)//                    .environmentObject(appViewModel)
            }
        } else {
            VStack {
                HStack(alignment: .center){
                    Text("Fill your to do list form")
                        .font(.system(size : 20, weight: .bold))
                        .foregroundColor(
                            (colorScheme == .dark) ? .white : .black
                        )
                    
                    Spacer()
                    
                    Button {
                        
                        // TODO: create TodolistDTO and then save to coreData
                        
                        guard let dlat = viewModel.searchPageViewModel.dLatitude,
                              let dlong = viewModel.searchPageViewModel.dlongitude
                        else { 
                            viewModel.error = NSError(domain: "no latitude and longitude found for destination", code: 96)
                            //TODO: Remove when the error has been handled
                            fatalError("Latitude and longitude not found")
                            
                            
                        }
                        
                        let todolist : TodoListDTO = TodoListDTO(dateTime: viewModel.selectedTime, eventDescription: viewModel.eventDescription, uLatitude: viewModel.locationManager.lastLocation.coordinate.latitude, uLongitude: viewModel.locationManager.lastLocation.coordinate.longitude, dLatitude: dlat, dLongitude: dlong, name: viewModel.eventName, status: "Incomplete", transportationType: (viewModel.searchPageViewModel.selectedTransport == 0) ? "Walking" : "Car")

                        
                        
                        viewModel.getETA(source: viewModel.locationManager.lastLocation.coordinate, destination: viewModel.searchPageViewModel.tappedCoordinate!) {
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
                        
//                        withAnimation {
//                            viewModel.showForm = false;
//                        }
                    } label: {
                        Text("Done")
                            .font(.system(size : 16, weight: .regular))
                            .foregroundColor(Color(hue: 0.653, saturation: 0.89, brightness: 1.0))
                        
                    }
                }.padding(.bottom, 16)
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading) {
                        TextField("Input the Event Name ", text: $viewModel.eventName)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        (colorScheme == .dark) ? .white : .white.opacity(0)
                                        , lineWidth: 1)
                            )
                            .padding(.bottom, 8)
                        
                        DatePicker(
                            "Select Time",
                            selection: $viewModel.selectedTime,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .padding(.bottom, 8)
                        
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
                            .onTapGesture {
                                withAnimation {
                                    viewModel.searchPageViewModel.searchPage = true
                                }
                            }
                        
                        if let locCoordinate = viewModel.searchPageViewModel.tappedCoordinate {
                            
                            GeometryReader { prox in
                                MapViewRepresentable(size: prox.size, error: $viewModel.error, selectedTransport: $viewModel.searchPageViewModel.selectedTransport, tappedCoordinate: $viewModel.searchPageViewModel.tappedCoordinate, canUpdate : false)
                                    .cornerRadius(10)
                                    .shadow(radius: 2, x: 2, y: 1)
                                    .padding(.bottom, 8)
                            }
                            
                        }
                        
                        HStack{
                            Text("Want to go by?")
                            Spacer()
                            Picker("Transportation type", selection: $viewModel.searchPageViewModel.selectedTransport) {
                                ForEach(0..<availableTransportation.count, id : \.self) {
                                    idx in
                                    Text(availableTransportation[idx]).tag(idx)
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
            .padding()

            
        }
    }
}
