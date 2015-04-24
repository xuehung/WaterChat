//
//  RouteReply.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/14/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

//    0                   1                   2                   3
//    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |     Type      |R|A|    Reserved     |Prefix Sz|   Hop Count   |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                  Destination Sequence Number                  |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                     Destination MAC address                   |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                     Destination MAC address                   |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                    Originator MAC address                     |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                    Originator MAC address                     |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                           Lifetime                            |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

class RouteReply: Message {
    
    let SIZE = 28
    
    //var F: Bool
    var R: UInt8 = 0
    var A: UInt8 = 0
    var hopCount: UInt8 = 0
    var destMacAddr: UInt64 = 0
    var origMacAddr: UInt64 = 0
    var destSeqNum: UInt32 = 0
    var lifeTime: UInt32 = 0
    
    override init() {
        super.init()
    }
    
    override init(bytes data: NSData) {
        data.getBytes(&self.R, range: NSMakeRange(1, 1))
        data.getBytes(&self.A, range: NSMakeRange(1, 1))
        self.R = (self.R >> 7) & 0x1
        self.A = (self.A >> 6) & 0x1
        data.getBytes(&self.hopCount, range: NSMakeRange(3, 1))
        data.getBytes(&self.destSeqNum, range: NSMakeRange(4, 4))
        data.getBytes(&self.destMacAddr, range: NSMakeRange(8, 8))
        data.getBytes(&self.origMacAddr, range: NSMakeRange(16, 8))
        data.getBytes(&self.lifeTime, range: NSMakeRange(24, 4))
        super.init(bytes: data)
    }
    
    override func serialize() -> NSData {        
        var array = [UInt8](count: SIZE, repeatedValue: 0)
        array[0] = MessageType.RREP.rawValue
        array[3] = self.hopCount
        var uint32P =  UnsafeMutablePointer<UInt32>(array)
        uint32P[1] = self.destSeqNum
        uint32P[6] = self.lifeTime
        var uint64P =  UnsafeMutablePointer<UInt64>(array)
        uint64P[1] = self.destMacAddr
        uint64P[2] = self.origMacAddr
        var nsData = NSData(bytes: array, length: SIZE)
        return nsData
    }

}