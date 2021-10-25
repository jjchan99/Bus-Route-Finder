//
//  API3.swift
//  Networking App
//
//  Created by Jia Jie Chan on 18/5/21.
//

import Foundation
import CoreLocation

class API3: ObservableObject {
    
    static func makeRequest(completion: @escaping ([Vertex: [Double]], [Vertex: (String, String)],[Node]) -> ()) {
        //MARK: PLACEHOLDERS
        var CoordinateDictFoo: [Vertex: [Double]] = [:]
        var DescriptionDictFoo: [Vertex: (String, String)] = [:]
        var BusStopsCollectionFoo: BusStops = BusStops(odataMetadata: "", value: [])
        var NodeArrayFoo: [Node] = []
        
        DispatchQueue.global().async {
            
        let url = [Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=1000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=1500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=2000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=2500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=3000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=3500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=4000"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=4500"),
                   Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusStops?$skip=5000")]
        
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
        
        //Create task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if error == nil && data != nil {
                
                //Parse
                let decoder = JSONDecoder()
                
                do {
                   let loaded = try decoder.decode(BusStops.self, from: data!)
                    
                    for values in loaded.value {
                        BusStopsCollectionFoo.value.append(values)
                        BusStopsCollectionFoo.odataMetadata = loaded.odataMetadata
                }
                }
                catch {
                    //Log.queue(action: "❌ Fatal error in JSON Parsing (API3)")
                }
                
                group.leave()
            }
        }
            
            dataTask.resume()
            
            group.wait()
}
            
            Log.queue(action: "Attempting to generate dict...")
            Log.queue(action: "Populating Dict...")
        
                for elements in BusStopsCollectionFoo.value {
                 
                    let currentBusStopCode = elements.BusStopCode
                    let currentLatitude = elements.Latitude
                    let currentLongitude = elements.Longitude
                    
                    let currentRoadName = elements.RoadName
                    let currentDescription = elements.Description
                    
                    let currentVertex = Vertex(vertexLabel: currentBusStopCode)
                    
                        CoordinateDictFoo[currentVertex] = [currentLatitude, currentLongitude]
                        DescriptionDictFoo[currentVertex] = (currentRoadName, currentDescription)
                        //print("Vertex: \(currentVertex). X: \(currentLatitude). Y: \(currentLongitude) ")
                    
                    let node = Node(title: currentVertex.vertexLabel + "'", center: CLLocation(latitude: currentLatitude, longitude: currentLongitude))
                    NodeArrayFoo.append(node)
                }
            
    
            DispatchQueue.main.async {
            completion(CoordinateDictFoo, DescriptionDictFoo, NodeArrayFoo)
            Log.queue(action: "Successfully generated dict")
            }
            
              
                
}
}
}



