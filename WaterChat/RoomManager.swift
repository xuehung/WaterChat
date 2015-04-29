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

    func RmvRoomToJSON(roomToRmv: RoomInfo) -> NSMutableDictionary {
        //var newRoom = RoomInfo()

        var mdict = NSMutableDictionary()
        var groupID: NSNumber = roomToRmv.groupID
        var name: NSString = roomToRmv.name
        var type = NSNumber(unsignedChar: MessageType.ROOMRMV.rawValue)
        var maxNum: NSNumber = roomToRmv.maximumNumber
        var curNum: NSNumber = roomToRmv.currentNumber
        var macAddr: NSString = roomToRmv.groupHolder
        var memberList: [NSString] = roomToRmv.memberList

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
    /*
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
    */
    func addRoomToList(newRoom: RoomInfo) {
        var exists = false
        for room in groupList{
            if room.groupID == newRoom.groupID {
                // It exists in the gorupList and need to be updated
                exists = true
                // Only need to change the current room member number and the memberlist of this room
                room.currentNumber = newRoom.currentNumber
                //room.memberList = newRoom.memberList
                room.memberList = []
                for member in newRoom.memberList {
                    room.memberList += [member]
                }
                println("room.memberList = \(room.memberList)")
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
        for room in groupList {
            var mdict = RoomToJSON(room)
            mp.broadcast(mdict)
        }
    }

    func enterOneRoom(roomNumber: Int) -> RoomInfo {
        // traverse the room list to find the matching roomInfo
        /*
        for room in groupList {
            if (room.name == roomName) {
                if (room.currentNumber < room.maximumNumber) {
                    room.currentNumber += 1
                    room.memberList.append(Config.address.description)
                    currentRoomInfo = room
                    break
                } else {
                    // TODO: the user is not permitted to enter this room
                }
            }
        }*/
        var index = 0;
        for room in groupList {
            if (index == roomNumber) {
                if (room.currentNumber < room.maximumNumber) {
                    room.currentNumber += 1
                    room.memberList.append(Config.address.description)
                    currentRoomInfo = room
                    break
                } else {
                    // TODO: permit or not
                }
                index += 1
            }
        }
        return currentRoomInfo;
    }

    func leaveOneRoom(roomName: String) {
        var i = 0
        for room in groupList {
            if (room.name == roomName) {
                // try to remove this member from the memberlist
                // the roomholder cannot be removed
                var j = 0
                for mac in room.memberList {
                    if (mac == roomName) {
                        room.currentNumber -= 1
                        room.memberList.removeAtIndex(j)
                        if (room.currentNumber == 0) {
                            // broadcast to remove this room
                            var roomToRemove:RoomInfo = groupList[i]
                            groupList.removeAtIndex(i)
                            var mdict = RmvRoomToJSON(roomToRemove)
                            var mp = MessagePasser.getInstance(Config.address)
                            mp.broadcast(mdict)
                        }
                    }
                    j += 1
                }
            }
            i += 1
        }
    }

    func MsgToJSON(msg: ChatMessage) -> NSMutableDictionary {
        var mdict = NSMutableDictionary()
        var type = NSNumber(unsignedChar: MessageType.ROOMTALK.rawValue)
        var text: NSString = msg.text_
        var sender: NSString = msg.sender_
        var date: NSNumber = msg.date_.timeIntervalSince1970
        
        mdict.setObject(type, forKey: "type")
        mdict.setObject(text, forKey: "text")
        mdict.setObject(sender, forKey: "sender")
        mdict.setObject(date, forKey: "date")
        
        return mdict
    }
    /*
    func sendToRoom(msg: String) {
        var mp = MessagePasser.getInstance(Config.address)
        var mdict = MsgToJSON(msg)
        for mem in currentRoomInfo.memberList {
            if (mem != Config.address.description) {
                var dest: MacAddr = Util.convertDisplayNameToMacAddr(mem)
                mp.send(dest, message: mdict)
            }
        }
    }*/
    
    
    func JSONToMsg(content: NSDictionary) -> ChatMessage {
        Logger.log(content.description)
        var type: Int = (content["type"] as! Int)
        //var text = content["text"]
        //Logger.log("\(text)")
        Logger.log(content.description)
        let message = ChatMessage(text: (content["text"] as! String), sender: (content["sender"] as! String), imageUrl: "")
        /*var msg: ChatMessage!
        msg.text_ = (content["text"] as! String)
        msg.sender_ = (content["sender"] as! String)
        msg.date_ = NSDate(timeIntervalSince1970: (content["date"] as! Double))
        Logger.log(msg.description)*/
        return message
    }
    
}

