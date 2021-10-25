//
//  manyRequest.swift
//  Networking App
//
//  Created by Jia Jie Chan on 9/5/21.
//

import Foundation
import SwiftUI
import CoreLocation
import CoreData

extension MapViewModel {
    
    private func InvertEdges(array: [Vertex]) -> [Vertex] {
        
        let timerStart: Double = CFAbsoluteTimeGetCurrent()
        
        print("Combined count: \(array.count)")
        var InvertedArray: [Vertex] = []
        
        var counter: Int = 0
        for vertex in array {
            var source: Vertex = Vertex(vertexLabel: vertex.vertexLabel)
            source.adjacencyList[source] = []
            counter += 1
            InvertedArray.append(source)
            }
        
        InvertedArray = AlgorithmBook().mergeSort(forArray: InvertedArray)
        
        for idx in 0..<array.count {
            for (source, edgeArray) in array[idx].adjacencyList {
                var source = source
                guard edgeArray != [] else { break }
                for currentEdge in edgeArray {
                    let destination: Vertex = currentEdge.destination
                    let weight = currentEdge.weight
                    let bus = currentEdge.BusServiceNo
                    
                    guard let retrievedIdx = AlgorithmBook().BinarySearch(sortedArray: InvertedArray, for: destination.vertexLabel) else {
                        print("Error retrieving this vertex: \(destination)")
                        continue
                    }
                    InvertedArray[retrievedIdx].addEdge(from: destination, to: &source, weight: weight, bus: bus)
        }
    }
    }

        let timerEnd: Double = CFAbsoluteTimeGetCurrent() - timerStart
        print("Inverted Array took \(timerEnd) seconds")
        return InvertedArray
    }
    
    func getBusArrivals(busStopCode: String, completion: @escaping (BusArrivals) -> ()) {
        let url = Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode=" + "\(busStopCode)")
        
        var request = URLRequest(url: url!)
        
        //Specify the header
        let header: [String: String] = ["AccountKey" : "PEs9uVD5TnWV8LR9CmsRdQ==",
                                         "accept" : "application/json"]
        
        request.allHTTPHeaderFields = header
        
        request.httpMethod = "GET"
        
        //Get session
        let session = URLSession.shared
        let timerStart: Double = CFAbsoluteTimeGetCurrent()
        //Create task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
        
            if error == nil && data != nil {
                //print(response)
                
                //Parse
                let decoder = JSONDecoder()
                do {
                   let loaded = try decoder.decode(BusArrivals.self, from: data!)
                   completion(loaded)
                }
                catch {
                    print(error)
                    fatalError("Error in JSON parsing (API2)")
                }
            }
        }
            dataTask.resume()
           
}
        
    
    
    
    internal func makeRequest(completion: @escaping (Dijkstra, [BusRoutes], [String: Route]) -> ()) {
        //API2Manager().deleteAll()
        
        var BusRoutesCollection: [BusRoutes] = []
            
        //MARK: GENERATE VERTEX SET PROPERTIES
            var lookup: [String: Vertex] = [:]
            var combined: [Vertex] = []
            var singular: [Vertex] = []
            var idx = 0
            var BusStopToBus: [String: Set<String>] = [:]
            var idlookup: [Vertex: UUID] = [:]
            var busLookup: [String: UUID] = [:]
        
        //MARK: ROUTE PROPERTIES
        var serviceNoToRoute: [String: Route] = [:]
        //MARK: END
        
       
        let url = [Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=1000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=1500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=2000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=2500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=3000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=3500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=4000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=4500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=5000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=5500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=6000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=6500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=7000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=7500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=8000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=8500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=9000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=9500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=10000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=10500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=11000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=11500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=12000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=12500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=13000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=13500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=14000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=14500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=15000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=15500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=16000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=16500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=17000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=17500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=18000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=18500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=19000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=19500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=20000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=20500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=21000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=21500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=22000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=22500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=23000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=23500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=24000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=24500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=25000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=25500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes?$skip=26000")]
        
        let timerStart: Double = CFAbsoluteTimeGetCurrent()
        
            if API2Manager().fetchBusRoute()?.count == 0 {
                //URL Request
                url.forEach { (url) in
                    let group = DispatchGroup()
                    group.enter()

                    guard url != nil else {
                        print("Couldn't retrive URL")
                        return
                    }
                    
                var request = URLRequest(url: url!)
                
                //Specify the header
                let header: [String: String] = ["AccountKey" : "PEs9uVD5TnWV8LR9CmsRdQ==",
                                                 "accept" : "application/json"]
                
                request.allHTTPHeaderFields = header
                
                request.httpMethod = "GET"
                
                //Get session
                let session = URLSession.shared
                let timerStart: Double = CFAbsoluteTimeGetCurrent()
                //Create task
                let dataTask = session.dataTask(with: request) { (data, response, error) in
                
                    if error == nil && data != nil {
                        //print(response)
                        
                        //Parse
                        let decoder = JSONDecoder()
                        do {
                           let loaded = try decoder.decode(Disposable.self, from: data!)
                            
                            for values in loaded.value {
                                    API2Manager().createBusRoute(busRoutes: values)
                                    BusRoutesCollection.append(values)
                        }
                        }
                        catch {
                            //fatalError("Error in JSON parsing (API2)")
                        }
                        
                        group.leave()
                    }
                }
                    dataTask.resume()
                    group.wait()
        }
            } else {
                BusRoutesCollection = API2Manager().fetchBusRoute()!
                //print("DEBUG API2CACHE COUNT: \(BusRoutesCollection.count)")
            }
        
        //GraphManager().deleteAll()
        
        //MARK: DONE!
        print("Test count: \(GraphManager().getAll()?.0.count)")
        
        if GraphManager().getAll()?.0.count == 0 {
            Log.queue(action: "Initializing graph stores...")
            
            //MARK: GENERATE VERTEX SET
                    for element in BusRoutesCollection {
                       
                        let ServiceNo = element.ServiceNo
                        
                        let Direction = element.Direction
                        let currentElement = element
                        let stopSequence = element.StopSequence
                        
                        let idxGuard: Bool = idx == BusRoutesCollection.count - 1
                        
                        var sourceVertex: Vertex = Vertex(vertexLabel: currentElement.BusStopCode)
                        
                        //MARK: GRAPH REPOSITORY (BUS STOPS TO BUS OPERATIONS)
                        let route = Route(busServiceNo: ServiceNo)
                        if busLookup[ServiceNo] == nil {
                            busLookup[ServiceNo] = route.id
                            GraphManager().createBus(busNumber: ServiceNo, id: route.id)
                        }
                        let retrievedCDBus = GraphManager().getCDBusLookup(id: busLookup[ServiceNo]!)
                    
                        //MARK: PRIME
                        var currentVertexPrime = Vertex(vertexLabel: sourceVertex.vertexLabel + "'")
                        currentVertexPrime.addEdge(from: currentVertexPrime, to: &sourceVertex, weight: 0, directed: false)
                        
                        //MARK: GRAPH REPOSITORY OPERATIONS
                        if idlookup[sourceVertex] == nil {
                            GraphManager().create(vertex: sourceVertex, id: sourceVertex.id)
                            idlookup[sourceVertex] = sourceVertex.id
                        }
                        
                        if idlookup[currentVertexPrime] == nil {
                            GraphManager().create(vertex: currentVertexPrime, id: currentVertexPrime.id)
                            idlookup[currentVertexPrime] = currentVertexPrime.id
                        }
                        
                        let retrieveCDVertex = GraphManager().getCDVertex(id: idlookup[sourceVertex]!)
                        guard retrieveCDVertex?.vertexLabel! == sourceVertex.vertexLabel else {
                            fatalError()
                        }
                        let retrieveCDVertexPrime = GraphManager().getCDVertex(id: idlookup[currentVertexPrime]!)
                        
                        //DIRECTED
                        GraphManager().addCDEdge(source: currentVertexPrime, destination: sourceVertex, edgeWeight: 0, busNumber: "", lookup: retrieveCDVertexPrime!)
                        GraphManager().addCDEdge(source: sourceVertex, destination: currentVertexPrime, edgeWeight: 0, busNumber: "", lookup: retrieveCDVertex!)
                        
                        
                        //MARK: NEAREST NEIGHBOUR OPERATION - KDTREE
                        let currentVertex = Vertex(vertexLabel: AlgorithmBook().AfterRemoveLast(string: currentVertexPrime.vertexLabel))
                        let latitude = self.CoordinateDict[currentVertex]?[0]
                        let longitude = self.CoordinateDict[currentVertex]?[1]
                        let tree = self.tree
                        
                        
                        if !combined.contains(currentVertexPrime) {
                        if let latitude = latitude {
                            if let longitude = longitude {
                        let currentNode = Node(title: currentVertex.vertexLabel, center: CLLocation(latitude: latitude, longitude: longitude))
                            
                                let pointsInRange: [Node] = tree.nearestK(10, to: currentNode)
                                for nodes in pointsInRange {
                                    
                                    var neighbour = Vertex(vertexLabel: nodes.title)
                                    guard neighbour.vertexLabel != currentVertexPrime.vertexLabel else { continue }
                                    let neighbourLookup = Vertex(vertexLabel: AlgorithmBook().AfterRemoveLast(string: neighbour.vertexLabel))
                                    let distance: Double? = self.returnHeuristicValue(current: currentVertex, end: neighbourLookup)
                                  
                    
                                    if let distance = distance {
                                        //if distance <= 250 {
                                        currentVertexPrime.addEdge(from: currentVertexPrime, to: &neighbour, weight: distance, directed: false)
                                            //print("Adding edge from \(currentVertexPrime) to \(neighbour). Distance is \(distance).")
                                        //}
                                        
                                        //MARK: GRAPH REPOSITORY
                                        GraphManager().addCDEdge(source: currentVertexPrime, destination: neighbour, edgeWeight: distance, busNumber: "", lookup: retrieveCDVertexPrime!)
                                        
                                        //MARK: PROTECTOR
                                        let edgeToCheck = Edge(source: currentVertexPrime, destination: neighbour, weight: distance, bus: "")
                                        guard retrieveCDVertexPrime!.convertToEdgeArray().contains(edgeToCheck) && currentVertexPrime.adjacencyList[currentVertexPrime]!.contains(edgeToCheck) else {
                                            fatalError("Culprit found")
                                        }
                                    }
                                    
                                    if nodes == pointsInRange[pointsInRange.count - 1] {
                                        combined.append(currentVertexPrime)
                                    }
                                }
                             }
                        }
                        }
                        
                        
                        //END OF PRIME
                        if lookup[currentElement.BusStopCode] == nil {
                        lookup[currentElement.BusStopCode] = sourceVertex
                        }
                        
                        if BusStopToBus[currentElement.BusStopCode] == nil {
                            BusStopToBus[currentElement.BusStopCode] = [ServiceNo]
                            
                            //MARK: TEST DELETE AFTER !
                            /*let id = UUID()
                            let test = GraphManager().createBus(busNumber: "69", id: id)
                            let testRetrieved = GraphManager().getCDBusLookup(id: id)
                            GraphManager().addCDBus(busNumber: "69", lookup: retrieveCDVertex!, busLookup: testRetrieved!)
                            print("This guy is training to lay the pipe: \(retrieveCDVertex!.convertToBusSet())")*/
                        } else {
                            BusStopToBus[currentElement.BusStopCode]!.insert(ServiceNo)
                        }
                        
                        //MARK: GRAPH REPOSITORY
                        GraphManager().addCDBus(busNumber: ServiceNo, lookup: retrieveCDVertex!, busLookup: retrievedCDBus!)
                        print("This guy is training to lay the pipe: \(retrieveCDVertex!.convertToBusSet())")
                        
                        //MARK: PROTECTOR
                        guard BusStopToBus[currentElement.BusStopCode]!.contains(ServiceNo) && retrieveCDVertex!.convertToBusSet().contains(ServiceNo) else {
                            fatalError("Culprit found")
                        }
                        guard BusStopToBus[currentElement.BusStopCode]!.count == retrieveCDVertex?.busSet.count else {
                            print("\(sourceVertex) : \(BusStopToBus[currentElement.BusStopCode]!)")
                            print("\(retrieveCDVertex!.vertexLabel) : \(retrieveCDVertex!.convertToBusSet())")
                            fatalError("Culprit found")
                        }
                        
                        if idx == BusRoutesCollection.count - 1 {
                            for (_, vertex) in lookup {
                                combined.append(vertex)
                                singular.append(vertex)
                            }
                        }
                        
                        guard !idxGuard else {
                            break
                        }
                        
                        let nextElement = BusRoutesCollection[idx+1]
                        let ServiceNoGuard: Bool = nextElement.ServiceNo == ServiceNo
                        let DirectionGuard: Bool = nextElement.Direction == Direction
                        
                        if !DirectionGuard || !ServiceNoGuard {
                            if Direction == 1 {
                            serviceNoToRoute[ServiceNo]!.route1.append(sourceVertex)
                                
                            //MARK: GRAPH REPOSITORY BUS OPERATION
                                GraphManager().addCDRoute(CDBusLookup: retrievedCDBus!, route1item: sourceVertex, route2item: nil, stopSequence: stopSequence)
                                
                            } else {
                            serviceNoToRoute[ServiceNo]!.route2.append(sourceVertex)
                                
                            //MARK: GRAPH REPOSITORY BUS OPERATION
                                GraphManager().addCDRoute(CDBusLookup: retrievedCDBus!, route1item: nil, route2item: sourceVertex, stopSequence: stopSequence)
                            }
                        }
                        
                        guard DirectionGuard && ServiceNoGuard else {
                            idx += 1
                            continue
                        }
                        
                        var edgeWeight: Double?
                        if let nextElementDistance = nextElement.Distance {
                            if let currentElementDistance = currentElement.Distance {
                        let foo = nextElementDistance - currentElementDistance
                                edgeWeight = foo
                            }
                        }
                        
                        guard edgeWeight != nil else {
                            idx += 1
                            continue
                        }
                        
                        guard edgeWeight! >= 0 else {
                            idx += 1
                            continue
                        }
                        
                        var destinationVertex: Vertex = Vertex(vertexLabel: nextElement.BusStopCode)
                        
                        lookup[sourceVertex.vertexLabel]!.addEdge(from: sourceVertex, to: &destinationVertex, weight: edgeWeight!, bus: ServiceNo)
                        
                        //MARK: GRAPH REPOSITORY
                        GraphManager().addCDEdge(source: sourceVertex, destination: destinationVertex, edgeWeight: edgeWeight!, busNumber: ServiceNo, lookup: retrieveCDVertex!)
                        
                        //MARK: PROTECTOR
                        let edgeToCheck = Edge(source: sourceVertex, destination: destinationVertex, weight: edgeWeight!, bus: ServiceNo)
                        guard retrieveCDVertex!.convertToEdgeArray().contains(edgeToCheck) && lookup[sourceVertex.vertexLabel]!.adjacencyList[sourceVertex]!.contains(edgeToCheck) else {
                            fatalError("Culprit found")
                        }
                        
                        
                        //MARK: ROUTE ATTEMPT 1
                                if serviceNoToRoute[ServiceNo] == nil { serviceNoToRoute[ServiceNo] = route }
                        if Direction == 1 {
                            serviceNoToRoute[ServiceNo]!.route1.append(sourceVertex)
                            
                            //MARK: GRAPH REPOSITORY BUS OPERATION
                            GraphManager().addCDRoute(CDBusLookup: retrievedCDBus!, route1item: sourceVertex, route2item: nil, stopSequence: stopSequence)
                        } else {
                            serviceNoToRoute[ServiceNo]!.route2.append(sourceVertex)
                            
                            //MARK: GRAPH REPOSITORY BUS OPERATION
                            GraphManager().addCDRoute(CDBusLookup: retrievedCDBus!, route1item: nil, route2item: sourceVertex, stopSequence: stopSequence)
                        }
                        //MARK: END OF ROUTE ATTEMPT 1
                        
                       //print("Stop Sequence: \(currentElement.StopSequence). Direction: \(currentElement.Direction). Service No: \(currentElement.ServiceNo). Adding edge from \(sourceVertex) to \(destinationVertex)")
                        
                        idx += 1
                        continue
                        
                        //END OF FOR LOOP
                }
            //MARK: END OF GENERATE VERTEX SET
        }
            let itemsNeeded = GraphManager().getAll()!
            combined = itemsNeeded.0
            BusStopToBus = itemsNeeded.1
            serviceNoToRoute = itemsNeeded.2
        
        
            //print("Before stores combined count: \(combined.count)")
        
            let vertexCollectionSorted = AlgorithmBook().mergeSort(forArray: combined)
            
            let invertedCollection = self.InvertEdges(array: vertexCollectionSorted)
            
            var graph = Dijkstra(vertexCollection: vertexCollectionSorted, invertedCollection: invertedCollection, name: "Completed Bus Network", BusStopsToBus: BusStopToBus)
            graph.routeDict = serviceNoToRoute
            let timerEnd: Double = CFAbsoluteTimeGetCurrent() - timerStart
            
            DispatchQueue.main.async {
                print("API2 took \(timerEnd) seconds")
                completion(graph, BusRoutesCollection, serviceNoToRoute)
            }
            
}
}



