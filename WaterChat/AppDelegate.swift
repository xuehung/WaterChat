//
//  AppDelegate.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 2/26/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        println("Hello Water")
        var mp = MessagePasser.getInstance(Config.address)
        reader()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func reader() {
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
                        var rm = RoomManager()
                        var msg = rm.JSONToMsg(xx.dict) as ChatMessage
                        //var cr = ChatRoomViewController()
                        //cr.receiveMessage(msg)
                        chatMessages.append(msg)
                        //var cr = ChatRoomViewController()
                        //cr.finishReceivingMessage()
                        Logger.log(xx.dict.description)
                        //Util.roomvc.finishReceivingMessage()
                        if self.window?.rootViewController is ChatRoomViewController {
                            var x = self.window?.rootViewController as! ChatRoomViewController
                            x.finishReceivingMessage()
                        }
                        else{
                            Logger.log("WWWWW@@@@@@@@@@@@@@@@@@@@badddddddddddddddd")
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



}

