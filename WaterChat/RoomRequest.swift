//
//  RoomRequest.swift
//  WaterChat
//
//  Created by Huiyuan Wang on 4/9/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

// Some members will be invited at the first time when the room is created
// These information should be included in the request information
// Could I use peerID to represent each member?
//
//    0               1               2               3
//    0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |     Type      |               |   Max Number  |   Cur Number  |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                           Group ID                            |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                         Group Name (1)                        |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                         Group Name (2)                        |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                          Member1 ID                           |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                          Member2 ID                           |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                            ... ...                            |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                          Membern ID                           |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

class RoomRequest: Message {
    
    let SIZE = 32
    
    var curNum: UInt8 = 0
    var maxNum: UInt8 = 0
    var nameLen: Int32 = 0
    var groupName: String
    var name: String
    var groupID: UInt32 = 0
    var members = [MCPeerID]()
    
    override init() {
        var roomInfo = Room()
        self.groupName = roomInfo.name
        self.name = self.groupName.substringWithRange(Range<String.Index>(start: self.groupName.startIndex, end: advance(self.groupName.startIndex, 8)))
        self.nameLen = roomInfo.nameLen
        self.curNum = 1
        self.maxNum = 0
        self.groupID = roomInfo.groupID
        self.members = roomInfo.groupMemberList
        super.init()
    }
    
    override init(bytes data: NSData) {
        
        var roomInfo = Room()
        
        self.groupName = roomInfo.name
        self.nameLen = roomInfo.nameLen
        
        // To limit that the length of group name is 8 bytes
        self.name = self.groupName.substringToIndex(advance(self.groupName.startIndex, 8))
        var group = [UInt8](self.name.utf8)
        println("8 bytes group name \(self.name)")
        println("encode group name \(group)")
        
        self.curNum = roomInfo.currentNumber
        self.maxNum = roomInfo.maximumNumber
        self.groupID = roomInfo.groupID
        self.members = roomInfo.groupMemberList
        
        // The first 8 bytes are type of RoomRequest
        data.getBytes(&self.curNum, range: NSMakeRange(2, 1))
        data.getBytes(&self.maxNum, range: NSMakeRange(3, 1))
        data.getBytes(&self.groupID, range: NSMakeRange(4, 4))
        //data.getBytes(&self.nameLen, range: NSMakeRange(8, 4))
        
        var content: [UInt8] = Util.toByteArray(data) + Util.toByteArray(self.name)
        for member in members {
            content += Util.toByteArray(member)
        }
        var nsData = NSMutableData()
        nsData.appendBytes(content, length: content.count)
        super.init(bytes: nsData)
    }
    
    override func serialize() -> NSData {
        var array = [UInt8](count: SIZE, repeatedValue: 0)
        array[0] = MessageType.ROOMREQ.rawValue
        array[2] = self.curNum
        array[3] = self.maxNum
        var group = [UInt8](self.name.utf8)
        var i = 0
        for namepart in group {
            array[i] = namepart
            i += 1
        }
        
        var uint32P =  UnsafeMutablePointer<UInt32>(array)
        uint32P[1] = self.groupID
        
        var nsData = NSData(bytes: array, length: SIZE)
        let str = NSString(data: nsData, encoding: NSUTF8StringEncoding)
        
        return nsData
    }
}