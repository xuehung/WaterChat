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
}