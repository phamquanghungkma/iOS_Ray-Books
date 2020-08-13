//
//  CoreDataStack.swift
//  DogWalk
//
//  Created by Михаил Дмитриев on 13.08.2020.
//  Copyright © 2020 Razeware. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  private let modelName: String
  
  lazy var managedContext: NSManagedObjectContext = {
    return self.storeContainer.viewContext
  }()
  
  init(modelName: String) {
    self.modelName = modelName
  }
  
  private lazy var storeContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        print("Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  
  func saveContext() {
    guard managedContext.hasChanges else { return }
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Unresolved error \(error), \(error.userInfo)")
    }
  }
}
