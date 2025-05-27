//
//  User+CoreDataProperties.swift
//  
//
//  Created by Ignesious Robin on 27/05/25.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?

}
