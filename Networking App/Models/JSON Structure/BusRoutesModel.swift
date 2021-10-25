//
//  Loading Data Model.swift
//  Networking App
//
//  Created by Jia Jie Chan on 30/4/21.
//

import Foundation

    
struct Disposable: Codable, Identifiable {
        
        let id = UUID()

        var odataMetadata: String
        var value: [BusRoutes]
        
        //"odata.metadata": "http://datamall2.mytransport.sg/ltaodataservice/$metadataBusRoutes"
        
        private enum CodingKeys: String, CodingKey {
            case odataMetadata = "odata.metadata"
            case value
        }
}

struct BusRoutes: Codable, Identifiable {
    
    init(ServiceNo: String, Operator: String, Direction: Int, StopSequence: Int, BusStopCode: String, Distance: Double? = nil, WD_FirstBus: String, WD_LastBus: String, SAT_FirstBus: String, SAT_LastBus: String, SUN_FirstBus: String, SUN_LastBus: String) {
        self.ServiceNo = ServiceNo
        self.Operator = Operator
        self.Direction = Direction
        self.StopSequence = StopSequence
        self.BusStopCode = BusStopCode
        self.Distance = Distance
        self.WD_FirstBus = WD_FirstBus
        self.WD_LastBus = WD_LastBus
        self.SAT_FirstBus = SAT_FirstBus
        self.SAT_LastBus = SAT_LastBus
        self.SUN_FirstBus = SUN_FirstBus
        self.SUN_LastBus = SUN_LastBus
    }
    
    let id = UUID()
    
    var ServiceNo: String
    var Operator: String
    var Direction: Int
    var StopSequence: Int
    var BusStopCode: String
    var Distance: Double? = nil
    var WD_FirstBus: String
    var WD_LastBus: String
    var SAT_FirstBus: String
    var SAT_LastBus: String
    var SUN_FirstBus: String
    var SUN_LastBus: String
}
        
        



