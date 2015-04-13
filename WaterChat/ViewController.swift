//
//  ViewController.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 2/26/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import ExternalAccessory


class ViewController: UIViewController {
    @IBOutlet var chatView: UITextView!
    @IBOutlet var messageField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func test(sender: UIButton) {
        // run this code when user presses test button
        println("hello it is test")
        var mp = MessagePasser.getInstance(Config.address)

            /*  USER TESTING    */
        
//        var u = User(name: "BUJAR", gender: "MALE", birthDate: "72291", moreInfo: "NONE")
//        var mdict = u.createJsonDict()
//
//        UserManager.addUserToList(u)
        
        
        //announce current my user info
        UserManager.announceUserInfo()

        var x = mp.receive()
        
        // If message is JSON, add user to userList
        if (x is JSONMessage){
        
        var newUser = UserManager.JsonToUserObject(x)
            UserManager.addUserToList(newUser)
        }
        
        println("All Users: ")
        // print out all current users
        for element in userList{
            println(element.name)
        }

    }
}
