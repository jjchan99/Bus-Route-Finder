//
//  Route Model.swift
//  Networking App
//
//  Created by Jia Jie Chan on 17/7/21.
//

import Foundation

struct Route: Identifiable {
    init(busServiceNo: String) {
        self.busServiceNo = busServiceNo
    }
    
    let id = UUID()
    
    var busServiceNo: String
    var route1: [Vertex] = []
    var route2: [Vertex] = []
}
