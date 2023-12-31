//
//  listComponent.swift
//  Nano2ElvinSestomiPersonal
//
//  Created by Elvin Sestomi on 20/05/23.
//

import SwiftUI

struct listCellView: View {
    
    var todoList : TodoList;
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0){
            
            HStack{
                if let date = todoList.dateTime {
                    Text(date.formatted(date: .complete, time: .omitted))
                        .font(.system(size: 16, weight: .light, design: .rounded))
                        .foregroundStyle(
                            (colorScheme == .dark) ? .white : .black
                        )
                }
                Spacer()
                if let status = todoList.status {
                    Text(status)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor((status == "Incomplete") ? .red : .green)
                }
            }.padding(.top, 8)
                .padding(.trailing, 8)
            
            Spacer()
            HStack {
                if let date = todoList.dateTime {
                    Text(date.formatted(date : .omitted, time: .shortened))
                        .font(.system(size: 50, weight: .light, design: .rounded))
                        .foregroundStyle(
                            (colorScheme == .dark) ? .white : .black
                        )
                }
                
                Spacer()
                
                if let name =  todoList.name {
                    Text(name)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .frame(width: 120)
                        .foregroundStyle(
                            (colorScheme == .dark) ? .white : .black
                        )
                }
            }
            .padding(.trailing, 8)
            .padding(.top, 5)
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor((colorScheme == .dark
                                 ) ? .white.opacity(0.6) : .gray.opacity(0.6))
            
        }.frame(width: 345, height: 81)
            .padding()
    }
}
