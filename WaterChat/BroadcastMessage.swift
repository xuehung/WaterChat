//
//  BroadcastMessage.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 4/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation


// type(1 Byte), broadcastSeqNum(4 Byte), src(8 Bytes)


class BroadcastMessage: Message {
    
    var broadcastSeqNum: UInt32 = 0
    var srcMacAddr: UInt64 = 0
    var message: Message!
    
    
    override init() {
        super.init()
    }
    
    init(message: Message, seqNum: UInt32, srcMacAddr: UInt64) {
        self.message = message
        self.broadcastSeqNum = seqNum
        self.srcMacAddr = srcMacAddr
        
        var header: [UInt8] = Util.toByteArray(MessageType.BROADCAST.rawValue) +
            Util.toByteArray(self.broadcastSeqNum) +
            Util.toByteArray(self.srcMacAddr)
        var nsData = NSMutableData()
        nsData.appendBytes(header, length: header.count)
        nsData.appendData(message.serialize())
        super.init(bytes: nsData)
    }
    
    override init(bytes data: NSData) {
        data.getBytes(&self.broadcastSeqNum, range: NSMakeRange(1, 4))
        data.getBytes(&self.srcMacAddr, range: NSMakeRange(5, 8))
        var messageBody = data.subdataWithRange(NSMakeRange(13, data.length - 13))
        self.message = Message.messageFactory(messageBody)
        
        super.init(bytes: data)
    }
    
    override func serialize() -> NSData {
        return self.data
    }
    
    func getMessageData() -> NSData {
        return message.serialize()
    }
    
    func getInnerMessage() -> Message {
        return self.message
    }
}
