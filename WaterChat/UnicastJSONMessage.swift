//
//  UnicastJSONMessage.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 4/23/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation


// type(1 Byte), broadcastSeqNum(4 Byte), src(8 Bytes)


class UnicastJSONMessage: Message {
    
    var destMacAddr: UInt64 = 0
    var dictionary: NSDictionary!
    
    
    override init() {
        super.init()
    }
    
    init(message: NSDictionary, destMacAddr: UInt64) {
        self.destMacAddr = destMacAddr
        
        var header: [UInt8] = Util.toByteArray(MessageType.UNICASTJSON.rawValue) +
            Util.toByteArray(self.destMacAddr)
        
        Logger.log("can covert? \(NSJSONSerialization.isValidJSONObject(message))")
        var bytes: NSData = NSJSONSerialization.dataWithJSONObject(message, options: nil, error: nil)!
        
        var nsData = NSMutableData()
        nsData.appendBytes(header, length: header.count)
        nsData.appendData(bytes)
        super.init(bytes: nsData)
    }
    
    override init(bytes data: NSData) {
        data.getBytes(&self.destMacAddr, range: NSMakeRange(1, 8))
        var messageBody: NSData = data.subdataWithRange(NSMakeRange(9, data.length - 9))
        Logger.log("Parse JSON")
        // Parse Json
        var error: NSError?
        let maybeObj: AnyObject? = NSJSONSerialization.JSONObjectWithData(messageBody, options: nil, error: &error)
        
        if let obj: AnyObject = maybeObj {
            if let dict = obj as? NSDictionary {
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
