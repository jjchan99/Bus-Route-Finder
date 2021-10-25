//
//  Dijkstra Model.swift
//  Networking App
//
//  Created by Jia Jie Chan on 30/4/21.
//

import Foundation //LATEST VERSION AS OF 17/7/2021

struct Dijkstra {
    var name: String = ""
   
    //MARK: core properties
    var vertexCollection: [[Vertex]] = [[], []]
    var myHeap: [MinHeap] = []
    var valueTable: [[Vertex: Double]] = [[:], [:]]
    var seen: [Set<Vertex>] = [[], []]
    var intersectedVertex: Vertex?
    var hValueDict: [[Vertex: Double]] = [[:], [:]]
    
    //MARK: traversal helpers
    var BusStopsToBus: [String: Set<String>]
    var routeDict: [String: Route] = [:]
    private var VertexToBus = [String(): Set<String>()]
    var smartBook: [[Vertex: [(Set<String>, Vertex)]]] = [[:], [:]]
    var smartBookFlick1: [Vertex: [(Set<String>, Vertex)]] = [:]
    var hValueGenesis: Double = Double.infinity
    
    //MARK: OUTPUT
    var output: [(Set<String>, Vertex)]?
    
    //MARK: initializer
    init(vertexCollection: [Vertex], invertedCollection: [Vertex], name: String, BusStopsToBus: [String: Set<String>]) {
        self.name = name

        self.vertexCollection = [vertexCollection, vertexCollection]
        self.myHeap = [MinHeap(name: name), MinHeap(name: name)]
        self.myHeap[0].elements = vertexCollection
            //self.myGraph[0].addToGraph(Vertex: vertex)
        self.BusStopsToBus = BusStopsToBus
        self.myHeap[1].elements = invertedCollection
            //self.myGraph[1].addToGraph(Vertex: vertex)
        
    }
    
    //MARK: internal functions
    internal func retrieveIdx(array: [Vertex], target: String) -> Int {
        var retrievedIdx: Int?
        
        for idx in (0..<array.count) {
            if array[idx].vertexLabel == target {
                retrievedIdx = idx
            }
        }
        return retrievedIdx ?? 0
    }
    
    //MARK: TRAVERSE function
    mutating func traverse(start: Vertex, end: Vertex) -> Bool {
        var flick = 1
        
        var endGuard: Bool {
            return self.valueTable[0][end] == Double.infinity && self.valueTable[1][start] == Double.infinity
        }
        
        var intersectionGuard: Bool {
            if let intersecetionVertex = self.seen[0].intersection(self.seen[1]).first {
                print("Intersection found: \(self.seen[0].intersection(self.seen[1]).first)")
                self.intersectedVertex = intersecetionVertex
            }
            return (self.seen[0].intersection(self.seen[1]).count == 0)
        }
        
        //Penalizer properties
        var NumberOfWalks: Int = 0
        var walksSeen: Set<Vertex> = []
       
        //FLICK HERE
        while self.myHeap[flick].elements.count > 0 && endGuard && intersectionGuard {
            
                switch flick {
                case 0:
                    flick += 1
                case 1:
                    flick -= 1
                default:
                    fatalError()
               }
            
            if !myHeap[0].elements.contains(start) {
            self.myHeap[flick].heapSort()
            }
        
            let currentVertex = self.myHeap[flick].retrieveMin() as! Vertex //retrieve min AStarScore
            //print("Traversing from \(currentVertex). AStarScore is \(self.myHeap[flick].aStarScoreDict[currentVertex])")
            
            guard self.myHeap[flick].aStarScoreDict[currentVertex] != Double.infinity else {
                for x in self.myHeap[flick].elements {
                    if self.myHeap[flick].aStarScoreDict[x] != Double.infinity {
                        print("A star score: \(self.myHeap[flick].aStarScoreDict[x])")
                    fatalError("This shouldn't happen")
                    }
                }
                return false
            }
            
            //print("Min AStarScore: \(currentVertex.AStarScore). Traversing from Vertex \(currentVertex)...")
            
            for (_, edgeArray) in currentVertex.adjacencyList {
                for edgeValues in edgeArray {
                
                        //MARK: TRAVERSAL CORE PROPERTIES
                        var edgeWeight = edgeValues.weight
                        let BusNumber = edgeValues.BusServiceNo
                        let connectingVertex = edgeValues.destination
                    
                    if let connectingVertexHeuristicValue = self.hValueDict[flick][connectingVertex] {
                        
                        guard connectingVertexHeuristicValue != Double.infinity else {
                            continue
                        }
                        
                        
                        
                    //MARK: MAX WALK GUARD
                        if walksSeen.contains(currentVertex) {
                            if connectingVertex.vertexLabel != AlgorithmBook().AfterRemoveLast(string: currentVertex.vertexLabel) { continue }
                        }
                
                        var walkEvaluation: Bool {
                            return currentVertex.vertexLabel.contains("'") && connectingVertex.vertexLabel.contains("'")
                        }
                        
                        if connectingVertex.vertexLabel.contains("'") {
                            if NumberOfWalks >= 1 {
                           edgeWeight += hValueGenesis
                            } else {
                            }
                        }
                    //MARK: END OF MAX WALK GUARD
                    
                  
                            
                            
                    //MARK: BUSSTOPSTOBUS PENALIZER!
                    var penalized: Bool = false
                    if BusNumber != "" {
                    if flick == 0 {
                    if !self.BusStopsToBus[end.vertexLabel]!.contains(BusNumber) {
                        penalized = true
                    } else {
                       
                    }
                    }
                            
                    if flick == 1 {
                        if !self.BusStopsToBus[start.vertexLabel]!.contains(BusNumber) {
                        penalized = true
                        } else {
                           
                        }
                    }
                    }
                    //MARK: END BUS STOPS TO BUS PENALIZER!
                        
                    //MARK: TRANSFER PENALTY ATTEMPT!
                    let count = self.smartBook[flick][currentVertex]?.count
                    if let count = count {
                        if count >= 3 {
                            let previousElement = self.smartBook[flick][currentVertex]?[count - 2]
                            let alphaBusSet = previousElement?.0
                            if let alphaBusSet = alphaBusSet {
                                if alphaBusSet != [""] {
                            if !alphaBusSet.contains(BusNumber) {
                                if penalized {
                                edgeWeight += hValueGenesis
                                } else {
                                    
                                }
                            }
                            }
                    }
                    }
                    }
                        
                    //MARK: VALUETABLE BEFORE UPDATE!
                    let valueBefUpdate = valueTable[flick][connectingVertex]
                    
                    let currentVertexdistanceValue = self.myHeap[flick].dvDict[currentVertex]
                    
                        if self.myHeap[flick].elements.contains(connectingVertex) && (edgeWeight + currentVertexdistanceValue! + connectingVertexHeuristicValue) <= valueTable[flick][connectingVertex] ?? Double.infinity {
        
                            //MARK: MATHEMATICAL UPDATES
                            let AStarScore = edgeWeight + currentVertexdistanceValue! + connectingVertexHeuristicValue
                                
                                self.myHeap[flick].dvDict[connectingVertex] = AStarScore - connectingVertexHeuristicValue
                                self.myHeap[flick].aStarScoreDict[connectingVertex] = AStarScore
                                self.valueTable[flick][connectingVertex] = AStarScore
                                
        if (edgeWeight + currentVertexdistanceValue! + connectingVertexHeuristicValue) == valueBefUpdate && smartBook[flick][connectingVertex]!.count >= 2 {
                                let lastItemCount = smartBook[flick][connectingVertex]?.count
                                if let lastItemCount = lastItemCount {
                                    smartBook[flick][connectingVertex]?[lastItemCount - 1].0.insert(BusNumber)
                                    
                                    //MARK: SMARTBOOKFLICK1 PIGGYBACK
                                    if flick == 1 {
                                    smartBookFlick1[connectingVertex]?[lastItemCount - 1 - 1].0.insert(BusNumber)
                                    }
                                    

                                    
                                }
                                } else {
                                    //MARK: UPDATE SMARTBOOK
                                    var alphaBusSet = Set<String>()
                                    alphaBusSet.insert(BusNumber)
                                    var smartPath: [(Set<String>, Vertex)]
                                    
                                    
                                    //MARK: UPDATE SMARTBOOKFLICK1
                                    var smartPathFlick1: [(Set<String>, Vertex)]
                                    if flick == 1 {
                                    if let idx = smartBook[flick][currentVertex]?.count {
                                    if idx >= 1 {
                                    smartBookFlick1[currentVertex]?[idx-1].0 = alphaBusSet
                                    }
                                    }
                                    smartPathFlick1 = smartBookFlick1[currentVertex]! + [  (alphaBusSet, connectingVertex)   ]
                                        
                                    //MARK: SNAKED FOR SMARTBOOKFLICK1
                                    smartBookFlick1[connectingVertex] = smartPathFlick1
                                    }
                                    
                                    //MARK: SNAKED FOR SMARTBOOK
                                    smartPath = smartBook[flick][currentVertex]! + [  (alphaBusSet, connectingVertex)   ]
                                    smartBook[flick][connectingVertex] = smartPath
                                    
                                  
                                }
                            
                          
                                
                          
                                
                            //MARK: WALK PROPERTIES
                            if walkEvaluation {
                                NumberOfWalks += 1
                                walksSeen.insert(connectingVertex)
                                print("walkSeen inserting \(connectingVertex)")
                            }
                          
                            //MARK: BREAK FREE FROM TRIPLE WALK!
                            if currentVertex.vertexLabel.contains("'") && connectingVertex.vertexLabel == AlgorithmBook().AfterRemoveLast(string: currentVertex.vertexLabel) {
                                break
                            }
        
                            //MARK: UPDATE SEEN
                            self.seen[flick].insert(connectingVertex)
                     
                                
                            //MARK: DEBUG
                            print("with bus \(BusNumber): updated \(connectingVertex): \(self.myHeap[flick].aStarScoreDict[connectingVertex])")
                            print("Taking bus \(BusNumber) from \(currentVertex) to \(connectingVertex).")
                          
            
                            continue
                        }
                    }
                }
            }
        }
        
        //MARK: END SMARTBOOK COMBINED
        self.smartBookFlick1[self.intersectedVertex ?? start]?.reverse()
        
        var result0: [(Set<String>, Vertex)] {
            if self.intersectedVertex != nil {
                return self.smartBook[0][self.intersectedVertex!]!
            } else {
                if self.valueTable[0][end] != Double.infinity {
                    return self.smartBook[0][end]!
                } else {
                    return self.smartBookFlick1[start]!
                }
        }
        }
            var counter: [String: Int] = [:]
            var combined: [(Set<String>, Vertex)]
            var foo: [(Set<String>, Vertex)] = result0
           
            if self.intersectedVertex != nil {
                Log.queue(action: "THIS SHOULD PRINT")
                for tuple in smartBookFlick1[self.intersectedVertex!]! {
                    if tuple.1.vertexLabel == self.intersectedVertex!.vertexLabel { continue }
                    foo.append(tuple)
                    
                    //MARK: COUNTER OPERATION
                    let Candidates = tuple.0
                    for candidates in Candidates {
                        if counter[candidates] == nil {
                            counter[candidates] = 1
                        } else {
                            counter[candidates]! += 1
                        }
                        }
                }
            }
            combined = foo
            
        
        for tuple in result0 {
            let candidates = tuple.0
            for candidates in candidates {
                if counter[candidates] == nil {
                    counter[candidates] = 1
                } else {
                    counter[candidates]! += 1
                }
            }
        }
        
        
        //MARK: SELECTING CANDIDATE FOR COMBINED SMARTBOOK
        let sorted = counter.sorted { $0.1 > $1.1 }
        
        for idx in 0..<combined.count {
                let set = combined[idx].0
                combined[idx].0.removeAll()
                var votesToBeat: Int = 0
            for (candidate, votes) in sorted {
                    if set.contains(candidate) && votes >= votesToBeat {
                        combined[idx].0.insert(candidate)
                        votesToBeat = votes
                }
            }
        }
        
        
        //MARK: DEBUG END SMARTBOOK
        print("DEBUG END SMARTBOOK: \(combined)")
        output = combined
        
        //MARK: DEBUG COUNTER
        print("DEBUG COUNTER: \(sorted)")
        
        return true
    }
}



extension Dijkstra: CustomStringConvertible {
    var description: String {
        let sorted = valueTable[0].sorted{ $0.value < $1.value }
        return "\(sorted)"
    }
}





