//
//  CommunicationBuffer.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationBuffer {
    var outgoingBuffer: [RawMessage] = []
    
    func send(dest: MCPeerID, data: NSData) {
        var msg = RawMessage(dest: dest, data: data)
        self.outgoingBuffer.append(msg)
    }
}
