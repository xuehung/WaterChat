//
//  Message.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

class Message {
    
    // Singlton Pattern
    class func messageFactory(data: NSData) -> Message? {
        /*
        // the number of elements:
        let count = data.length
        // create array of appropriate length:
        var array = [UInt8](count: count, repeatedValue: 0)
        // copy bytes into array
        data.getBytes(&array, length:count * sizeof(UInt32))
        // type is a byte
        */
        //var type = array[0]
        var type: UInt8 = 0
        data.getBytes(&type, range: NSMakeRange(0, 1))
        
        switch type {
        case 1:
            return RouteRequest(bytes: data)
        default:
            return nil;
        }
    }
    
    
    func serialize() -> NSData {
        fatalError("This method must be overridden")
    }
}