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
        var type: Int = (room["type"] as! Int)
        Logger.log("type is \(type)")
        r.name = room["name"] as! String
        r.groupID = room["groupID"] as! Int
        r.groupHolder = room["macAddr"] as! String
        r.maximumNumber = room["maxNum"] as! Int
        r.currentNumber = room["curNum"] as! Int
        r.memberList = room["memList"] as! [String]
        
        return r
    }
    
    func MsgToJSON(msg: String) -> NSMutableDictionary {
        var mdict = NSMutableDictionary()
        var type = NSNumber(unsignedChar: MessageType.ROOMTALK.rawValue)
        var content: NSString = msg
        
        mdict.setObject(type, forKey: "type")
        mdict.setObject(content, forKey: "content")
        
        return mdict
    }
    
    func JSONToMsg(content: NSDictionary) -> String {
        var type: Int = (content["type"] as! Int)
        var msg: String = (content["content"] as! String)
        
        return msg;
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
                break
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
    
    func enterOneRoom(roomName: String) -> RoomInfo {
        // traverse the room list to find the matching roomInfo
        for room in groupList {
            if (room.name == roomName) {
                // try to add this member into this room
                if (Config.address.description != room.groupHolder) {
                    room.currentNumber += 1
                    room.memberList.append(Config.address.description)
                }
                currentRoomInfo = room;
                break;
            }
        }
        return currentRoomInfo;
    }
    
    func leaveOneRoom(roomName: String) {
        for room in groupList {
            if (room.name == roomName) {
                // try to remove this member from the memberlist
                // the roomholder cannot be removed
                var i = 0
                for mac in room.memberList {
                    if (mac == roomName && room.groupHolder != roomName) {
                        room.currentNumber -= 1
                        room.memberList.removeAtIndex(i)
                        break
                    }
                    i += 1
                }
            }
        }
    }
    
    func sendToRoom() {
        
    }
    
    func receiveRoom() {
        
    }
    
    func addMemberToRoom(memName: String) -> RoomInfo {
        currentRoomInfo.memberList.append(memName)
        currentRoomInfo.currentNumber += 1
        // Update the room information in group list for
        addRoomToList(currentRoomInfo)
        return currentRoomInfo
    }
}

