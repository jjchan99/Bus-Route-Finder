//
//  Edge Model.swift
//  Networking App
//
//  Created by Jia Jie Chan on 30/4/21.
//

import Foundation

struct Edge {
    var source: Vertex
    var destination: Vertex
    let weight: Double
    let BusServiceNo: String
    
    init(source: Vertex, destination: Vertex, weight: Double, bus: String = "") {
        self.source = source
        self.destination = destination
        self.weight = weight
        self.BusServiceNo = bus
    }
    
    
    
    func getDestination() -> Vertex {
        return self.destination
    }
    
}


extension Edge: Hashable {
    
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.source.vertexLabel == rhs.source.vertexLabel && lhs.destination.vertexLabel == rhs.destination.vertexLabel && lhs.weight == rhs.weight
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(source.vertexLabel)
        hasher.combine(destination.vertexLabel)
    }
}

extension Edge: CustomStringConvertible {
    public var description: String {
        return "---V: \(destination), W: \(weight), Bus: \(BusServiceNo)---"
    }
}
