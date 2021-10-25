//
//  KeyDecodeJSON.swift
//  Networking App
//
//  Created by Jia Jie Chan on 3/5/21.
//

import Foundation

class API: ObservableObject {
    
    func makeRequest(completion: @escaping (BusRoutes) -> ()) {
        
        let url = Foundation.URL(string: "http://datamall2.mytransport.sg/ltaodataservice/BusRoutes")
        //Retrieve URL
        guard url != nil else {
            print("Couldn't retrive URL")
            return
        }
        //URL Request
        var request = URLRequest(url: url!)
        
        
        //Specify the header
        let header: [String: String] = ["AccountKey" : "PEs9uVD5TnWV8LR9CmsRdQ==",
                                         "accept" : "application/json"]
        
        request.allHTTPHeaderFields = header
        
        request.httpMethod = "GET"
        
        
        //Get session
        let session = URLSession.shared
        
        //Create task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            if error == nil && data != nil {
                
                //Parse
                let decoder = JSONDecoder()
                
                do {
                   let loaded = try decoder.decode(BusRoutes.self, from: data!)
                    
                   DispatchQueue.main.async {
                       completion(loaded)
                    }
                }
                catch {
                    print("Error in JSON parsing")
                }
                
            }
        }
        
        dataTask.resume()
}
}

