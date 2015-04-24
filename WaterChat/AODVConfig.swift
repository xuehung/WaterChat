//
//  AODVConfig.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/9/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

struct AODVConfig {
    static let NET_DIAMETER: Time = 35
    static let NODE_TRAVERSAL_TIME: Time = 40 // ms
    static let NET_TRAVERSAL_TIME: Time = 2 * NODE_TRAVERSAL_TIME * NET_DIAMETER
    
    static let ACTIVE_ROUTE_TIMEOUT: Time = 3000 // ms
    static let MY_ROUTE_TIMEOUT: Time = 2 * ACTIVE_ROUTE_TIMEOUT
    
    static let PATH_DISCOVERY_TIME: Time = 2 * NET_TRAVERSAL_TIME
    static let RREQ_RETRIES = 2
}
