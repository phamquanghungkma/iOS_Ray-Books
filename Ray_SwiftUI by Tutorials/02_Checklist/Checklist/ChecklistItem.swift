//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Михаил Дмитриев on 09.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import Foundation

//Модель задач. Подписан под протокол для уникального ID
struct ChecklistItem : Identifiable, Codable {
    // Properties
    // ==========
    //Уникальое ID для обьектов. Не отображается при создании
    let id = UUID()
    var name: String
    var isChecked: Bool = false
}
