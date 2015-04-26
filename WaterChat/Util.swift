//
//  Util.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/16/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

class Util {
    class func convertDisplayNameToMacAddr(addr: String) -> MacAddr {
        if let num = addr.toInt() {
            return MacAddr(num)
        } else {
            Logger.error("Invalid display name \(addr)")
            return MacAddr(0)
        }
    }
    
    class func fromByteArray<T>(value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBufferPointer {
            return UnsafePointer<T>($0.baseAddress).memory
        }
    }
    
    class func toByteArray<T>(var value: T) -> [UInt8] {
        return withUnsafePointer(&value) {
            Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>($0), count: sizeof(T)))
        }
    }

}