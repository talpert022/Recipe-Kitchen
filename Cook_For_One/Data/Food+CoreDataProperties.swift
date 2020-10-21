//
//  Food+CoreDataProperties.swift
//  Cook_For_One
//
//  Created by Tommy Alpert on 10/19/20.
//  Copyright © 2020 Tommy Alpert. All rights reserved.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var enteredDate: Date?
    @NSManaged public var expirationDate: Date?
    @NSManaged public var label: String?
    @NSManaged public var locationEnum: Int16
    @NSManaged public var quantity: String?

}

extension Food : Identifiable {

}
