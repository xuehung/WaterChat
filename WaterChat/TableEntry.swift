//
//  TableEntry.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

class TableEntry {
    var destAddr: MacAddr = 0
    var destSeqNum: UInt32 = 0
    var status: RouteStatus = RouteStatus.invalid
    var isDestSeqNumValid: Bool = false
    var hopCount: UInt8 = 0
    var nextHop: MacAddr = 0
    var lifeTime: Time = 0
}