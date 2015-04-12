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
        var x = mp.receive()
        if x is RoomRequest {
            var xx = x as RoomRequest
            println(xx.name)
        } else {
            println("fail")
            var xx = x as RoomRequest
            println(xx.name)
        }
        
    }
}
