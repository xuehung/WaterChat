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
        var r = RoomInfo()

        // send out the room request by JSONMessage
        var mdict = rm.RoomToJSON(r)
        println(NSJSONSerialization.isValidJSONObject(mdict));
        mp.broadcast(mdict)

        // receive the room request as JSONMessage
        var x = mp.receive()
        if (x is JSONMessage) {
            var xx = x as JSONMessage
            var t = xx.dict["type"] as Int
            var tt = MessageType(rawValue: UInt8(t))
            if (tt == MessageType.ROOMREQ) {
                var r = rm.JSONToRoom(xx.dict)
                println(r.name)
                println(r.groupID)
            }
        }
    }
}
