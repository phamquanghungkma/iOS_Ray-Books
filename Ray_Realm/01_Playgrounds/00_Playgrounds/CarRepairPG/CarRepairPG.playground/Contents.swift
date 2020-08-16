import Foundation
import RealmSwift

// Setup
let realm = try! Realm(configuration:
  Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))

print("Ready to play!")

class Person: Object {
    @objc dynamic var name = ""
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }
}

class RepairShop: Object {
    @objc dynamic var name = ""
    @objc dynamic var contact: Person?
}


let marin = Person("Marin")
let jack = Person("Jack")

let myLittleShop = RepairShop()
myLittleShop.name = "Me little Auto Shop"
myLittleShop.contact = jack
myLittleShop.contact = nil

print(myLittleShop.contact?.name ?? "n/a")


class Car: Object {
    @objc dynamic var brand = ""
    @objc dynamic var year = 0
    // Object relationships
    @objc dynamic var owner: Person?
    @objc dynamic var shop: RepairShop?
    convenience init(brand: String, year: Int) { self.init()
        self.brand = brand
        self.year = year
    }
    override var description: String {
        return "Car {\(brand), \(year)}"
    }
    let repairs = List<Repair>()
    let plates = List<String>()
    let checkups = List<Date>()
    let stickers = List<String>()
}

class Repair: Object {
    @objc dynamic var date = Date()
    @objc dynamic var person: Person?
    convenience init(by person: Person) {
        self.init()
        self.person = person
    }
}

let car = Car(brand: "BMW", year: 1980)
Example.of("Object relationships") {
    car.shop = myLittleShop
    car.owner = marin
    print(car.shop == myLittleShop)
    print(car.owner!.name)
}

class Vehicle: Object {
    @objc dynamic var year = 0
    @objc dynamic var isDiesel = false
    convenience init(year: Int, isDiesel: Bool) {
        self.init()
        self.year = year
        self.isDiesel = isDiesel
    }
}

class Truck: Object {
    @objc dynamic var vehicle: Vehicle?
    @objc dynamic var nrOfGears = 12
    @objc dynamic var nrOfWheels = 16
    convenience init(year: Int, isDiesel: Bool, gears: Int, wheels: Int) {
        self.init()
        self.vehicle = Vehicle(year: year, isDiesel: isDiesel)
        self.nrOfGears = gears
        self.nrOfWheels = wheels
    }
}

Example.of("Adding Object to a different Object's List property") {
    car.repairs.append( Repair(by: jack) )
    car.repairs.append(objectsIn: [
        Repair(by: jack),
        Repair(by: jack),
        Repair(by: jack)
    ])
    print("\(car) has \(car.repairs.count) repairs")
}

Example.of("Adding Pointer to the Same Object") {
    let repair = Repair(by: jack)
    car.repairs.append(repair)
    car.repairs.append(repair)
    car.repairs.append(repair)
    car.repairs.append(repair)
    print(car.repairs)
    //let firstRepair: Date? = car.repairs.min(ofProperty: "date")
    //let lastRepair: Date? = car.repairs.max(ofProperty: "date")
}

Example.of("Adding Primitive types to Realm List(s)") {
    // String
    car.plates.append("WYZ 201 Q")
    car.plates.append("2MNYC0DZ")
    print(car.plates)
    print("Current registration: \(car.plates.last!)")
    
    // Date
    car.checkups.append(Date(timeIntervalSinceNow: -31557600))
    car.checkups.append(Date())
    print(car.checkups)
    print(car.checkups.first!)
    print(car.checkups.max()!)
}

class Sticker: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var text = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(_ text: String) { self.init()
        self.text = text
    }
}

Example.of("Referencing objects from a different Realm file") {
    // Let's say we're storing those in "stickers.realm"
//    let sticker = Sticker("Swift is my life")
//    car.stickers.append(sticker.id)
//    print(car.stickers)
//
//    try! realm.write {
//        realm.add(car)
//        realm.add(sticker)
//    }
//    print("Linked stickers:")
//    print(realm.objects(Sticker.self)
//        .filter("id IN %@", car.stickers))
}

