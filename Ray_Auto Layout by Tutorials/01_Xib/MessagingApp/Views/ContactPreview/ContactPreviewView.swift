/// Copyright (c) 2020 Razeware LLC
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

class ContactPreviewView: UIView {
  
  @IBOutlet var photoImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var contentView: UIView!
  
  // 1 Override the init(frame:) constructor so that you can call loadView().
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadView()
  }
  // 2 Override the required init(coder:) constructor so that you can call loadView(). Since it’s a required constructor, not implementing it will cause an error.
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadView()
  }
  
  func loadView() {
    // 3 Get a reference to the bundle that contains the ContactPreviewView .xib file.
    let bundle = Bundle(for: ContactPreviewView.self)
    // 4 Create an instance of the ContactPreviewView .xib, indicating its containing bundle.
    let nib = UINib(nibName: "ContactPreviewView", bundle: bundle)
    // 5 Instantiate the view and assign the owner, which is the current class.
    let view = nib.instantiate(withOwner: self).first as! UIView
    // 6 Set view.frame equal to bounds. This gives view the same dimensions as its parent.
    view.frame = bounds
    // 7 Add the instantiated view to the current view..
    // You can now use ContactPreviewView anywhere in your project, such as in ContactListTableViewController.
    addSubview(view)
  }
}
