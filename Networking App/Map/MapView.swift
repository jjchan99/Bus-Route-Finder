//
//  MapView.swift
//  Networking App
//
//  Created by Jia Jie Chan on 1/5/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let group = DispatchGroup()
    let group2 = DispatchGroup()
    
    @EnvironmentObject var viewModel: MapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let view = viewModel.mapView
        
        view.delegate = context.coordinator
      
      //  view.setRegion(viewModel.region, animated: true)
        view.showsUserLocation = true
        view.userTrackingMode = .follow
     
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        
        let status = locationManager.authorizationStatus
                
        /*if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Authorization granted")
              
            if let location = locationManager.location?.coordinate {
                let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
                let region = MKCoordinateRegion(center: location, span: span)
                view.setRegion(region, animated: true)
                viewModel.userCoordinates = CLLocationCoordinate2D(latitude: view.userLocation.coordinate.latitude, longitude: view.userLocation.coordinate.longitude)
                print("user coordinates are: \(viewModel.userCoordinates)")
            } else {
                print("location failed LOL")
            }
        }*/
        
        return view
    }
    
    var locationManager = CLLocationManager()
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
    
class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var centerLocationOnce: Bool = true
    
        init(_ parent: MapView) {
            self.parent = parent
        }

    var UIColorArray: [UIColor] {
        var foo: [UIColor] = []
        let colors = [UIColor.systemYellow, UIColor.systemGreen, UIColor.systemTeal, UIColor.systemPink, UIColor.systemPurple]
        var currentIdx = 0
        var counter = 0
        while counter <= 100 {
            if currentIdx == 4 {
                currentIdx = 0
            }
            foo.append(colors[currentIdx])
            currentIdx += 1
            counter += 1
        }
        return foo
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if centerLocationOnce {
            let latDelta: CLLocationDegrees = 0.009
            let lonDelta: CLLocationDegrees = 0.009
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            print("user location: \(userLocation.coordinate)")
            centerLocationOnce = false
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) { return nil }
        else {
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
        pinAnnotation.tintColor = .systemRed
        pinAnnotation.animatesDrop = true
        pinAnnotation.canShowCallout = true
        return pinAnnotation
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            
        if overlay is MKPolyline {
           
            for (key, value) in Shared.instance.routePolyline {
    
                var pair: [Set<String>: Int] = [:]
                for idx in 0..<key.count {
                    pair[key] = idx+1
                }
                for polylines in value {
                if overlay as? MKPolyline == polylines {
                    let renderer = MKPolylineRenderer(overlay: overlay)
                    renderer.strokeColor = UIColorArray[pair[key] ?? 69]
                    renderer.lineWidth = 5
                    return renderer
                }
            }
        }
        }
        
        if overlay is MKCircle {
        for (key, value) in Shared.instance.circleOverlay {
            var pair: [Set<String>: Int] = [:]
            for idx in 0..<key.count {
                pair[key] = idx+1
            }
            for circles in value {
                let renderer = MKCircleRenderer(overlay: overlay)
                if overlay as? MKCircle == circles {
                    renderer.lineWidth = 20.0
                    renderer.strokeStart = 20.0
                    renderer.strokeEnd = 20.0
                    renderer.fillColor = UIColorArray[pair[key] ?? 69]
                    renderer.strokeColor = UIColorArray[pair[key] ?? 69]
                    return renderer
                }
            }
        }
        }
        
        let renderer = MKOverlayRenderer()
        return renderer
    }
}










