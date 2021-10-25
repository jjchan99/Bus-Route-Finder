//
//  CDEdge+CoreDataProperties.swift
//  
//
//  Created by Jia Jie Chan on 25/7/21.
//
//

import Foundation
import CoreData


extension CDEdge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDEdge> {
        return NSFetchRequest<CDEdge>(entityName: "CDEdge")
    }

    @NSManaged public var busNumber: String?
    @NSManaged public var destination: String?
    @NSManaged public var edgeWeight: Double
    @NSManaged public var source: String?
    @NSManaged public var vertex: CDVertex?
    
    public var wrappedBusNumber: String {
        busNumber ?? "Unknown busNumber"
    }
    
    public var wrappedSource: String {
        source ?? "Unknown source"
    }
    
    public var wrappedDestination: String {
        destination ?? "Unknown destination"
    }
    
    public var wrappedEdgeWeight: Double {
        edgeWeight
    }
    
    

}
