//
//  MessageType.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

enum MessageType: UInt8 {
    case BROADCAST = 0
    case UNKNOWN = 1
    case RREQ = 2 // Route Request
    case RERR = 3 // Route Response
    case RREP = 4 // Route Reply
    case ROOMREQ = 5 // Room Request
    
    case BROADCASTJSON = 98
    case JSON = 99
}