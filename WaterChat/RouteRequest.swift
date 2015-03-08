//
//  RouteRequest.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

//    0                   1                   2                   3
//    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |     Type      |J|R|G|D|U|   Reserved          |   Hop Count   |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                            RREQ ID                            |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                    Destination IP Address                     |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                  Destination Sequence Number                  |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                    Originator IP Address                      |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                  Originator Sequence Number                   |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

class RouteRequest: Message {
    //var F: Bool
    var D: UInt8 = 0
    var U: UInt8 = 0
    var hopCount: UInt8 = 0
    var PREQID: Int32 = 0
    
    init(bytes data: NSData) {
        data.getBytes(&self.D, range: NSMakeRange(1, 1))
        data.getBytes(&self.U, range: NSMakeRange(1, 1))
        self.D = (self.U >> 4) & 0x1
        self.U = (self.U >> 3) & 0x1
        data.getBytes(&self.hopCount, range: NSMakeRange(3, 1))
        data.getBytes(&self.PREQID, range: NSMakeRange(4, 4))
    }
}