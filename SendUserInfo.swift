//
//  SendUserInfo.swift
//  WaterChat
//
//  Created by Bujar Tagani on 4/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class UserManager {

    var mp: MessagePasser!

    
    init(mp: MessagePasser) {
        self.mp = mp
    }
    
    func broadcastUserInfo(user : UserProfile) {

        var rcr = UserRequest()

//        rcr.userName = user.userName
//        rcr.isFemale = user.isFemale
//        rcr.birthDate = user.birthDate
//        rcr.moreInfo = user.moreInfo
        
        self.mp.broadcast(rcr)
    }
}