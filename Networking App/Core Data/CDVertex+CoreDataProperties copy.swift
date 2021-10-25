//
//  CDVertex+CoreDataProperties.swift
//  
//
//  Created by Jia Jie Chan on 25/7/21.
//
//

import Foundation
import CoreData


extension CDVertex {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDVertex> {
        return NSFetchRequest<CDVertex>(entityName: "CDVertex")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var vertexLabel: String?
    @NSManaged public var edge: NSSet?
    @NSManaged public var buses: NSSet?
    
    public var edgeArray: [CDEdge] {
        let set = edge as? Set<CDEdge> ?? []
        
        return set.sorted {
            $0.edgeWeight < $1.edgeWeight
        }
    }
    
    public var busSet: [CDBusLookup] {
        let set = buses as? Set<CDBusLookup> ?? []
        
        return set.sorted() {
            $0.bus! < $1.bus!
        }
    }

}

// MARK: Generated accessors for edge
extension CDVertex {

    @objc(addEdgeObject:)
    @NSManaged public func addToEdge(_ value: CDEdge)

    @objc(removeEdgeObject:)
    @NSManaged public func removeFromEdge(_ value: CDEdge)

    @objc(addEdge:)
    @NSManaged public func addToEdge(_ values: NSSet)

    @objc(removeEdge:)
    @NSManaged public func removeFromEdge(_ values: NSSet)
    
    func convertToEdgeArray() -> [Edge] {
        var placeholder: [Edge] = []
        self.edgeArray.forEach { value in
            let edgeToAppend: Edge = Edge(source: Vertex(vertexLabel: value.source!), destination: Vertex(vertexLabel: value.destination!), weight: value.edgeWeight)
            placeholder.append(edgeToAppend)
        }
        return placeholder
    }
    
    func convertToBusSet() -> [String] {
        var placeholder: [String] = []
        self.busSet.forEach { value in
            placeholder.append(value.bus!)
        }
        return placeholder
    }
    
    func convertToVertex() -> Vertex {
        let vertex = Vertex(vertexLabel: self.vertexLabel!)
        /*self.edgeArray.forEach({ value in
            let edge = Edge(source: Vertex(vertexLabel: value.source!), destination: Vertex(vertexLabel: value.destination!), weight: value.edgeWeight, bus: value.wrappedBusNumber)
            print("\(vertex) has connection to \(edge.destination)")
        })*/
        return vertex
    }

}

// MARK: Generated accessors for buses
extension CDVertex {

    @objc(addBusesObject:)
    @NSManaged public func addToBuses(_ value: CDBusLookup)

    @objc(removeBusesObject:)
    @NSManaged public func removeFromBuses(_ value: CDBusLookup)

    @objc(addBuses:)
    @NSManaged public func addToBuses(_ values: NSSet)

    @objc(removeBuses:)
    @NSManaged public func removeFromBuses(_ values: NSSet)

}
