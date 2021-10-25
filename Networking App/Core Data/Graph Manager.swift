//
//  Graph Manager.swift
//  Networking App
//
//  Created by Jia Jie Chan on 26/7/21.
//

import Foundation
import CoreData

struct GraphManager {
    static var counter: Int = 0
    static var lookups: Int = 0
    
    private let _GraphRepository = GraphDataRepository()
    
    //MARK: CREATE
    
    func create(vertex: Vertex, id: UUID) {
        _GraphRepository.create(vertex: vertex, id: id)
        GraphManager.counter += 1
        print("created: \(GraphManager.counter)")
    }
    
    func createBus(busNumber: String, id: UUID) {
        _GraphRepository.createBus(busNumber: busNumber, id: id)
    }
    
    func deleteAll() {
        _GraphRepository.deleteAll()
    }
    
    //MARK: ADD RELATIONSHIPS
    
    func addCDBus(busNumber: String, lookup: CDVertex, busLookup: CDBusLookup) {
        _GraphRepository.addCDBus(busNumber: busNumber, CDVertex: lookup, CDBusLookup: busLookup)
    }
    
    func addCDEdge(source: Vertex, destination: Vertex, edgeWeight: Double, busNumber: String, lookup: CDVertex) {
        let lookup = lookup
            GraphManager.lookups += 1
            print("Lookups: \(GraphManager.lookups)")
        _GraphRepository.addCDEdge(source: source, destination: destination, edgeWeight: edgeWeight, busNumber: busNumber, CDVertex: lookup)
    }
    
    func addCDRoute(CDBusLookup: CDBusLookup, route1item: Vertex?, route2item: Vertex?, stopSequence: Int) {
        _GraphRepository.addCDRoute(CDBusLookup: CDBusLookup, route1item: route1item, route2item: route2item, stopSequence: stopSequence)
    }
    
    
    //MARK: RETRIEVALS
    
    func getAll() -> ([Vertex], [String: Set<String>], [String: Route])? {
        return _GraphRepository.getAll()
    }
    
    func getCDBusLookup(id: UUID) -> CDBusLookup? {
        _GraphRepository.getCDBusLookup(byIdentifier: id)
    }
    
    func getCDVertex(id: UUID) -> CDVertex? {
        _GraphRepository.getCDVertex(byIdentifier: id)
    }
    
    /*func getRouteDict() -> [String: Route] {
        return _GraphRepository.getRoute()
    }*/
}
