//
//  Food+CoreDataProperties.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 12/17/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var enteredDate: Date
    @NSManaged public var expirationDate: Date?
    @NSManaged public var inRecipe: Bool
    @NSManaged public var label: String
    @NSManaged public var locationEnum: Int16
    @NSManaged public var quantity: String?

}

extension Food : Identifiable {

}
