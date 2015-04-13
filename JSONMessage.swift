//
//  JSONMessage.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

class JSONMessage: Message {
    var dict: NSDictionary!
    init(dict: NSDictionary) {
        /*var kind = dict["type"] as NSNumber
        if (kind == MessageType.ROOMREQ.rawValue) {
            self.type = MessageType.ROOMREQ
        }
        if (kind == MessageType.USRPROFILE.rawValue) {
            self.type = MessageType.USRPROFILE
        }*/
        /*
        for t in MessageType.allValues {
            if (kind == MessageType.ROOMREQ.rawValue) {
                self.type = MessageType.ROOMREQ
            }
        }
        */
        self.dict = dict
        super.init()
    }
}