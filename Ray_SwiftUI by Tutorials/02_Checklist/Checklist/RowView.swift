//
//  RowView.swift
//  Checklist
//
//  Created by Михаил Дмитриев on 12.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import SwiftUI
//Вид для отображения каждой строки
struct RowView: View {
    @Binding var checklistItem: ChecklistItem
    
    var body: some View {
        //Строка и есть кнопка навигации на экран редиктирования c с передачей итема нажатия
        NavigationLink (destination: EditChecklistItemView(checklistItem: $checklistItem)) {
            HStack {
                Text(checklistItem.name)
                Spacer()
                Text(checklistItem.isChecked ? "✓" : "○")
            }
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(checklistItem: .constant(ChecklistItem(name: "Sample item")))
    }
}
