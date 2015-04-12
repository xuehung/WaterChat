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
        self.dict = dict
        super.init()
    }
}