//
//  BusStopsModel.swift
//  Networking App
//
//  Created by Jia Jie Chan on 18/5/21.
//

import Foundation

struct BusStops: Codable, Identifiable {
    
    let id = UUID()

    var odataMetadata: String
    var value: [value]
    
    //"odata.metadata": "http://datamall2.mytransport.sg/ltaodataservice/$metadataBusRoutes"
    
    private enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case value
    }
    
    struct value: Codable, Identifiable {
        
        let id = UUID()
        
        var BusStopCode: String
        var RoadName: String
        var Description: String
        var Latitude: Double
        var Longitude: Double
    }

   
}


