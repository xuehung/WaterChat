//
//  TableEntry.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

struct TableEntry {
    var destAddr: UInt64
    var destSeqNum: UInt32
    var isDestSeqNumValid: UInt8
    var hopCount: UInt8
    var nextHop: UInt64
    var lifeTime: UInt32
}