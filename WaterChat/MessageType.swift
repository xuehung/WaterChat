//
//  MessageType.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

enum MessageType: UInt8 {
    case UNKNOWN = 0
    case RREQ = 1 // Route Request
    case RERR = 2 // Route Response
    case RREP = 3 // Route Reply
}