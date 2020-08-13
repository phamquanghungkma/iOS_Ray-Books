//
//  Walk+CoreDataProperties.swift
//  DogWalk
//
//  Created by Михаил Дмитриев on 13.08.2020.
//  Copyright © 2020 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dog: Dog?

}
