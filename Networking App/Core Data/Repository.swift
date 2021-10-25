//
//  Repository.swift
//  Networking App
//
//  Created by Jia Jie Chan on 14/7/21.
//

import Foundation
import SwiftUI
import CoreData

protocol BusRoutesRepository {
    func create(busRoutes: BusRoutes)
    func getAll() -> [BusRoutes]?
    func get(byIdentifier id: UUID) -> BusRoutes?
    func update(busRoutes: BusRoutes) -> Bool
    func delete(busRoutes: BusRoutes) -> Bool
    func deleteAll()
}

struct BusRoutesDataRepository: BusRoutesRepository {
    
    let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    func getAll() -> [BusRoutes]? {
        let result = PersistenceController.shared.fetchManagedObject(managedObject: CDBusRoutes.self)
        
        var BusRoutes: [BusRoutes] = []
        result?.forEach { value in
            BusRoutes.append(value.convertToBusRoutes())
        }
        
        return BusRoutes
    }
    
    func get(byIdentifier id: UUID) -> BusRoutes? {
        let result = getCDBusRoute(byIdentifier: id)
        guard result != nil else { return nil }
        return result?.convertToBusRoutes()
    }
    
    func update(busRoutes: BusRoutes) -> Bool {
        let result = getCDBusRoute(byIdentifier: busRoutes.id)
        guard result != nil else { return false }
        result?.busStopCode = busRoutes.BusStopCode
        result?.direction = Int64(busRoutes.Direction)
        result?.stopSequence = Int64(busRoutes.StopSequence)
        result?.distance = busRoutes.Distance ?? 0
        result?.opr = busRoutes.Operator
        result?.serviceNo = busRoutes.ServiceNo
        result?.wdFirstBus = busRoutes.WD_FirstBus
        result?.wdLastBus = busRoutes.WD_LastBus
        result?.satFirstBus = busRoutes.SAT_FirstBus
        result?.satLastBus = busRoutes.SAT_LastBus
        result?.sunFirstBus = busRoutes.SUN_FirstBus
        result?.sunLastBus = busRoutes.SUN_LastBus
        do {
        try context.save()
        } catch {
        print("OH HE CAN HIT ONE!")
        }
        return true
    }
    
    func delete(busRoutes: BusRoutes) -> Bool {
        let cdBusRoutes = getCDBusRoute(byIdentifier: busRoutes.id)
        guard cdBusRoutes != nil else { return false }
        context.delete(cdBusRoutes!)
        return true
    }
    
    private func getCDBusRoute(byIdentifier id: UUID) -> CDBusRoutes? {
        let fetchRequest = NSFetchRequest<CDBusRoutes>(entityName: "CDBusRoutes")
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)
        fetchRequest.predicate = predicate
        do {
            let result = try context.fetch(fetchRequest).first
            guard result != nil else { return nil }
            return result
        } catch let error {
            print(error)
            return nil
        }
    }
    
    func create(busRoutes: BusRoutes) {
        let a = CDBusRoutes(context: context)
        a.id = busRoutes.id
        a.busStopCode = busRoutes.BusStopCode
        a.direction = Int64(busRoutes.Direction)
        a.distance = busRoutes.Distance ?? 0
        a.serviceNo = busRoutes.ServiceNo
        a.stopSequence = Int64(busRoutes.StopSequence)
        a.opr = String(busRoutes.Operator)
        a.wdFirstBus = String(busRoutes.WD_FirstBus)
        a.wdLastBus = String(busRoutes.WD_LastBus)
        a.satFirstBus = String(busRoutes.SAT_FirstBus)
        a.satLastBus = String(busRoutes.SAT_LastBus)
        a.sunFirstBus = String(busRoutes.SUN_FirstBus)
        a.sunLastBus = String(busRoutes.SUN_LastBus)
        
        PersistenceController.shared.saveContext()
    }
    
    func deleteAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CDBusRoutes")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch let error {
            print("\(error)")
        }
    }
}

