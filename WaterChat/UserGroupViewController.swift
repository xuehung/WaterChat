//
//  UserGroupViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

var isBroadcasting = false
var isReceiving = false

class UserGroupViewController: UITabBarController {
    //var profile = UserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()
        println("now in user group view")
        println("current user is \(currentUserInfo.name) \((currentUserInfo.macAddress as String))")
        // Do any additional setup after loading the view.
        //println(self.profile.userName)
        //println(self.profile.isFemale)
        //println(self.profile.birthDate)
        //println(self.profile.moreInfo)
        if(!isBroadcasting){
            setUpBroadcast()
            isBroadcasting = true
        }
        if(!isReceiving){
            setUpReceiver()
            isReceiving = true
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func readUserInfoAndDoStuff(segue: UIStoryboardSegue){
        //CreateProfileViewController source =
        //UserProfile profile = source.profile
        println("now read")
    }

    func setUpBroadcast(){
        Logger.log("broadcasting")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            
            while(true) {
                
                UserManager.announceUserInfo()
                
                var rm = RoomManager()
                rm.announceRoomInfo()
                
                sleep(5)
                
            }
            
        }
    }
    
    func setUpReceiver(){
        Logger.log("set up receive")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            
            var mp = MessagePasser.getInstance(Config.address)
            
            while(true) {
                
                var x = mp.receive()
                // If message is JSON, add user to userList
                if (x is JSONMessage) {
                    var xx = x as! JSONMessage
                    var type = xx.dict["type"] as! Int
                    var tt = MessageType(rawValue: UInt8(type))
                    if (tt == MessageType.USRPROFILE) {
                        var newUser = UserManager.JsonToUserObject(x)
                        UserManager.addUserToList(newUser)
                    }
                    else if (tt == MessageType.ROOMREQ) {
                        var rm = RoomManager()
                        var newRoom = rm.JSONToRoom(xx.dict)
                        rm.addRoomToList(newRoom)
                    }
                    else if (tt == MessageType.RMVUSER) {    //remove from userList if there
                        var lostPeer = UserManager.JsonToUserObject(x)
                        var i = 0
                        for element in userList{
                            if element.macAddress == lostPeer.macAddress{
                                userList.removeAtIndex(i)
                                //can also add ability to remove from groups they belong to. If we add GroupsBelongingTo in the User Class, you can then remove from all of these groups.
                                break
                            }
                            i = i+1
                        }
                    }
                    else if (tt == MessageType.ROOMRMV) {
                        var rm = RoomManager()
                        var rmvRoom = rm.JSONToRoom(xx.dict)
                        var i = 0
                        for room in groupList {
                            if (rmvRoom.name == room.name) {
                                groupList.removeAtIndex(i)
                                break
                            }
                            i += 1
                        }
                    }
                    else if (tt == MessageType.ROOMTALK) {
                        //events.trigger("receive", information: "receives new chat msg")
                        
                        var rm = RoomManager()
                        var msg = rm.JSONToMsg(xx.dict) as ChatMessage
                        
                        if (xx.dict["mac"] == nil) {
                            
                        //var cr = ChatRoomViewController()
                        //cr.receiveMessage(msg)
                            chatMessages.append(msg)
                            chatMessages = sorted(chatMessages) {
                                (o1, o2) in
                                let m1 = o1 as ChatMessage
                                let m2 = o2 as ChatMessage
                                if (m1.date_.compare(m2.date_) == NSComparisonResult.OrderedSame || m1.date_.compare(m2.date_) == NSComparisonResult.OrderedAscending) {
                                    return true
                                }
                                return false
                            }
                            
                        //var cr = ChatRoomViewController()
                        //cr.finishReceivingMessage()
                            Logger.log(xx.dict.description)
                        //Util.roomvc.finishReceivingMessage()
                            Logger.log("triggerssssssssssssssssss")
                            //events.trigger("receive", information: "receives new chat msg")
                        //receiveNewChat = true
                        } else {
                            // it is 1-1 talk
                            Logger.log("Got personal message")
                            var mac: MacAddr = Util.convertDisplayNameToMacAddr(xx.dict["mac"] as! String)
                            One2OneCommunication.addMessage(mac, message: msg)
                            
                        }
                        
                    }
                    println("All Users: ")
                    // print out all current users
                    for element in userList{
                        println(element.name)
                    }
                    // print out all public rooms
                    println("All Rooms: ")
                    for room in groupList{
                        println(room.name)
                    }
                    
                }
                
            }
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
