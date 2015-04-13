//
//  UserGroupViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class UserGroupViewController: UITabBarController {
    var profile = UserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()
        println("now in user group view")
        // Do any additional setup after loading the view.
        println(self.profile.userName)
        //println(self.profile.isFemale)
        println(self.profile.birthDate)
        println(self.profile.moreInfo)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            
            var mp = MessagePasser.getInstance(Config.address)
            
            while(true) {
                
                UserManager.announceUserInfo()
                
                sleep(5)
                
            }
            
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            
            var mp = MessagePasser.getInstance(Config.address)
            
            while(true) {
                
                var x = mp.receive()
                // If message is JSON, add user to userList
                if (x is JSONMessage){
                    var xx = x as JSONMessage
                    var type = xx.dict["type"] as Int
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func readUserInfoAndDoStuff(segue: UIStoryboardSegue){
        //CreateProfileViewController source =
        //UserProfile profile = source.profile
        println("now read")
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
