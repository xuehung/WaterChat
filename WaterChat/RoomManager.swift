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
        var type: Int? = (room["type"] as Int)
        Logger.log("type is \(type)")
        r.name = room["name"] as String
        r.groupID = room["groupID"] as Int
        r.groupHolder = room["macAddr"] as String
        r.maximumNumber = room["maxNum"] as Int
        r.currentNumber = room["curNum"] as Int
        r.memberList = room["memList"] as [String]
        
        return r
    }
    
    func addRoomToList(newRoom: RoomInfo) {
        var exists = false
        for room in groupList{
            if room.groupID == newRoom.groupID {
                // It exists in the gorupList and need to be updated
                exists = true
                // Only need to change the current room member number and the memberlist of this room
                room.currentNumber = newRoom.currentNumber
                room.memberList = newRoom.memberList
            }
        }
        if (!exists){
            groupList.append(newRoom)
        }
        currentRoomInfo = newRoom
    }
    
    func announceRoomInfo() {
        var mp = MessagePasser.getInstance(Config.address)
        var rm = RoomManager()
        for room in groupList {
            var mdict = rm.RoomToJSON(room)
            mp.broadcast(mdict)
        }
    }
    
    func selectOneRoom(roomName: String) -> RoomInfo {
        // traverse the room list to find the matching roomInfo
        for room in groupList {
            if (room.name == roomName) {
                currentRoomInfo = room;
                break;
            }
        }
        return currentRoomInfo;
    }
    
    func addMemberToRoom(memName: String) -> RoomInfo {
        currentRoomInfo.memberList.append(memName)
        currentRoomInfo.currentNumber += 1
        // Update the room information in group list for
        addRoomToList(currentRoomInfo)
        return currentRoomInfo
    }
}