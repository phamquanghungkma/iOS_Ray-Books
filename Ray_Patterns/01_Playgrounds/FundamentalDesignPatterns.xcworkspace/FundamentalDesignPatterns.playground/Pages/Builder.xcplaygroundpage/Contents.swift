/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Builder
 - - - - - - - - - -
 ![Builder Diagram](Builder_Diagram.png)
 
 The builder pattern allows complex objects to be created step-by-step instead of all-at-once via a large initializer.
 
 The builder pattern involves three parts:
 
 (1) The **product** is the complex object to be created.
 
 (2) The **builder** accepts inputs step-by-step and ultimately creates the product.
 
 (3) The **director** supplies the builder with step-by-step inputs and requests the builder create the product once everything has been provided.
 
 ## Code Example
 */
import Foundation
// MARK: - Product
// 1 You first define Hamburger, which has properties for meat, sauce and toppings. Once a hamburger is made, you aren’t allowed to change its components, which you codify via let properties. You also make Hamburger conform to CustomStringConvertible, so you can print it later.
public struct Hamburger {
    public let meat: Meat
    public let sauce: Sauces
    public let toppings: Toppings
}
extension Hamburger: CustomStringConvertible {
    public var description: String {
        return meat.rawValue + " burger"
    }
}

// 2 You declare Meat as an enum. Each hamburger must have exactly one meat selection: sorry, no beef-chicken-tofu burgers allowed. You also specify an exotic meat, kitten. Who doesn’t like nom nom kitten burgers?
public enum Meat: String {
    case beef
    case chicken
    case kitten
    case tofu
}
// 3 You define Sauces as an OptionSet. This will allow you to combine multiple sauces together. My personal favorite is ketchup-mayonnaise-secret sauce.
public struct Sauces: OptionSet {
    public static let mayonnaise = Sauces(rawValue: 1 << 0)
    public static let mustard = Sauces(rawValue: 1 << 1)
    public static let ketchup = Sauces(rawValue: 1 << 2)
    public static let secret = Sauces(rawValue: 1 << 3)
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
// 4 You likewise define Toppings as an OptionSet. You’re gonna need more than pickles for a good burger!
public struct Toppings: OptionSet {
    public static let cheese = Toppings(rawValue: 1 << 0)
    public static let lettuce = Toppings(rawValue: 1 << 1)
    public static let pickles = Toppings(rawValue: 1 << 2)
    public static let tomatoes = Toppings(rawValue: 1 << 3)
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - Builder
public class HamburgerBuilder {
    public enum Error: Swift.Error {
        case soldOut
    }
    // 1 You declare properties for meat, sauces and toppings, which exactly match the inputs for Hamburger. Unlike a Hamburger, you declare these using var to be able to change them. You also specify private(set) for each to ensure only HamburgerBuilder can set them directly.
    public private(set) var meat: Meat = .beef
    public private(set) var sauces: Sauces = []
    public private(set) var toppings: Toppings = []
    private var soldOutMeats: [Meat] = [.kitten]
    // 2 Since you declared each property using private(set), you need to provide public methods to change them. You do so via addSauces(_:), removeSauces(_:), addToppings(_:), removeToppings(_:) and setMeat(_:).
    public func addSauces(_ sauce: Sauces) {
        sauces.insert(sauce)
    }
    public func removeSauces(_ sauce: Sauces) {
        sauces.remove(sauce)
    }
    public func addToppings(_ topping: Toppings) {
        toppings.insert(topping)
    }
    public func removeToppings(_ topping: Toppings) {
        toppings.remove(topping)
    }
    public func setMeat(_ meat: Meat) throws {
        guard isAvailable(meat) else { throw Error.soldOut }
        self.meat = meat
    }
    public func isAvailable(_ meat: Meat) -> Bool {
        return !soldOutMeats.contains(meat)
    }
    // 3 Lastly, you define build() to create the Hamburger from the selections.
    public func build() -> Hamburger { return Hamburger(meat: meat,
                                                        sauce: sauces,
                                                        toppings: toppings)
    }
}

// MARK: - Director
public class Employee {
    public func createCombo1() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try builder.setMeat(.beef)
        builder.addSauces(.secret)
        builder.addToppings([.lettuce, .tomatoes, .pickles])
        return builder.build()
    }
    public func createKittenSpecial() throws -> Hamburger {
        let builder = HamburgerBuilder()
        try
            builder.setMeat(.kitten)
        builder.addSauces(.mustard)
        builder.addToppings([.lettuce, .tomatoes])
        return builder.build() }
}

// MARK: - Example
let burgerFlipper = Employee()
if let combo1 = try? burgerFlipper.createCombo1() {
    print("Nom nom " + combo1.description)
}


if let kittenBurger = try? burgerFlipper.createKittenSpecial() { print("Nom nom nom " + kittenBurger.description)
} else {
    print("Sorry, no kitten burgers here... :[")
}
