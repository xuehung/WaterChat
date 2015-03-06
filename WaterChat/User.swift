//
//  User.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/5/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class User {
    var name: String;
    var peerID: MCPeerID;
    var phoneNumber: String;
    var image: NSData? = nil;
    
    init(peerID: MCPeerID, name: String, phoneNumber: String) {
        self.peerID = peerID;
        self.name = name;
        self.phoneNumber = phoneNumber;
    }
    
}
