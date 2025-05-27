//
//  ItemEntity+CoreDataProperties.swift
//  
//
//  Created by Ignesious Robin on 27/05/25.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
