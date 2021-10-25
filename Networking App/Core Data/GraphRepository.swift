//
//  GraphRepository.swift
//  Networking App
//
//  Created by Jia Jie Chan on 25/7/21.
//

import Foundation
import CoreData

protocol GraphRepository {
    //MARK: CREATE
    func create(vertex: Vertex, id: UUID)
    func createBus(busNumber: String, id: UUID)
    
    //MARK: RETRIEVE
    func getCDVertex(byIdentifier id: UUID) -> CDVertex?
    func getCDBusLookup(byIdentifier id: UUID) -> CDBusLookup?
    
    //MARK: RELATIONSHIPS
    func addCDEdge(source: Vertex, destination: Vertex, edgeWeight: Double, busNumber: String, CDVertex: CDVertex)
    func addCDBus(busNumber: String, CDVertex: CDVertex, CDBusLookup: CDBusLookup)
    func addCDRoute(CDBusLookup: CDBusLookup, route1item: Vertex?, route2item: Vertex?, stopSequence: Int)
    
    
    //MARK: MISC
    func getAll() -> ([Vertex], [String: Set<String>], [String: Route])?
    func deleteAll()
    //func getRoute() -> [String: Route]
}

struct GraphDataRepository: GraphRepository {
   
    let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    //MARK: CREATE
    
    func create(vertex: Vertex, id: UUID) {
        let result = CDVertex(context: context)
        result.id = id
        result.vertexLabel = String(vertex)
        PersistenceController.shared.saveContext()
    }
    
    func createBus(busNumber: String, id: UUID) {
        let bus = CDBusLookup(context: context)
        bus.bus = busNumber
        bus.id = id
        PersistenceController.shared.saveContext()
    }
    
    //MARK: ADD RELATIONSHIPS
    
    func addCDEdge(source: Vertex, destination: Vertex, edgeWeight: Double, busNumber: String, CDVertex: CDVertex) {
        let CDVertex = CDVertex
        
        let edge = CDEdge(context: context)
        edge.source = String(source)
        edge.destination = String(destination)
        edge.edgeWeight = edgeWeight
        edge.busNumber = busNumber
        
        CDVertex.addToEdge(edge)
     
        //print("\(CDVertex.vertexLabel!) --> \(edge.destination!)")
        
        
        PersistenceController.shared.saveContext()
    }
    
    func addCDBus(busNumber: String, CDVertex: CDVertex, CDBusLookup: CDBusLookup) {
        CDVertex.addToBuses(CDBusLookup)
        PersistenceController.shared.saveContext()
    }
    
    func addCDRoute(CDBusLookup: CDBusLookup, route1item: Vertex?, route2item: Vertex?, stopSequence: Int) {
        let CDBusLookup = CDBusLookup
        
        let routeToAdd = CDRoute(context: context)
        if let route1item = route1item {
        routeToAdd.route1item = String(route1item)
        routeToAdd.stopSequence = Int64(stopSequence)
        }
        
        if let route2item = route2item {
        routeToAdd.route2item = String(route2item)
        routeToAdd.stopSequence = Int64(stopSequence)
        }
        
        CDBusLookup.addToRoute(routeToAdd)
        
        PersistenceController.shared.saveContext()
    }
    
    //MARK: RETRIEVALS
    
    func getCDVertex(byIdentifier id: UUID) -> CDVertex? {
        let fetchRequest = NSFetchRequest<CDVertex>(entityName: "CDVertex")
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest).first
            //print("Fetched \(result) from id \(id)")
            guard result != nil else {
                print("Nothing found.")
                return nil }
            return result
        } catch let error {
            print("Please debug this error. Go to GraphRepository under getCDVertex. \(error)")
            return nil
        }
    }
    
    func getCDBusLookup(byIdentifier id: UUID) -> CDBusLookup? {
        let fetchRequest = NSFetchRequest<CDBusLookup>(entityName: "CDBusLookup")
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest).first
            //print("Fetched \(result) from id \(id)")
            guard result != nil else {
                print("Nothing found.")
                return nil }
            return result
        } catch let error {
            print("Please debug this error. Go to GraphRepository under getCDVertex. \(error)")
            return nil
        }
    }
    
    //MARK: MISC
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDVertex")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error {
            print("\(error)")
        }
    }
    
    func getAll() -> ([Vertex], [String: Set<String>], [String: Route])? {
        Log.queue(action: "Getting graph stores!")
        let result = PersistenceController.shared.fetchManagedObject(managedObject: CDVertex.self)
        var vArray: [Vertex] = []
        var BusStopToBus = [String: Set<String>]()
        var routeLookup = [String: Route]()
        
        let timerStart: Double = CFAbsoluteTimeGetCurrent()
        for value in result! {
            
            var vertex = Vertex(vertexLabel: value.vertexLabel!)
            let edges = value.edgeArray
            
            //print(edges.count)
            let buses = value.busSet
            BusStopToBus[String(vertex)] = []
            
            edges.forEach { edge in
                
                let source = vertex
                var destination = Vertex(vertexLabel: edge.destination!)
               
                let edgeWeight = edge.edgeWeight
                let busNumber = edge.busNumber
                vertex.addEdge(from: source, to: &destination, weight: edgeWeight, bus: busNumber!)
                //print("\(source) --> \(destination): \(busNumber!). weight: \(edgeWeight)")
            }
            
            vArray.append(vertex)
           
            if vertex.vertexLabel.contains("'") {
                continue
            }
            
            buses.forEach { value in
                BusStopToBus[String(vertex)]!.insert(value.bus!)
                
                if routeLookup[value.bus!] == nil {
                    routeLookup[value.bus!] = value.convertToRoute()
                }
            }
        }
        
        let timerEnd: Double = CFAbsoluteTimeGetCurrent() - timerStart
        print("getAll() took \(timerEnd) seconds")
        
        return (vArray, BusStopToBus, routeLookup)
    }
    
    /*func getRoute() -> [String: Route] {
        let timerStart: Double = CFAbsoluteTimeGetCurrent()
        let result = PersistenceController.shared.fetchManagedObject(managedObject: CDBusLookup.self)
        var placeholder = [String: Route]()
        
        result?.forEach { bus in
            let routeValue = Route(busServiceNo: bus.bus!)
            let key = bus.bus!
            placeholder[key] = routeValue
            
            bus.routeArray.forEach { route in
               
                if route.route1item != nil {
                let thingToAppend = Vertex(vertexLabel: route.route1item!)
                placeholder[key]!.route1.append(thingToAppend)
                }
                
                if route.route2item != nil {
                let thingToAppend2 = Vertex(vertexLabel: route.route2item!)
                placeholder[key]!.route2.append(thingToAppend2)
                }
                
            }
        }
        
        let timerEnd: Double = CFAbsoluteTimeGetCurrent() - timerStart
        print("getRoute() took \(timerEnd) seconds")
        print("DEBUG FINALE: \(placeholder["162"])")
        return placeholder
    }*/
}



