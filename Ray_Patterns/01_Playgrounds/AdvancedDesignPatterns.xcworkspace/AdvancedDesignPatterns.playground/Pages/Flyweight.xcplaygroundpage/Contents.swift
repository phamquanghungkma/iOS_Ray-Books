/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Flyweight
 - - - - - - - - - -
 ![Flyweight Diagram](Flyweight_Diagram.png)
 
 The Flyweight Pattern is a structural design pattern that minimizes memory usage and processing.
 
 The flyweight pattern provides a shared instance that allows other instances to be created too. Every reference to the class refers to the same underlying instance.
 
 ## Code Example
 */

import UIKit

let red = UIColor.red
let red2 = UIColor.red
print(red === red2) // proves this is a flyweight

let color = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
let color2 = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
print(color === color2) // proves this is NOT a flyweight

extension UIColor {
  //1. You created a dictionary called colorStore to store RGBA values.
  public static var colorStore: [String: UIColor] = [:]
  //2. You wrote your own method that takes red green, blue and alpha like the UIColor method. You store the RGB values in a string called key. If a color with that key already exists in colorStore, use that one instead of creating a new one.
  public class func rgba(_ red: CGFloat,
                         _ green: CGFloat,
                         _ blue: CGFloat,
                         _ alpha: CGFloat) -> UIColor {
    
    let key = "\(red)\(green)\(blue)\(alpha)"
    if let color = colorStore[key] {
      return color
    }
    //3. If the key does not already exist in the colorStore, create the UIColor and store it along with its key.
    let color = UIColor(red: red,
                        green: green,
                        blue: blue,
                        alpha: alpha)
    colorStore[key] = color
    return color
  }
}

let flyColor = UIColor.rgba(1, 0, 0, 1)
let flyColor2 = UIColor.rgba(1, 0, 0, 1)
print(flyColor === flyColor2)  // proves this is a flyweight class method
