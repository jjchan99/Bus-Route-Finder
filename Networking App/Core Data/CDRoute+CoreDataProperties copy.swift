//
//  CDRoute+CoreDataProperties.swift
//  
//
//  Created by Jia Jie Chan on 28/7/21.
//
//

import Foundation
import CoreData


extension CDRoute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRoute> {
        return NSFetchRequest<CDRoute>(entityName: "CDRoute")
    }

    @NSManaged public var route1item: String?
    @NSManaged public var route2item: String?
    @NSManaged public var stopSequence: Int64
    @NSManaged public var bus: CDBusLookup?

}
