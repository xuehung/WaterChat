//
//  RoomManager.swift
//  WaterChat
//
//  Created by Huiyuan Wang on 4/9/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

var groupList = [RoomInfo]()
var currentRoomInfo: RoomInfo = RoomInfo()

class RoomManager {
    
    // A dictionary to record all the public group IDs
    // Int: The group ID of this group
    // Room: The group information of one specific room
    var publicGroups = Dictionary<Int, Room>()
    
    // A dictionary to record all the members in this network
    // There is no need to record how many groups one user belong to
    var users = Dictionary<MacAddr, User>()
    
    func RoomToJSON(newRoom: RoomInfo) -> NSMutableDictionary {
        
        //var newRoom = RoomInfo()
        
        var mdict = NSMutableDictionary()
        var groupID: NSNumber = newRoom.groupID
        var name: NSString = newRoom.name
        var type = NSNumber(unsignedChar: MessageType.ROOMREQ.rawValue)
        var maxNum: NSNumber = newRoom.maximumNumber
        var curNum: NSNumber = newRoom.currentNumber
        var macAddr: NSString = newRoom.groupHolder
        var memberList: [NSString] = newRoom.memberList
        
        mdict.setObject(type, forKey: "type")
        mdict.setObject(groupID, forKey: "groupID")
        mdict.setObject(name, forKey: "name")
        mdict.setObject(maxNum, forKey: "maxNum")
        mdict.setObject(curNum, forKey: "curNum")
        mdict.setObject(macAddr, forKey: "macAddr")
        mdict.setObject(memberList, forKey: "memList")
        
        return mdict
    }
    
    func JSONToRoom(room: NSDictionary) -> RoomInfo {

        var r = RoomInfo()
        var type: Int? = (room["type"] as! Int)
        Logger.log("type is \(type)")
        r.name = room["name"] as! String
        r.groupID = room["groupID"] as! Int
        r.groupHolder = room["macAddr"] as! String
        r.maximumNumber = room["maxNum"] as! Int
        r.currentNumber = room["curNum"] as! Int
        r.memberList = room["memList"] as! [String]
        
        return r
    }
    
    func addRoomToList(newRoom: RoomInfo) {
        var exists = false
        for element in groupList{
            if element.groupID == newRoom.groupID {
                exists = true
            }
        }
        if (!exists){
            groupList.append(newRoom)
        }
        currentRoomInfo = newRoom
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
        
    }
    
    // Receive a creation request
    func receiveRoomReq(from: MacAddr, message: RoomRequest) {
        
        
        
    }
    
    // Receive creation acknowledgement
    func receiveRoomAck() {
        
    }
}