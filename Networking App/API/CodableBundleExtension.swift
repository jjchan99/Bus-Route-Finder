//
//  File.swift
//  Networking App
//
//  Created by Jia Jie Chan on 2/5/21.
//

import Foundation

extension Bundle {
    
    func decodeLocal(forResource: String, withExtension: String) -> BusRoutes {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else {
            fatalError("Failed to locate \(forResource) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to locate \(forResource) in bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(BusRoutes.self, from: data) else {
            fatalError("So close! Failed to load \(forResource) from bundle")
        }
        
        return loaded
    }
}

