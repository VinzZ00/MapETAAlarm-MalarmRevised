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
                        listCellView(todoList: tdlist)
                    }
                }
            }.onAppear {
                Task {
                    await viewModel.getTodoList(moc: moc)
                }
            }
        }
    }
}

#Preview {
    TodoListView()
}
