//
//  PlaceModel.swift
//  Networking App
//
//  Created by Jia Jie Chan on 2/7/21.
//

import Foundation
import MapKit

struct Place: Identifiable {
    var id = UUID().uuidString
    var place: CLPlacemark
}
