//
//  RawMessage.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct RawMessageX {
    var dest: MacAddr!
    var data: NSData!
    
    init(dest: MacAddr, data: NSData) {
        self.dest = dest
        self.data = data
    }
}