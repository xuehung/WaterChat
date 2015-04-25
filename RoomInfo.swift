//
//  RoomInfo.swift
//  WaterChat
//
//  Created by Huiyuan Wang on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

class RoomInfo {
    var groupID: Int
    var name: String
    var groupHolder: String = Config.address.description
    var maximumNumber: Int
    // The room is empty when initialization
    // yourself is in this public group
    var currentNumber: Int
    var memberList: [String] = []
    
    init() {
        self.groupID = random() % 1024
        Logger.log("Random group ID \(self.groupID)")
        self.name = "unknown"
        self.maximumNumber = 10
        self.currentNumber = 1
        // Add the yourself(the group holder into this group's member list)
        self.memberList.append(groupHolder)
    }
    init(name: String, maxNum: Int) {
        self.groupID = random() % 1024
        Logger.log("Random group ID \(self.groupID)")
        self.name = name
        self.maximumNumber = maxNum
        self.currentNumber = 1
        // Add the yourself(the group holder into this group's member list)
        self.memberList.append(groupHolder)
    }
}