//
//  UserRequest.swift
//  WaterChat
//
//  Created by Bujar Tagani on 4/11/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//


import Foundation
import MultipeerConnectivity

//    0               1               2               3
//    0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |     Type      |               |                |              |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                          UserName                             |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                          Birthdate                            |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                          More Info                            |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
//   |                           Gender                              |
//   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


class UserRequest: Message {
    
    let SIZE = 32
    
    var user = UserProfile()
    
    var userName = String()
    var isFemale = false
    var birthDate = String()
    var moreInfo = String()
    
    override init() {

        self.userName = user.userName
        self.isFemale = user.isFemale
        self.birthDate = user.birthDate
        self.moreInfo = user.moreInfo
        super.init()
    }
    
    override init(bytes data: NSData) {
        
        var user = UserProfile()
        self.userName = user.userName
        self.isFemale = user.isFemale
        self.birthDate = user.birthDate
        self.moreInfo = user.moreInfo

        data.getBytes(&self.userName, range: NSMakeRange(4, 4))
        data.getBytes(&self.birthDate, range: NSMakeRange(8, 4))
        data.getBytes(&self.moreInfo, range: NSMakeRange(12, 4))
        println(self.userName)
        println(self.birthDate)
        println(self.moreInfo)
        var content: [UInt8] = Util.toByteArray(data) + Util.toByteArray(self.userName)
        var nsData = NSMutableData()
        nsData.appendBytes(content, length: content.count)
        super.init(bytes: nsData)
    }
    
    override func serialize() -> NSData {
        var array = [UInt8](count: SIZE, repeatedValue: 0)
        array[0] = MessageType.USER.rawValue

        var uint32P =  UnsafeMutablePointer<String>(array)
        uint32P[1] = self.userName
        var nsData = NSData(bytes: array, length: SIZE)
        return nsData
    }
}