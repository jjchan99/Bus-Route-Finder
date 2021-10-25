//
//  Vertex Model.swift
//  Networking App
//
//  Created by Jia Jie Chan on 30/4/21.
//

import Foundation

struct Vertex: Identifiable {
    
    let id = UUID()
    
    var vertexLabel: String
    var adjacencyList: [Vertex: [Edge]] = [:]
    var heuristicValue: Double
   
    init(vertexLabel: String, heuristicValue: Double = Double.infinity ) {
            self.vertexLabel = vertexLabel
            self.heuristicValue = heuristicValue
    }
    
    mutating func addEdge(from source: Vertex, to destination: inout Vertex, weight: Double, directed: Bool = true, bus: String = "") {
            
        let edge = Edge(source: source, destination: destination, weight: weight, bus: bus)
            if self.adjacencyList[source] == nil {
                self.adjacencyList[source] = [edge]
            } else {
                self.adjacencyList[source]?.append(edge)
            }
            
            if !directed {
                self.makeEdgeUndirected(from: source, to: &destination, weight: weight)
            }
        }
        private mutating func makeEdgeUndirected(from source: Vertex, to destination: inout Vertex, weight: Double) {
            let edge = Edge(source: destination, destination: source, weight: weight)
            //self.adjacencyList[destination] = [edge]
            
            if destination.adjacencyList[destination] == nil {
                destination.adjacencyList[destination] = [edge]
            } else {
                destination.adjacencyList[destination]?.append(edge)
            }
            //print("V: \(destination) --> \(edge)")
        }
    }

    extension Vertex: CustomStringConvertible {
        public var description: String {
            return "\(vertexLabel)"
        }
    }

    extension Vertex: Hashable, Equatable {
        
        static func == (lhs: Vertex, rhs: Vertex) -> Bool {
            return lhs.vertexLabel == rhs.vertexLabel
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(vertexLabel)
        }
        
    }

extension String {
    init(_ value: Vertex) {
        self = value.vertexLabel
    }
}

    




