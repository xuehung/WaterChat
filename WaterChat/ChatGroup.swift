//
//  ChatGroup.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class ChatGroup: NSObject {
    var groupName = String()
    var userList = [UserProfile]()
    var currentSize = 1
    var maxSize = 10
}
