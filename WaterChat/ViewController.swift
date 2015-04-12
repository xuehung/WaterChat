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
        var rr = RoomRequest()
        rr.groupName = "hi"
        
        //testing json stuff
//        var user = UserProfile()
//        user.userName = "btagani"
//        user.birthDate = "7/22/91"
//        user.type = MessageType.USER
//        user.moreInfo = "hello"
//        user.isFemale = false
//        var error: NSError?;
//        var response: AnyObject? = NSJSONSerialization.JSONObjectWithData(user, options: NSJSONReadingOptions(), error: &error);
//        println("TEST")
//        if let personDictionary = response as? NSDictionary {
//            //            username = personDictionary["userName"] as? String;
//            //            birth = personDictionary["birthDate"] as? String;
//            println(personDictionary["userName"])
//            println(personDictionary["birthDate"])
//        }

        
    }
}
