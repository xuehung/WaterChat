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
    }
}