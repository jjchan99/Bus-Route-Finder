//
//  Log.swift
//  Networking App
//
//  Created by Jia Jie Chan on 19/5/21.
//

import Foundation

enum Log {
    static func queue(action: String) {
        DispatchQueue.log(action: action)
    }
    
    static func location(fileName: String, functionName: String = #function, lineNumber: Int = #line) {
        print("Called by \(fileName.components(separatedBy: "/").last ?? fileName) - \(functionName) at line \(lineNumber)")
    }
}

extension DispatchQueue {
    static func log(action: String) {
        print("""
            
            \(action): 👨‍👩‍👦 \(String(validatingUTF8: __dispatch_queue_get_label(nil))!) 🧵 \(Thread.current)
            
            """)
    }
}
