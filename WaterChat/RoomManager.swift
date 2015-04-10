//
//  RoomManager.swift
//  WaterChat
//
//  Created by Huiyuan Wang on 4/9/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GroupManager {
    // All the public teams in this network
    
    // All the users in this network
    
    // The current maximum ID of group creation message
    var seqNum: UInt32 = 0
    var mp: MessagePasser!
    var macAddr: MacAddr!
    
    // A dictionary to record all the public group IDs
    // MacAddr: The mac address of the group holder
    // Room: The group information of one specific room
    var publicGroupIDs = Dictionary<MacAddr, Room>()
    // A dictionary to record all the group creation requests
    // UInt32: the sequence number of this creation request
    // Room: The group information of one specific room
    var publicGroupReqs = Dictionary<UInt32, Room>()
    
    // A dictionary to record all the members in this network
    // There is no need to record how many groups one user belong to
    var users = Dictionary<MCPeerID, User>()
    
    
    init(addr: MacAddr, mp: MessagePasser) {
        self.macAddr = addr
        self.mp = mp
    }
    
    func input() -> String {
        var keyboard = NSFileHandle.fileHandleWithStandardInput()
        var inputData = keyboard.availableData
        var strData = NSString(data: inputData, encoding: NSUTF8StringEncoding)!
        
        return strData.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }
    
    // Broadcast to notify all the users in this network to create a new public room
    // No destination macaddr
    func createPublicRoom() {
        // The public room name and the permitted maximum number are input by users
        print("What is your new group name?")
        var roomName = input()
        
        // TODO
        // check whether this name is valid
        
        
        print("What is the maximum number in this group?")
        var maxNumber = input()
        
        // create the room creation request
        var rcr = RoomRequest()
        //rcr.groupName = roomName
        //rcr.maxNum = maxNumber
        
        
        self.mp.broadcast(rcr)
    }
    
    // Receive a creation request
    func receiveRoomReq(from: MacAddr, message: RoomRequest) {
        
        
        
    }
    
    // Receive creation acknowledgement
    func receiveRoomAck() {
        
    }
}