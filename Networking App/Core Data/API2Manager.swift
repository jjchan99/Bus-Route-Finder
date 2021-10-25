//
//  BusRoutesManager.swift
//  Networking App
//
//  Created by Jia Jie Chan on 15/7/21.
//

import Foundation
import CoreData
import SwiftUI

struct API2Manager {
    private let _BusRoutesRepository = BusRoutesDataRepository()
    
    func createBusRoute(busRoutes: BusRoutes) {
        _BusRoutesRepository.create(busRoutes: busRoutes)
    }
    
    func fetchBusRoute() -> [BusRoutes]? {
        return _BusRoutesRepository.getAll()
    }
    
    func updateBusRoutes(busRoutes: BusRoutes) -> Bool {
        return _BusRoutesRepository.update(busRoutes: busRoutes)
    }
    
    func deleteBusRoutes(busRoutes: BusRoutes) -> Bool {
        return _BusRoutesRepository.delete(busRoutes: busRoutes)
    }
    
    func fetchBusRoute(byIdentifier id: UUID) -> BusRoutes? {
        return _BusRoutesRepository.get(byIdentifier: id)
    }
    
    func deleteAll() {
        return _BusRoutesRepository.deleteAll()
    }
}

