//
//  TodolistView.swift
//  MapETAAlarm
//
//  Created by Elvin Sestomi on 04/12/23.
//

import SwiftUI

struct TodoListView: View {
    @StateObject var viewModel = TodoListViewViewModel()
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.todolists) {
                        tdlist in
                        NavigationLink {
                            DetailTodoList(todoList: tdlist, viewModel: viewModel.detailTodoListViewModel)
                        } label: {
                            listCellView(todoList: tdlist)
                        }
                    }
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: FormView(viewModel: viewModel.formViewModel)) {
                        Text("+")
                            .font(.system(size: 30, weight: .bold))
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.showForm, destination: {
                FormView(viewModel: viewModel.formViewModel)
            })
            .onAppear {
                Task {
                    await viewModel.refreshTodoListStatus(moc : moc)
                    await viewModel.getTodoList(moc: moc)
                }
            }
        }
    }
}

#Preview {
    TodoListView()
}
