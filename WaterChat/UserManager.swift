//
//  UserManager.swift
//  WaterChat
//
//  Created by Bujar Tagani on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

var userList = [User]()
var currentUserInfo: User = User()

class UserManager{
    class func setCurrentUser(user: User){
        currentUserInfo = user
    }
    
    class func announceUserInfo() {
        var mp = MessagePasser.getInstance(Config.address)
        var mdict = currentUserInfo.createJsonDict()      //commented out for testing
        //var u = User(name: "BUJAR", gender: "MALE", birthDate: "72291", moreInfo: "NONE")
        //var mdict = u.createJsonDict()
        println("announcing")
        println(mdict)
        mp.broadcast(mdict)
    }
    
    class func addUserToList(newUser: User) {
        var exists = false
        for element in userList{
            if element.macAddress == newUser.macAddress {
                exists = true
                // Whether needs to change the user information
            }
        }
        if (!exists){
            userList.append(newUser)
        }
    }
    
    class func JsonToUserObject(data: Message) -> User {
        var user = User()
        var json = data as! JSONMessage
        user.name = json.dict["name"] as! NSString
        user.birthDate = json.dict["birthDate"] as! NSString
        user.gender = json.dict["gender"] as! NSString
        user.moreInfo = json.dict["moreInfo"] as! NSString
        user.macAddress = json.dict["macAddress"] as! NSString

        return user
}
}