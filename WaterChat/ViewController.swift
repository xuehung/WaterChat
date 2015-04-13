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
        /*
        var rr = RoomRequest()
        //rr.groupName = "hi"
        rr.groupID = 45
        mp.broadcast(rr)
        */
        //println(NSJSONSerialization.isValidJSONObject(dict));

        //println(NSJSONSerialization.isValidJSONObject(u));


//        var name: NSString = "Bill Nace"
//        var type = NSNumber(unsignedChar: MessageType.USRPROFILE.rawValue)
//
//        var mdict = NSMutableDictionary()
//
//        mdict.setObject(type, forKey: "type")
//        mdict.setObject(name, forKey: "name")
//        println(NSJSONSerialization.isValidJSONObject(mdict));
//        mp.broadcast(mdict)
        
//        var x = mp.receive()
//        if (x is JSONMessage) {
//            println("is json msg")
//            var xx = x as JSONMessage
//            println(xx.dict["name"])
//            }
//        else {
//            println("is not json msg")
//            }
        
        var rm = RoomManager()
        
        // send out the room request by JSONMessage
        var mdict = rm.RoomToJSON()
        println(NSJSONSerialization.isValidJSONObject(mdict));
        mp.broadcast(mdict)
        
        // receive the room request as JSONMessage
        var x = mp.receive()
        if (x is JSONMessage) {
            var xx = x as JSONMessage
            var type = xx.type
            if (type == MessageType.ROOMREQ) {
                var r = rm.JSONToRoom(xx.dict)
                println(r.name)
                println(r.groupID)
            }
        }
        
    }
}
