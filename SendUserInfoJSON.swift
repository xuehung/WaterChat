//
//  SendUserInfo.swift
//  WaterChat
//
//  Created by Bujar Tagani on 4/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class UserManagerJSON {
    
    var mp: MessagePasser!
    
    
    init(mp: MessagePasser) {
        self.mp = mp
    }
    
    func broadcastUserInfoJSON() {
        var user = UserProfile()
        user.userName = "btagani"
        user.birthDate = "7/22/91"
        let data: NSData = user
//        var username = "b"
//        var birth = "a"
        var error: NSError?;
        var response: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error);
        
        if let personDictionary = response as? NSDictionary {
//            username = personDictionary["userName"] as? String;
//            birth = personDictionary["birthDate"] as? String;
            println(personDictionary["userName"])
            println(personDictionary["birthDate"])
        }
//        println(username)
//        println(birth)
        var rcr = UserRequest()
        
        //        rcr.userName = user.userName
        //        rcr.isFemale = user.isFemale
        //        rcr.birthDate = user.birthDate
        //        rcr.moreInfo = user.moreInfo
        
        self.mp.broadcast(rcr)
    }
    
    // Receive a creation request
    func receiveRoomReq(from: MacAddr, message: RoomRequest) {
        
        
        
    }
    
    // Receive creation acknowledgement
    func receiveRoomAck() {
    }
}