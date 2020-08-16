//
//  UserEditAlert.swift
//  MyToDo
//
//  Created by Михаил Дмитриев on 16.08.2020.
//  Copyright © 2020 Ray Wenderlich. All rights reserved.
//

import UIKit

func userEditAlert(item: ToDoItem, callback: @escaping (String) -> Void) {
  let alert = UIAlertController(title: "Edit Task",
                                message: nil,
                                preferredStyle: .alert)
  
  alert.addTextField(configurationHandler: { field in
    field.text = item.text
  })
  
  alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
    guard
      let text = alert.textFields?.first?.text,
      !text.isEmpty else { return }
    callback(text)
  })
  
  alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
    alert.dismiss(animated: true, completion: nil)
  }))
  
  let root = UIApplication.shared.keyWindow?.rootViewController
  root?.present(alert, animated: true, completion: nil)
}
