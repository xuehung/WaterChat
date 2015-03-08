//
//  RoutingManager.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/6/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

class RouteManager {
    // This number should be incremented in the following 2 cases
    // 1) before a node originates a route discovery
    // 2) before a destination node originates a RREP in response to a RREQ
    var seqNum: UInt32 = 0
    
    init() {
        
    }
}