/*:
 [Previous](@previous)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Next](@next)
 
 # Observer
 - - - - - - - - - -
 ![Observer Diagram](Observer_Diagram.png)
 
 The observer pattern allows "observer" objects to register for and receive updates whenever changes are made to "subject" objects.
 
 This pattern allows us to define "one-to-many" relationships between many observers receiving updates from the same subject.
 
 ## Code Example
 */
// 1 First, you import Combine, which includes the @Published annotation and Publisher & Subscriber types.
import Combine
// 2 Next, you declare a new User class; @Published properties cannot be used on structs or any other types besides classes.
public class User {
    // 3 Next, you create a var property for name and mark it as @Published. This tells Xcode to automatically generate a Publisher for this property. Note that you cannot use @Published for let properties, as by definition they cannot be changed.
    @Published var name: String
    // 4 Finally, you create an initializer that sets the initial value of self.name.
    public init(name: String) {
        self.name = name
    }
}


// 1 First, you create a new user named Ray.
let user = User(name: "Ray")
// 2 Next, you access the publisher for broadcasting changes to the user's name via user.$name. This returns an object of type Published<String>.Publisher. This object is what can be listened to for updates.
let publisher = user.$name
// 3 Next, you create a subscriber by calling sink on the publisher. This takes a closure for which is called for the initial value and anytime the value changes. By default, sink returns a type of AnyCancellable. However, you explicitly declare this type as AnyCancellable? to make it optional as you'll nil it out later.
var subscriber: AnyCancellable? = publisher.sink() {
    print("User's name is \($0)")
}
// 4
user.name = "Vicki"

subscriber = nil
user.name = "Ray has left the building"
