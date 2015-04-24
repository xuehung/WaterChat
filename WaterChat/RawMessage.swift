//
//  RawMessage.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

struct RawMessage {
    var dest: MCPeerID!
    var data: NSData!
    
    init(dest: MCPeerID, data: NSData) {
        self.dest = dest
        self.data = data
    }
}