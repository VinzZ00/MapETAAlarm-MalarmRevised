//
//  DetailTodoListView.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 07/12/23.
//

import SwiftUI
import CoreLocation

struct DetailTodoList: View {
    
    var todoList : TodoList
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel : DetailTodoListViewModel
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack(alignment: .center){
                        
                        Spacer()
                        
                        
                    }.padding(.bottom, 8)
                    
                    DatePicker(
                        "Selected Time",
                        selection: .constant(todoList.dateTime!),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .disabled(true)
                    .padding(.bottom, 8)
                    
                    GeometryReader { prox in
                        MapViewRepresentable(size: prox.size, userCoordinate: CLLocationCoordinate2D(latitude: todoList.uLatitude!, longitude: todoList.uLongitude!), locationName: .constant(""), error: $viewModel.MapKitError, selectedTransport: .constant(TransportationType(rawValue: todoList.transportationType!)!), tappedCoordinate: .constant(CLLocationCoordinate2D(latitude: todoList.dLatitude!, longitude: todoList.dLongitude!)), canUpdate: false)
                            .cornerRadius(10)
                            .shadow(radius: 2, x: 2, y: 1)
                            .padding(.bottom, 8)
                    }
                    .frame(height: 250)
                        
                    
                    HStack{
                        Text("Want to go by?")
                        Spacer()
                        if let transport = todoList.transportationType {
                            Text("\(transport)")
                                .foregroundColor(.blue)
                        }
                    }.padding(.bottom, 16)
                        .foregroundColor((colorScheme == .dark) ? .white : .black)
                    
                    Text("Description")
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Text(todoList.eventDescription!)
                                .lineLimit(nil)
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            Spacer()
                        }
                        Spacer()
                    }
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    (colorScheme == .dark) ? .white : .black,
                                    lineWidth: 1
                                )
                        )
                        .padding(.bottom, 16)
                    
                    
                    Text("Estimated Travel time to the destination : \(viewModel.estimatedTime) minutes")
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.deleteTodoList.call(moc: moc, todolist: todoList)
                            } catch {
                                // TODO: Handle the error Later
                                fatalError("Error deleting todolist")
                            }
                            dismiss()
                        }
                    } label: {
                        HStack{
                            Text("Delete The Todo List?")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Spacer()
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.black)
                                .frame(width: 25, height: 25)
                        }
                        .padding()
                        .frame(height: 75)
                        .background(.red)
                        .cornerRadius(20)
                        
                    }
                }
                .padding()
                .onAppear {
                    viewModel.timeEstimationCalculation.getETA(source: CLLocationCoordinate2D(latitude: todoList.uLatitude!, longitude: todoList.uLongitude!), destination: CLLocationCoordinate2D(latitude: todoList.dLatitude!, longitude: todoList.dLongitude!), transporationType: TransportationType(rawValue: todoList.transportationType!)!) {
                        response, err in
                        if err != nil {
                            // TODO: Handle Error
                            fatalError("Error calculate ETA erro : \(err?.localizedDescription)")
                        }
                        
                        var minutes : Int = 0
                        if let resp = response {
                            minutes = Int(resp.expectedTravelTime / 60)
                        }
                        viewModel.estimatedTime = minutes;
                    }
                }
            }.navigationTitle(Text("\(todoList.name!.isEmpty ? "No Name" : todoList.name!)"))
        }
    }
}

