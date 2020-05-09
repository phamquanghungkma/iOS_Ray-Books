//
//  EditChecklistItemView.swift
//  Checklist
//
//  Created by Михаил Дмитриев on 09.04.2020.
//  Copyright © 2020 Mikhail Dmitriev. All rights reserved.
//

import SwiftUI

struct EditChecklistItemView: View {
//MARK: - PROPERTIES
    @Binding var checklistItem: ChecklistItem
 
    
//MARK: - USER INTERFACE
    var body: some View {
        Form {
            TextField("Name", text: $checklistItem.name)
            Toggle("Completed", isOn: $checklistItem.isChecked)
        }
    }
}


//MARK: - PREVIEW
struct EditChecklistItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditChecklistItemView(checklistItem: .constant(ChecklistItem(name: "Sample item")))
    }
}
