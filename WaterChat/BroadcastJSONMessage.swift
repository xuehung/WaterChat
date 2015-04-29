//
//  BroadcastMessage.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 4/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation


// type(1 Byte), broadcastSeqNum(4 Byte), src(8 Bytes)


class BroadcastJSONMessage: Message {
    
    var broadcastSeqNum: UInt32 = 0
    var srcMacAddr: UInt64 = 0
    var dictionary: NSDictionary!
    
    
    override init() {
        super.init()
    }
    
    init(message: NSDictionary, seqNum: UInt32, srcMacAddr: UInt64) {
        self.broadcastSeqNum = seqNum
        self.srcMacAddr = srcMacAddr
        
        var header: [UInt8] = Util.toByteArray(MessageType.BROADCASTJSON.rawValue) +
            Util.toByteArray(self.broadcastSeqNum) +
            Util.toByteArray(self.srcMacAddr)
        
        Logger.log("can covert? \(NSJSONSerialization.isValidJSONObject(message))")
        var bytes: NSData = NSJSONSerialization.dataWithJSONObject(message, options: nil, error: nil)!
        
        var nsData = NSMutableData()
        nsData.appendBytes(header, length: header.count)
        nsData.appendData(bytes)
        super.init(bytes: nsData)
    }
    
    override init(bytes data: NSData) {
        data.getBytes(&self.broadcastSeqNum, range: NSMakeRange(1, 4))
        data.getBytes(&self.srcMacAddr, range: NSMakeRange(5, 12))
        var messageBody: NSData = data.subdataWithRange(NSMakeRange(13, data.length - 13))
        Logger.log("Parse JSON")
        // Parse Json
        var error: NSError?
        let maybeObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(messageBody, options: nil, error: &error)
        
        if let obj: AnyObject = maybeObj {
            Logger.log("maybeObj is anyobject")
            if let dict: NSDictionary = obj as? NSDictionary {
                Logger.log("obj is NSDictionary")
                self.dictionary = dict
                Logger.log("Got NSDictionary")
            } else {
                Logger.error("Fail to as NSDictionary")
            }
        } else {
            Logger.error("Not an object")
        }        
        super.init(bytes: data)
    }
    
    override func serialize() -> NSData {
        return self.data
    }
    
    func getDict() -> NSDictionary {
        return self.dictionary
    }
   
}
