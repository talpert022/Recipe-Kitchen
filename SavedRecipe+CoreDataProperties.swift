//
//  SavedRecipe+CoreDataProperties.swift
//  Recipe Kitchen
//
//  Created by Tommy Alpert on 12/1/21.
//  Copyright © 2021 Tommy Alpert. All rights reserved.
//
//

import Foundation
import CoreData


extension SavedRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedRecipe> {
        return NSFetchRequest<SavedRecipe>(entityName: "SavedRecipe")
    }

    @NSManaged public var enteredDate: Date?
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?

}

extension SavedRecipe : Identifiable {

}
