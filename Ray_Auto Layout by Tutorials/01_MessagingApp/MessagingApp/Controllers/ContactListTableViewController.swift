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

final class ContactListTableViewController: UITableViewController {
  // MARK: - Properties
  private let cellIdentififer = "ContactCell"
  
  @IBOutlet var contactPreviewView: ContactPreviewView!
  
  private var contacts: [Contact] = [
    Contact(name: "John Doe", photo: "rw-logo"),
    Contact(name: "Jane Doe", photo: "rw-logo"),
    Contact(name: "Joseph Doe", photo: "rw-logo")]
  
  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = 44
    
    //configureGestures()
    configureTapGesture()
  }
  
  // MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentififer, for: indexPath)
      as? ContactTableViewCell else { fatalError("Dequeued unregistered cell.") }
    
    let contact = contacts[indexPath.row]
    cell.nameLabel.text = contact.name
    
    return cell
  }
  
  // MARK: - Setup Contact Preview
  override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
    // 1 Get the corresponding contact using indexPath.row as the index.
    let contact = contacts[indexPath.row]
    // 2 Add the new view to the current main view.
    view.addSubview(contactPreviewView)
    
    contactPreviewView.nameLabel.text = contact.name
    contactPreviewView.photoImageView.image = UIImage(named: contact.photo)
    
    // 3 Set the constraints to make sure the view has a size of 150×150 and is centered vertically and horizontally.
    contactPreviewView
      .translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([ contactPreviewView.widthAnchor.constraint(
      equalToConstant: 150), contactPreviewView.heightAnchor.constraint(
        equalToConstant: 150), contactPreviewView.centerXAnchor.constraint(
          equalTo: view.centerXAnchor), contactPreviewView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor)
    ])
    // 4 Start with the view 1.25 times larger than normal and fully transparent.
    contactPreviewView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
    contactPreviewView.alpha = 0
    // 5 Create an animation to shrink the view down to normal and fade in to fully opaque.
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let self = self else { return }
      self.contactPreviewView.alpha = 1
      self.contactPreviewView.transform = CGAffineTransform.identity
    }
  }
  
  @objc private func hideContactPreview() {
    // 1 Create an animation to scale the view up and fade it out.
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      guard let self = self else { return }
      self.contactPreviewView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
      self.contactPreviewView.alpha = 0
    }) { (success) in
      // 2  Remove the view when the animation ends.
      self.contactPreviewView.removeFromSuperview()
    }
  }
  
  private func configureTapGesture() {
    // 1 Create a UITapGestureRecognizer that will trigger hideContactPreview when tapped.
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(hideContactPreview))
    // 2 Add the gesture to contactPreviewView and the view. This code allows the method to be called when the user taps the view or the popup view.
    contactPreviewView.addGestureRecognizer(tapGesture)
    view.addGestureRecognizer(tapGesture)
  }
}
