//
//  Shared.swift
//  Networking App
//
//  Created by Jia Jie Chan on 5/7/21.
//

import Foundation
import MapKit

class Shared {
        private init() {}
        static let instance = Shared()
        var polylineArray: [MKPolyline] = []
        var routePolyline: [Set<String>: [MKPolyline]] = [:]
        var circleOverlay: [Set<String>: [MKCircle]] = [:]
        var directions: [BusStopAnnotation] = []
        var places: [Place] = []
}
