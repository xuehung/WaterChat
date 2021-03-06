//
//  User.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/5/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class User {
    var type: NSNumber;
    var name: NSString;
    var gender: NSString;
    var birthDate: NSString
    var moreInfo: NSString
//    var peerID: MCPeerID;
//    var phoneNumber: String;
//    var image: NSData? = nil;
    init(){
        self.type = -1
        self.name = ""
        self.gender = ""
        self.birthDate = ""
        self.moreInfo = ""
        
    }
    init(name: NSString, gender: NSString, birthDate: NSString, moreInfo: NSString) {
        self.type = NSNumber(unsignedChar: MessageType.USRPROFILE.rawValue)
        self.name = name;
        self.gender = gender;
        self.birthDate = birthDate
        self.moreInfo = moreInfo

    }

    
    
    
    func createJsonDict() -> NSMutableDictionary{
        var mdict = NSMutableDictionary()
        mdict.setObject(self.type, forKey: "type")
        mdict.setObject(self.name, forKey: "name")
        mdict.setObject(self.gender, forKey: "gender")
        mdict.setObject(self.birthDate, forKey: "birthDate")
        mdict.setObject(self.moreInfo, forKey: "moreInfo")
        
        return mdict
    }

}
