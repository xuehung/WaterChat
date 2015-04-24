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
//   |                    Destination MAC Address                    |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                    Destination MAC Address                    |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                    Originator MAC Address                     |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                    Originator MAC Address                     |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                  Destination Sequence Number                  |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                  Originator Sequence Number                   |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

class RouteRequest: Message {
    
    let SIZE = 32
    
    //var F: Bool
    var D: UInt8 = 0
    var U: UInt8 = 0
    var hopCount: UInt8 = 0
    var PREQID: UInt32 = 0
    var destMacAddr: UInt64 = 0
    var origMacAddr: UInt64 = 0
    var destSeqNum: UInt32 = 0
    var origSeqNum: UInt32 = 0
    
    override init() {
        super.init()
    }
    
    override init(bytes data: NSData) {
        data.getBytes(&self.D, range: NSMakeRange(1, 1))
        data.getBytes(&self.U, range: NSMakeRange(1, 1))
        self.D = (self.U >> 4) & 0x1
        self.U = (self.U >> 3) & 0x1
        data.getBytes(&self.hopCount, range: NSMakeRange(3, 1))
        data.getBytes(&self.PREQID, range: NSMakeRange(4, 4))
        data.getBytes(&self.destMacAddr, range: NSMakeRange(8, 8))
        data.getBytes(&self.destSeqNum, range: NSMakeRange(16, 4))
        data.getBytes(&self.origMacAddr, range: NSMakeRange(20, 8))
        data.getBytes(&self.origSeqNum, range: NSMakeRange(28, 4))
        super.init(bytes: data)
    }
    
    override func serialize() -> NSData {
        //var data = NSMutableData(length: SIZE)
        
        var array = [UInt8](count: SIZE, repeatedValue: 0)
        array[0] = MessageType.RREQ.rawValue
        array[3] = self.hopCount
        var uint32P =  UnsafeMutablePointer<UInt32>(array)
        uint32P[1] = self.PREQID
        uint32P[6] = self.destSeqNum
        uint32P[7] = self.origSeqNum
        var uint64P =  UnsafeMutablePointer<UInt64>(array)
        uint64P[1] = self.destMacAddr
        uint64P[2] = self.origMacAddr
        var nsData = NSData(bytes: array, length: SIZE)
        return nsData

        //return data as NSData
    }
}