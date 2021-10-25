//
//  Networking_AppApp.swift
//  Networking App
//
//  Created by Jia Jie Chan on 30/4/21.
//

import SwiftUI
import UIKit

@main
struct Networking_AppApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        preloadData()
        return true
    }
    
    private func preloadData() {
        let preloadedDataKey = "didPreloadData"
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: preloadedDataKey) == false {
            
            guard let urlPath = Bundle.main.url(forResource: "PreloadedData", withExtension: "sqlite") else { return }
            
            
            if let arrayContents = NSArray(contentsOf: urlPath) as? [String] {
                for item in arrayContents {
                    print(item)
                }
            }
            
            userDefaults.set(true, forKey: preloadedDataKey)
            
        }
        
        
        
        
    }
    
    
}
