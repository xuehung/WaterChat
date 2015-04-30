//
//  One2OneCommunication.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 4/29/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
var one2oneMsg = Dictionary<MacAddr, [ChatMessage]>()

class One2OneCommunication {
    class func addMessage(dest: MacAddr, message: ChatMessage) {
        Logger.log("Add a message to 121 messages of \(dest)")
        Logger.log(message.description)
        if(one2oneMsg[dest] == nil) {
            one2oneMsg[dest] = []
        }
        one2oneMsg[dest]?.append(message)
        
        var list = one2oneMsg[dest]!
        
        one2oneMsg[dest] = sorted(list) {
            (o1, o2) in
            let m1 = o1 as ChatMessage
            let m2 = o2 as ChatMessage
            if (m1.date_.compare(m2.date_) == NSComparisonResult.OrderedSame || m1.date_.compare(m2.date_) == NSComparisonResult.OrderedAscending) {
                return true
            }
            return false
        }
        
        
    }
}