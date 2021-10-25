//
//  CDBusLookup+CoreDataProperties.swift
//
//
//  Created by Jia Jie Chan on 28/7/21.
//
//

import Foundation
import CoreData


extension CDBusLookup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBusLookup> {
        return NSFetchRequest<CDBusLookup>(entityName: "CDBusLookup")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var bus: String?
    @NSManaged public var busStop: NSSet?
    @NSManaged public var route: NSSet?
    
    public var routeArray: [CDRoute] {
        let set = route as? Set<CDRoute> ?? []
        
        return set.sorted {
            $0.stopSequence < $1.stopSequence
        }
    }

}

// MARK: Generated accessors for route
extension CDBusLookup {

    @objc(addRouteObject:)
    @NSManaged public func addToRoute(_ value: CDRoute)

    @objc(removeRouteObject:)
    @NSManaged public func removeFromRoute(_ value: CDRoute)

    @objc(addRoute:)
    @NSManaged public func addToRoute(_ values: NSSet)

    @objc(removeRoute:)
    @NSManaged public func removeFromRoute(_ values: NSSet)
    
    func convertToRoute() -> Route {
        var placeholder = Route(busServiceNo: self.bus!)
        self.routeArray.forEach { value in
            if value.route1item != nil {
            placeholder.route1.append(Vertex(vertexLabel: value.route1item!))
            }
            
            if value.route2item != nil {
            placeholder.route2.append(Vertex(vertexLabel: value.route2item!))
            }
        }
        return placeholder
    }

}

// MARK: Generated accessors for busStop
extension CDBusLookup {

    @objc(addBusStopObject:)
    @NSManaged public func addToBusStop(_ value: CDVertex)

    @objc(removeBusStopObject:)
    @NSManaged public func removeFromBusStop(_ value: CDVertex)

    @objc(addBusStop:)
    @NSManaged public func addToBusStop(_ values: NSSet)

    @objc(removeBusStop:)
    @NSManaged public func removeFromBusStop(_ values: NSSet)

}

