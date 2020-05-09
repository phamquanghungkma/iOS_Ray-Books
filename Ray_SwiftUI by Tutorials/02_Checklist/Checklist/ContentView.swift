//
//  ContentView.swift
//  Checklist
//
//  Created by Михаил Дмитриев on 09.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import SwiftUI

//MARK: - MODELS
//Модель задач. Подписан под протокол для уникального ID
struct ChecklistItem : Identifiable {
    //Уникальое ID для обьектов. Не отображается при создании
    let id = UUID()
    var name: String
    var isChecked: Bool = false
}


struct ChecklistView: View {
//MARK: - PROPERTIES
    @State var checklistItems = [
        ChecklistItem(name: "Walk the dog"),
        ChecklistItem(name: "Brush my teeth"),
        ChecklistItem(name: "Learn iOS development", isChecked: true),
        ChecklistItem(name: "Soccer practice"),
        ChecklistItem(name: "Eat ice cream", isChecked: true),
    ]
        
//MARK: - USER INTERFACE
    var body: some View {
        NavigationView {
            List {
                //Так как обьекты подписаны под Identifiable - id не нужен
                ForEach(checklistItems) { checklistItem in
                    HStack {
                        Text(checklistItem.name)
                        Spacer()
                        Text(checklistItem.isChecked ? "+++" : "---")
                    }
                    // This makes the entire row clickable
                    .background(Color.white)
                    .onTapGesture {
                        //Изменяем готовность задачи по тапу
                        if let matchingIndex = self.checklistItems.firstIndex(where: {
                            $0.id == checklistItem.id }) {
                            self.checklistItems[matchingIndex].isChecked.toggle()
                        }
                    }
                    
                }
                .onDelete(perform: deleteListItem)
                .onMove(perform: moveListItem)
            }
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitle("CheckList")
            .onAppear() {
                self.printChecklistContents()
            }
        }
    }
    
    
//MARK: - FUNCTIONS
    func printChecklistContents() {
        for item in checklistItems {
          print(item)
        }
    }
    
    func deleteListItem(whichElement: IndexSet) {
        checklistItems.remove(atOffsets: whichElement)
        printChecklistContents()
    }
    
    func moveListItem(whichElement: IndexSet, destination: Int) {
        checklistItems.move(fromOffsets: whichElement, toOffset: destination)
        printChecklistContents()
    }
    
   
    
}
//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}
