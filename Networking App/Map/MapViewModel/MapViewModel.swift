//
//  MapViewModel.swift
//  Networking App
//
//  Created by Jia Jie Chan on 23/5/21.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation
import StepperView

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    @Published var polylineArray: [MKPolyline] = []
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 1.364917, longitude: 103.822872), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    @Published var mapType: MKMapType = .standard
    
     
    @Published var BusAnnotations: [BusStopAnnotation] = []
    @Published var userCoordinates: CLLocationCoordinate2D?
    @Published var destinationCoordinates: CLLocationCoordinate2D?
    @Published var startCoordinates: CLLocationCoordinate2D?
    @Published var startBusStop: String = ""
    
    //MARK: API2 PROPERTIES
    @FetchRequest(entity: CDBusRoutes.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \CDBusRoutes.busStopCode, ascending: true)]) var fetchedAPI2 : FetchedResults<CDBusRoutes>
    @Environment(\.managedObjectContext) var context
    @Published var BusRoutesCollection: [BusRoutes] = []
    
    //MARK: DIJKSTRA PROPERTIES:
    @Published var CoordinateDict: [Vertex: [Double]] = [:]
    @Published var tree = KDTree<Node>(values: [])
    @Published var cachedGraph: Dijkstra = Dijkstra(vertexCollection: [], invertedCollection: [], name: "Uninitialized", BusStopsToBus: [:])
    @Published var DescriptionDict: [Vertex: (String, String)] = [:]
    @Published var routeDict: [String: Route] = [:]
 
    //MARK: SEARCH PROPERTIES - END
    @Published var searchText: String = ""
    @Published var placeSelected: Bool = false
    @Published var selectedPlace: String = ""
    @Published var places: [Place] = []
    
    //MARK: SEARCH PROPERTIES - START
    @Published var searchTextStart: String = ""
    @Published var placeSelectedStart: Bool = false
    @Published var selectedPlaceStart: String = ""
    @Published var placesStart: [Place] = []
    
    //MARK: STEPPER PROPERTIES
    @Published var testText = [Text("Welcome")]
    @Published var text: [Int: [Text]] = [:]
    @Published var BusOptions: [Int: [String]] = [:]
    @Published var indicationTypes = [StepperIndicationType.custom(CircledIconView(image: Image(systemName: "circle.fill"), width: 10, strokeColor: Color.red))]
    @Published var pitStops: [AnyView] = []
    @Published var titleWave: [Int: (String, String)] = [:]
    
    //MARK: METHODS
    internal func searchQuery(type: Int) {
        places.removeAll()
        selectedPlace = ""
        Log.queue(action: "Search performed")
        let request = MKLocalSearch.Request()
        if type == 1 {
        request.naturalLanguageQuery = searchText
        } else {
        request.naturalLanguageQuery = searchTextStart
        }
        print(searchText)
        
        MKLocalSearch(request: request).start { (response, _) in
            
            guard let result = response else {
                print("no response")
                return }
            
            if type == 0 {
            self.placesStart = result.mapItems.compactMap({ (item) -> Place? in
                Log.queue(action: "places returned")
                return Place(place: item.placemark)
            })}
            else {
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                Log.queue(action: "places returned")
                return Place(place: item.placemark)
            })
            }
        }
    }
    
    internal func selectPlace(place: Place, type: Int) {
        
        //MARK: RESET STATE
        DispatchQueue.main.async {
        self.text = [:]
        self.indicationTypes = []
        self.BusOptions = [:]
        self.titleWave = [:]
        }
        
        Log.queue(action: "selected place")
        
        guard let coordinate = place.place.location?.coordinate else { return }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = place.place.name ?? "No Name"
        
        if type == 0 {
        mapView.removeAnnotations(mapView.annotations)
        }
        
        mapView.addAnnotation(pointAnnotation)
        
        guard let coordinate = place.place.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        Log.queue(action: "coordinate for selected place retrieved")
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        
        if type == 1 {
            self.destinationCoordinates = coordinate
            placeSelected = true
            selectedPlace = place.place.name!
            searchText = place.place.name!
        } else {
            self.startCoordinates = coordinate
            placeSelectedStart = true
            selectedPlaceStart = place.place.name!
            searchTextStart = place.place.name!
        }
    }
    
    internal func focusLocation() {
        guard let _ = userCoordinates else { return }
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
    
    internal func nearestBusStopsStart() -> [String] {
        var stringArray: [String] = []
    
        let queryPoint = CLLocation(latitude: self.startCoordinates!.latitude, longitude: self.startCoordinates!.longitude)
        let queryNode = Node(title: "queryPoint", center: queryPoint)
        let pointsInRange: [Node] = tree.nearestK(10, to: queryNode)
            
            for nodes in pointsInRange {
                if nodes.title.contains("'") {
                    stringArray.append(AlgorithmBook().AfterRemoveLast(string: nodes.title))
                } else {
                    stringArray.append(nodes.title)
                }
            }
        self.startBusStop = stringArray[0]
        return stringArray
    }
    
    internal func nearestBusStops() -> [String]? {
        
        var closestBusStop: Node?
        var distanceToBeat: Double = Double.infinity
        var stringArray: [String] = []
       
        let startLatitude = CoordinateDict[Vertex(vertexLabel: self.startBusStop)]![0]
        let startLongitude = CoordinateDict[Vertex(vertexLabel: self.startBusStop)]![1]
        let start = CLLocation(latitude: startLatitude, longitude: startLongitude)
        
        let destination = CLLocation(latitude: destinationCoordinates!.latitude, longitude: destinationCoordinates!.longitude)
        let destinationNode = Node(title: "destination", center: destination)
        let pointsInRange: [Node] = tree.nearestK(10, to: destinationNode)
            
            for nodes in pointsInRange {
            let busNodes = nodes.center
            let distance = start.distance(from: busNodes)
                if distance < distanceToBeat {
                    distanceToBeat = distance
                    closestBusStop = nodes
                }
            //print("distance is \(distance)")
                if nodes.title.contains("'") {
                    stringArray.append(AlgorithmBook().AfterRemoveLast(string: nodes.title))
                } else {
                    stringArray.append(nodes.title)
                }
            }
        
        print("closest bus stop to destination is \(closestBusStop!.title), which is \(distanceToBeat) meters away.")
        
        return (stringArray)
    }
    
    
    
     internal func addRoute(start: String, end: [String], completion: @escaping (Bool) -> ()) {
         let group = DispatchGroup()
         
         Log.queue(action: "addRoute()")
         
         //MARK: REMOVING OVERLAYS
         for (key, value) in Shared.instance.routePolyline {
         self.mapView.removeOverlays(value)
         self.mapView.removeOverlays(Shared.instance.circleOverlay[key]!)
         }
         
         Shared.instance.routePolyline = [:]
         Shared.instance.circleOverlay = [:]
         
         DispatchQueue.global().async {
         Log.queue(action: "Adding route to map view")
             
     //MARK: PROPERTIES
     var pointsToUse: [Set<String>: [CLLocationCoordinate2D]] = [:]
     var annotations: [BusStopAnnotation] = []
     var polylineArray: [MKPolyline] = []
     var placemarks: [Set<String>: [MKMapItem]] = [:]
     let polylineDict: [Set<String>: [MKPolyline]] = [:]
     var transferIndex: Int = 0
             
     var myRoute : MKRoute?
     let directionsRequest = MKDirections.Request()
     
     directionsRequest.transportType = MKDirectionsTransportType.automobile
        
         
        
             
         //MARK: RECURSIVE TRAVERSAL
         var idx: Int = 0
         var result: [(Set<String>, Vertex)] = []
         func recurse(status: Bool) -> Bool {
             if status {
                 DispatchQueue.main.async {
                     group.leave()
                 }
                     return true
             } else {
                     Log.queue(action: "attempting another run")
                     idx += 1
                     let trialRun: (Bool, [(Set<String>, Vertex)]) = self.traverseOnGraph(start: start, end: end[idx])
                     result = trialRun.1
                     if idx == end.count - 1 { return true }
                     return recurse(status: trialRun.0)
             }
         }
             
             group.enter()
             if idx == 0 {
                 let preTrialRun = self.traverseOnGraph(start: start, end: end[idx])
                 result = preTrialRun.1
                 recurse(status: preTrialRun.0)
             }
             
         //MARK: END OF RECURSION
             
             
         //MARK: SECOND HALF UI UPDATES
         group.wait()
         
         guard result.count >= 0 else { return }
        
         for idx in 0..<result.count {
         let vertex = result[idx].1
             if vertex.vertexLabel.contains("'") {
               continue
             }
             if let latitude = self.CoordinateDict[vertex]?[0] {
                 if let longitude = self.CoordinateDict[vertex]?[1] {
                 let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                 
                     let description = self.DescriptionDict[vertex]?.1
                 let busSet = result[idx].0
                 var nextBusSet: Set<String> {
                     if idx != result.count - 1 {
                         return result[idx+1].0
                     }
                     return busSet
                 }
                 
                 //MARK: EVALUATION PROPERTIES
                 let setIntersectionEvaluation: Bool = !busSet.isDisjoint(with: nextBusSet)
                 let intersectedBusNumbers: Set<String> = busSet.intersection(nextBusSet)
                 let evaluation: Bool = busSet != nextBusSet
                 
                 
                 let placemark = MKPlacemark(coordinate: coordinates)
                 let source = MKMapItem(placemark: placemark)
             
                
                 if evaluation {
                     pointsToUse[nextBusSet] = [coordinates]
                     placemarks[nextBusSet] = [source]
                 }
                 
                 pointsToUse[busSet] == nil ? pointsToUse[busSet] = [coordinates] : pointsToUse[busSet]!.append(coordinates)
                 placemarks[busSet] == nil ? placemarks[busSet] = [source] : placemarks[busSet]!.append(source)
                 
                 //MARK: ADD TO STEPPER VIEWS
                 let pitStop = TextView(text:description!).eraseToAnyView()
                 let textToAppend = Text("\(description!) - \(vertex.vertexLabel)")
                 let indicationType = StepperIndicationType.custom(CircledIconView(image: Image(systemName: "bus"), width: 5, strokeColor: Color.red))
                    
                    //MARK: TRANSFER INDEX UPDATE CONDITION
                    if intersectedBusNumbers.count == 0 && idx != 0 && busSet != [""] {
                        DispatchQueue.main.async {
                        transferIndex += 1
                        self.text[transferIndex - 1]!.append(textToAppend)
                      }
                    }
                 
                 if idx != 0 {
                
                 DispatchQueue.main.async {
                     if self.text[transferIndex] == nil { self.text[transferIndex] = [textToAppend] } else { self.text[transferIndex]!.append(textToAppend) }
                     
                     self.pitStops.append(pitStop)
                     
                     self.indicationTypes.append(indicationType)
                     print("""
                         DEBUG SELF.TEXT: \(self.text.count)
                         DEBUG SELF.BUSOPTIONS: \(self.BusOptions.count)
                      """)
                     
                     //MARK: BUS OPTIONS UPDATE
                     if intersectedBusNumbers.count > 0 || self.BusOptions[transferIndex] == nil {
                         if intersectedBusNumbers.count == 0 {
                             self.BusOptions[transferIndex] = nextBusSet.sorted()
                         } else {
                         self.BusOptions[transferIndex] = intersectedBusNumbers.sorted()
                         }
                     }
                     
                     //MARK: TITLE WAVE UPDATE
                     if self.titleWave[transferIndex] == nil {
                         self.titleWave[transferIndex] = (vertex.vertexLabel, description ?? "NIL")
                     }
                 }
                     //MARK: ANNOTATIONS
                     annotations.append(BusStopAnnotation(title: description, subtitle: vertex.vertexLabel, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
                 
                 } else {
                     if !nextBusSet.contains("") {
                         DispatchQueue.main.async {
                 
                             if self.text[transferIndex] == nil { self.text[transferIndex] = [textToAppend] } else { self.text[transferIndex]!.append(textToAppend) }
                             
                             self.pitStops.append(pitStop)
                             self.indicationTypes.append(indicationType)
                             
                             
                             //MARK: ANNOTATIONS
                             annotations.append(BusStopAnnotation(title: description, subtitle: vertex.vertexLabel, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)))
                             
                             //MARK: BUS OPTIONS UPDATE
                             if intersectedBusNumbers.count > 0 || self.BusOptions[transferIndex] == nil {
                                     self.BusOptions[transferIndex] = nextBusSet.sorted()
                             }
                             
                             //MARK: TITLE WAVE UPDATE
                             if self.titleWave[transferIndex] == nil {
                                 self.titleWave[transferIndex] = (vertex.vertexLabel, description ?? "NIL")
                             }
                         }
                     }
                 }
                 
                 
              
                 //MARK: END OF STEPPER VIEWS
                 
               
                 
                 if idx == result.count - 1 {
                     let circle = MKCircle(center: coordinates, radius: 15)
                     
                     Shared.instance.circleOverlay[busSet] == nil ? Shared.instance.circleOverlay[busSet] = [circle] : Shared.instance.circleOverlay[busSet]!.append(circle)
                     
                     DispatchQueue.main.async {
                     self.mapView.addOverlay(circle)
                     }
                 }
                 
                 //MARK: GETTING ROUTE
                 if idx != result.count - 1 {
                 var destination: MKMapItem? {
                     var foo: MKMapItem?
                     let destinationVertex = result[idx+1].1
                     if let latitude = self.CoordinateDict[destinationVertex]?[0] {
                         if let longitude = self.CoordinateDict[destinationVertex]?[1] {
                             let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                             let placemark = MKPlacemark(coordinate: coordinates)
                             let destination: MKMapItem = MKMapItem(placemark: placemark)
                             foo = destination
                         }
                     }
                     return foo
                 }
                 directionsRequest.source = source
                 directionsRequest.destination = destination
              let directions = MKDirections(request: directionsRequest)
              directions.calculate { response, error in
                   if error == nil {
                      myRoute = response?.routes[0]
                      let polyline = myRoute?.polyline as! MKPolyline
                      let MKCircle = MKCircle(center: coordinates, radius: 15.0)
                    
                     if busSet.contains("start") {
                         Shared.instance.routePolyline[nextBusSet] = [polyline]
                         Shared.instance.circleOverlay[nextBusSet] = [MKCircle]
                     }
                     
                     if !busSet.contains("start") {
                     Shared.instance.routePolyline[busSet] == nil ?  Shared.instance.routePolyline[busSet] = [polyline] :  Shared.instance.routePolyline[busSet]!.append(polyline)
                         
                         Shared.instance.circleOverlay[busSet] == nil ? Shared.instance.circleOverlay[busSet] = [MKCircle] : Shared.instance.circleOverlay[busSet]!.append(MKCircle)
                     }
                    
                     DispatchQueue.main.async {
                     self.mapView.addOverlay(MKCircle)
                     self.mapView.addOverlay(polyline)
                     }
                     
                     print("polylineDict: \(Shared.instance.routePolyline)")
                   } else {
                      print("check this error: \(error)")
                   }
              }
             }
             //MARK: END OF GETTING ROUTE
         }
         }
         }
          
             
             
         //MARK: MISC + CLEANUP FUNCTIONS
         guard pointsToUse.count > 0 else {
             return
         }
             
         for (key, value) in pointsToUse {
                 let polyline = MKPolyline(coordinates: value, count: value.count)
                 print("Polyline with: \(key), \(value)")
                 polylineArray.append(polyline)
         }
             
         DispatchQueue.main.async {
             Shared.instance.polylineArray = polylineArray
             Shared.instance.routePolyline = polylineDict
             Shared.instance.directions = annotations
             completion(true)
         }
     }
 }
    
    internal func WithinRange(vertex1: Vertex, vertex2: Vertex, threshold: Double) -> (Bool, Double) {
        var distance: Double = self.returnHeuristicValue(current: vertex1, end: vertex2)
        return (distance <= threshold, distance)
    }
    
    internal func returnHeuristicValue(current: Vertex, end: Vertex) -> Double {
              
               guard !CoordinateDict.isEmpty else {
                    fatalError("Tried to return hValue before Coordinate Dict populated")
                }
                
                let currentLocation = CLLocation(latitude: CoordinateDict[current]?[0] ?? 0, longitude: CoordinateDict[current]?[1] ?? 0)
                
                let targetLocation = CLLocation(latitude: CoordinateDict[end]?[0] ?? 0, longitude: CoordinateDict[end]?[1] ?? 0)
                
                let distance = currentLocation.distance(from: targetLocation)
                
            return distance
    }
   
    internal func traverseOnGraph(start: String, end: String) -> (Bool, [(Set<String>, Vertex)]) {
        let timerStart: Double = CFAbsoluteTimeGetCurrent()
        
        //MARK: BUS ARRIVALS CALL
        let placeholderDate = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        let currentDate = formatter.string(from: placeholderDate)
        print(currentDate)
        
        self.getBusArrivals(busStopCode: start) { value in
            for items in value.Services {
                let serviceNo = items.ServiceNo
                let arrivalData = items.NextBus.CustomEstimatedArrival
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                let arrivalDate = dateFormatter.date(from: arrivalData)!
                print(arrivalDate)
                print(currentDate)
            }
        }

        var graph = cachedGraph
        
        //print("DEBUG GRAPH COUNT: \(graph.myHeap[0].elements.count)")
        //print("first: \(graph.myHeap[0].elements.count)")
        
       
        Log.queue(action: "❗attempting to traverse...")

        guard graph.myHeap[0].elements.count != 0 else {
            fatalError("⚠️ failed to traverse")
        }
        
        var retrievedIdx = AlgorithmBook().BinarySearch(sortedArray: graph.myHeap[0].elements, for: start)
        var retrievedIdxEnd = AlgorithmBook().BinarySearch(sortedArray: graph.myHeap[0].elements, for: end)
        
        guard retrievedIdx != nil && retrievedIdxEnd != nil else { fatalError("why is the element not in the graph lol")}
        
        let startVertex = graph.myHeap[0].elements[retrievedIdx!]
        let endVertex = graph.myHeap[0].elements[retrievedIdxEnd!]
        
        print("start: \(startVertex), end: \(endVertex)")
            
                var startAStarScore0: Double = 0
                var startAStarScore1: Double = 0
        
        var hValueGenesis: Double = self.returnHeuristicValue(current: startVertex, end: endVertex)
        
        graph.hValueGenesis = hValueGenesis
        
        //MARK: SET hValue
        
            
        guard CoordinateDict.keys.count != 0 else {
                fatalError("The coordinate dict hasn't populated")
            }
            Log.queue(action: "Calculating hValue...")
                
        var updateCount: Int = 0
                    
        var currentIdx = 0
        
        for vertices in graph.myHeap[0].elements {
            
                let label = vertices.vertexLabel.contains("'") ? AlgorithmBook().AfterRemoveLast(string: vertices.vertexLabel) : String(vertices)
                let fromVertex = Vertex(vertexLabel: label)
            
                updateCount += 1
            let hValue0: Double = self.returnHeuristicValue(current: fromVertex, end: endVertex)
                    
                if String(vertices) == start {
                    startAStarScore0 = hValue0
                }
            
                updateCount += 1
            
            let hValue1: Double = self.returnHeuristicValue(current: fromVertex, end: startVertex)
          
                
                if String(vertices) == end {
                    startAStarScore1 = hValue1
                }
            
            graph.hValueDict[0][vertices] = hValue0
            graph.hValueDict[1][vertices] = hValue1
                
            if hValue0 <= (hValueGenesis + 20) && hValue1 <= (hValueGenesis + 20) {
                
                print("""
                    vertices: \(vertices). Genesis guard for hValue0: \(hValue0)
                    vertices: \(vertices). Genesis guard for hValue1: \(hValue1)
                 """)
                currentIdx += 1
                
                //MARK: HVALUEDICT PREP
                
                var fooStart = Set<String>()
                var fooEnd =  Set<String>()
                fooStart.insert("start")
                fooEnd.insert("end")
                
                graph.valueTable[0][vertices] = Double.infinity
                graph.smartBook[0][vertices] = [(fooStart, startVertex)]
                
                graph.valueTable[1][vertices] = Double.infinity
                graph.smartBook[1][vertices] = [(fooEnd, endVertex)]
                graph.smartBookFlick1[vertices] = [(fooEnd, endVertex)]
                
                //MARK: - POPULATE DVDICT AND ASTARSCORE DICT
                graph.myHeap[0].dvDict[vertices] = Double.infinity
                graph.myHeap[0].aStarScoreDict[vertices] = Double.infinity
                graph.myHeap[1].dvDict[vertices] = Double.infinity
                graph.myHeap[1].aStarScoreDict[vertices] = Double.infinity
                
            } else {
                graph.myHeap[0].elements.remove(at: currentIdx)
                graph.myHeap[1].elements.remove(at: currentIdx)
            }
        }
        
                //********End of set hValue**********
        print("hValue updated \(updateCount) times")
        
        retrievedIdx = AlgorithmBook().BinarySearch(sortedArray: graph.myHeap[0].elements, for: start)
        retrievedIdxEnd =  AlgorithmBook().BinarySearch(sortedArray: graph.myHeap[0].elements, for: end)
        
        print("Should be equal: \(start) = \(graph.myHeap[0].elements[retrievedIdx!])")
        print("Should be equal: \(end) = \(graph.myHeap[0].elements[retrievedIdxEnd!])")
        
        graph.myHeap[0].dvDict[startVertex] = 0
        graph.myHeap[0].aStarScoreDict[startVertex] = startAStarScore0
        
        if retrievedIdx != 0 {
                graph.myHeap[0].elements.swapAt(0, retrievedIdx!)
        }
        
                graph.myHeap[1].aStarScoreDict[endVertex] = startAStarScore1
                graph.myHeap[1].dvDict[endVertex] = 0
        if retrievedIdxEnd != 0 {
                graph.myHeap[1].elements.swapAt(0, retrievedIdxEnd!)
        }
        
            Log.queue(action: "❗ Traversal starting...")
            //let timerStart: Double = CFAbsoluteTimeGetCurrent()
        
            let success = graph.traverse(start: startVertex, end: endVertex)
            if success == false {
                Log.queue(action: "FAILED!")
                return (success, []) }
        
            let timerEnd = CFAbsoluteTimeGetCurrent() - timerStart
            print("viewModel Traversal took \(timerEnd) seconds")
            
        Log.queue(action: "SUCCESS!")
        let output = graph.output
        
        return (success, output ?? [])
    }
    
    
     
    
    
    
}






    

