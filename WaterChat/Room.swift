//
//  Room.swift
//  WaterChat
//
//  Created by Huiyuan Wang on 4/9/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Room {
    var groupID: UInt32
    var name: String
    var nameLen: Int32
    var groupHolder: MCPeerID = MCPeerID()
    var maximumNumber: UInt8
    // The room is empty when initialization
    // yourself is in this public group
    var currentNumber: UInt8 = 1
    var groupMemberList = [MCPeerID]()
    var memberList: [MCPeerID] = []
    
    init() {
        self.groupID = 0;
        self.name = "unknown"
        self.nameLen = Int32(countElements(self.name))
        self.maximumNumber = 10;
        // Add the yourself(the group holder into this group's member list)
        self.groupMemberList.append(groupHolder)
    }
    
    // Define the name of a new public room and the permitted number of members in this group
    init(groupID: UInt32, name: String, maximumNumber: UInt8) {
        // use random number to replace this group ID
        self.groupID = groupID;
        self.name = name;
        self.nameLen = Int32(countElements(self.name))
        self.maximumNumber = maximumNumber;
        // Add the yourself(the group holder into this group's member list)
        self.groupMemberList.append(groupHolder)
    }
    
    func input() -> String {
        var keyboard = NSFileHandle.fileHandleWithStandardInput()
        var inputData = keyboard.availableData
        var strData = NSString(data: inputData, encoding: NSUTF8StringEncoding)!
        
        return strData.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
    
    // Add all the members you want when initialization
    func addMembers() {
        // Need to get all the members in this network
    }
    
}