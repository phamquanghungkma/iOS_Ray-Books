//
//  NewChecklistItemView.swift
//  Checklist
//
//  Created by Михаил Дмитриев on 10.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import SwiftUI

struct NewChecklistItemView: View {
//MARK: - PROPERTIES
    //Переменная текста поля ввода
    @State var newItemName = ""
    //Свойство наблюдения состояния отображения
    @Environment(\.presentationMode) var presentationMode
    //Свойство обьекта класса Checklist
    var checklist: Checklist
    
    
//MARK: - USER INTERFACE
    var body: some View {
        VStack {
            Text("Add new item")
            
            //Форма ввода текста
            Form {
                TextField("Enter item name", text: $newItemName)
                //Кнопка добавления дового обьекта
                Button(action: {
                    let newChecklistItem = ChecklistItem(name: self.newItemName)
                    self.checklist.items.append(newChecklistItem)
                    self.checklist.printChecklistContents()
                    //Сохраняем список
                    self.checklist.saveListItems()
                    //Сворачиваем View когда добавляем новый Item
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add new item")
                    }
                }
                //Отключаем кнопку, если нет ввода
                .disabled(newItemName.count == 0)
            }
            
            Text("Swipe down to cancel.")            
        }
    }
}


//MARK: - PREVIEW
struct NewChecklistItemView_Previews: PreviewProvider {
    static var previews: some View {
        //NewChecklistItemView has information that it didn’t have before:
        //It now has access to the checklist data
        //При создании обьекта в него нужно будет передать ссылку на обьект класса Checklist
        NewChecklistItemView(checklist: Checklist())
    }
}
