//
//  Checklist.swift
//  Checklist
//
//  Created by Михаил Дмитриев on 09.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import Foundation

class Checklist: ObservableObject {
//MARK: - PROPERTIES
    @Published var items: [ChecklistItem] = []
    
    
    //MARK: - FUNCTIONS
    func printChecklistContents() {
        for item in items {
          print(item)
        }
    }
    
    func deleteListItem(whichElement: IndexSet) {
        items.remove(atOffsets: whichElement)
        printChecklistContents()
        saveListItems()
    }
    
    func moveListItem(whichElement: IndexSet, destination: Int) {
        items.move(fromOffsets: whichElement, toOffset: destination)
        printChecklistContents()
        saveListItems()
    }
    
    //Возвращает дирректорию приложения
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    //Сохранение списка
    func saveListItems() {
        // 1
        let encoder = PropertyListEncoder()
        // 2
        do {
            // 3
            let data = try encoder.encode(items)
            // 4
            try data.write(to: dataFilePath(),options: Data.WritingOptions.atomic)
            // 5
        } catch {
            // 6
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    //Загрузка из списка
    func loadListItems() {
        // 1
        let path = dataFilePath()
        // 2
        if let data = try? Data(contentsOf: path) {
            // 3
            let decoder = PropertyListDecoder()
            do {
                // 4
                items = try decoder.decode([ChecklistItem].self, from: data)
            // 5
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }            
        }
    }
    
    //Инициализатор по умолчанию
    init() {
        print("Documents directory is: \(documentsDirectory())")
        print("Data file path is: \(dataFilePath())")
        //Загружаем список
        loadListItems()
    }
    
    
    
}
