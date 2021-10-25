//
//  BusArrivalsModel.swift
//  Networking App
//
//  Created by Jia Jie Chan on 5/8/21.
//

import Foundation

struct BusArrivals: Codable, Identifiable {
    let id = UUID()
    var odataMetadata: String
    var BusStopCode: String
    var Services: [Services]
    
    private enum CodingKeys: String, CodingKey {
        case odataMetadata = "odata.metadata"
        case BusStopCode
        case Services
    }
    
    struct Services: Codable {
    
        var ServiceNo: String
        var Operator: String
        var NextBus: NextBus
        
        struct NextBus: Codable {
            var OriginCode: String
            var DestinationCode: String
            var EstimatedArrival: String
            var Latitude: String
            var Longitude: String
            var VisitNumber: String
            var Load: String
            var Feature: String
            var Typez: String
            var CustomEstimatedArrival: String {
                var placeholder = self.EstimatedArrival
                placeholder = placeholder.replacingOccurrences(of: "T", with: " ")
                placeholder = placeholder.replacingOccurrences(of: ":", with: "")
                var index = placeholder.index(placeholder.startIndex, offsetBy: 13)
                placeholder.insert(":", at: index)
                index = placeholder.index(placeholder.startIndex, offsetBy: 16)
                placeholder.insert(":", at: index)
                index = placeholder.index(placeholder.startIndex, offsetBy: 19)
                placeholder.insert(" ", at: index)
                return placeholder
            }
            
            private enum CodingKeys: String, CodingKey {
                case Typez = "Type"
                case OriginCode
                case DestinationCode
                case EstimatedArrival
                case Latitude
                case Longitude
                case VisitNumber
                case Load
                case Feature
            }
        }
    }
}



