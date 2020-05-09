//
//  ContentView.swift
//  Checklist
//
//  Created by Михаил Дмитриев on 09.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import SwiftUI

struct ChecklistView: View {
//MARK: - PROPERTIES
    @ObservedObject var checklist = Checklist()
    @State var newChecklistItemViewIsVisible = false
    

        
//MARK: - USER INTERFACE
    var body: some View {
        NavigationView {
            List {
                //Так как обьекты подписаны под Identifiable - id не нужен
                ForEach(checklist.items) { index in
                    RowView(checklistItem: self.$checklist.items[index])                    
                }
                .onDelete(perform: checklist.deleteListItem)
                .onMove(perform: checklist.moveListItem)
            }
            //Кнопки NavigationView
            .navigationBarItems(
                leading: Button(action: { self.newChecklistItemViewIsVisible = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add item")
                    }
                },
                trailing: EditButton())
            .navigationBarTitle("CheckList", displayMode: .inline)
            .onAppear() {
                self.checklist.printChecklistContents()
                self.checklist.saveListItems()
            }
        }
        //Отображаем экран создания заметки
        .sheet(isPresented: $newChecklistItemViewIsVisible) {
            //При создании обьекта мы передаем в него ссылку на checklist
            NewChecklistItemView(checklist: self.checklist)
        }
    }   
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}
