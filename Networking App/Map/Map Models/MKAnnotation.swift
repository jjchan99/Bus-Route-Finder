//
//  MKAnnotationViewModel.swift
//  Networking App
//
//  Created by Jia Jie Chan on 22/5/21.
//

import Foundation
import MapKit

class BusStopAnnotation: NSObject, MKAnnotation {
    
    var id = UUID().uuidString
    
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
    
}
