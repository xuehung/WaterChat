//
//  Config.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/6/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

// for configuration
struct Config {
    static let serviceType = "WaterChat"
    static let address: MacAddr = {
        var udid = UIDevice.currentDevice().identifierForVendor.UUIDString
        var length = count(udid)
        let range = Range(start: (advance(udid.endIndex, -12)), end: udid.endIndex)
        let macAddress = udid.substringWithRange(range)
        println("####### Mac Addr \(UInt64(strtoul((String(macAddress)), nil, 16)))")
        return UInt64(strtoul((String(macAddress)), nil, 16)) + 38
    }()
    static let maxNeighbor = 3
}
