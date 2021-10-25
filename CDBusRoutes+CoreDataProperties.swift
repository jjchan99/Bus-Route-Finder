//
//  API2Stored+CoreDataProperties.swift
//  Networking App
//
//  Created by Jia Jie Chan on 14/7/21.
//
//

import Foundation
import CoreData


extension CDBusRoutes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBusRoutes> {
        return NSFetchRequest<CDBusRoutes>(entityName: "CDBusRoutes")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var busStopCode: String?
    @NSManaged public var direction: Int64
    @NSManaged public var distance: Double
    @NSManaged public var serviceNo: String?
    @NSManaged public var stopSequence: Int64
    @NSManaged public var opr: String?
    @NSManaged public var wdFirstBus: String?
    @NSManaged public var wdLastBus: String?
    @NSManaged public var satFirstBus: String?
    @NSManaged public var satLastBus: String?
    @NSManaged public var sunFirstBus: String?
    @NSManaged public var sunLastBus: String?
    
    func convertToBusRoutes() -> BusRoutes {
        let busRoute = BusRoutes(ServiceNo: self.serviceNo!, Operator: self.opr!, Direction: Int(self.direction), StopSequence: Int(self.stopSequence), BusStopCode: self.busStopCode!, Distance: self.distance, WD_FirstBus: self.wdFirstBus!, WD_LastBus: self.wdLastBus!, SAT_FirstBus: self.satFirstBus!, SAT_LastBus: self.satLastBus!, SUN_FirstBus: self.sunFirstBus!, SUN_LastBus: self.sunLastBus!)
        return busRoute
    }
}

extension CDBusRoutes : Identifiable {

}
