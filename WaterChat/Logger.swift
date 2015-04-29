//
//  Logger.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/6/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import UIKit


let mutext = dispatch_semaphore_create(1)

class Logger {
    //dispatch_semaphore_wait(self.incomingCountSem, DISPATCH_TIME_FOREVER)
    //dispatch_semaphore_signal(self.incomingMutex)
    
    class func log(logMessage: String, functionName: String = __FUNCTION__) {
        dispatch_semaphore_wait(mutext, DISPATCH_TIME_FOREVER)
        println("[LOG] \(functionName): \(logMessage)")
        dispatch_semaphore_signal(mutext)
    }
    
    class func error(logMessage: String, functionName: String = __FUNCTION__) {
        dispatch_semaphore_wait(mutext, DISPATCH_TIME_FOREVER)
        dispatch_semaphore_signal(mutext)
        NSLog("[ERROR] \(functionName): \(logMessage)")
    }
    
    class func log(chatView: UITextView, logMessage: String, functionName: String = __FUNCTION__) {
        let message = "[LOG] \(functionName): \(logMessage)\n"
        chatView.text = chatView.text + message
    }
}