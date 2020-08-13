/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import CoreData

class ViewController: UIViewController {

  // MARK: - Properties
  lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
  }()
  
  //New Core Data Stack
  lazy var coreDataStack = CoreDataStack(modelName: "DogWalk")

  //var walks: [Date] = []
  var currentDog: Dog?

  // MARK: - IBOutlets
  @IBOutlet var tableView: UITableView!


  // MARK: - View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    let dogName = "Fido"
    let dogFetch: NSFetchRequest<Dog> = Dog.fetchRequest()
    dogFetch.predicate = NSPredicate(format: "%K == %@",
                                     argumentArray: [#keyPath(Dog.name), dogName])
    
    do {
      let results = try coreDataStack.managedContext.fetch(dogFetch)
      if results.count > 0 {
        //Fido found, use Fido
        currentDog = results.first
      } else {
        //Fido not found, create Fido
        currentDog = Dog(context: coreDataStack.managedContext)
        currentDog?.name = dogName
        coreDataStack.saveContext()
      }
    } catch let error as NSError {
      print("Fetch error: \(error) description: \(error.userInfo)")
    }
    
  }
}

// MARK: - IBActions
extension ViewController {

  @IBAction func add(_ sender: UIBarButtonItem) {
    
    //Insert a new Walk entity into Core Data
    let walk = Walk(context: coreDataStack.managedContext)
    walk.date = Date()
    
    // Insert the new Walk into the Dog's walks set
    if let dog = currentDog,
      let walks = dog.walks?.mutableCopy() as? NSMutableOrderedSet {
      walks.add(walk)
      dog.walks = walks
    }
    
    // Save the managed object context
    coreDataStack.saveContext()
      
    // Reload table view
    tableView.reloadData()
  }
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return currentDog?.walks?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //let date = walks[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
    guard let walk = currentDog?.walks?[indexPath.row] as? Walk,
      let walkDate = walk.date as Date? else {
        return cell
    }
    
    cell.textLabel?.text = dateFormatter.string(from: walkDate)
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "List of Walks"
  }
  
  //Can edit cells
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //1. First, you get a reference to the walk you want to delete.
    guard let walkToRemove = currentDog?.walks?[indexPath.row] as? Walk,
      editingStyle == .delete else { return }
    
    //2. Remove the walk from Core Data by calling NSManagedObjectContext’s delete() method. Core Data also takes care of removing the deleted walk from the current dog’s walks relationship.
    coreDataStack.managedContext.delete(walkToRemove)
    
    //3. No changes are final until you save your managed object context — not even deletions
    coreDataStack.saveContext()
    
    //4. Finally, if the save operation succeeds, you animate the table view to tell the user about the deletion
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
}
