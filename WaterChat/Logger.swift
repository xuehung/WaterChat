//
//  Logger.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/6/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
class Logger {
    
    class func log(logMessage: String, functionName: String = __FUNCTION__) {
        println("[LOG] \(functionName): \(logMessage)")
    }
    
    class func error(logMessage: String, functionName: String = __FUNCTION__) {
        NSLog("[ERROR] \(functionName): \(logMessage)")
    }
}