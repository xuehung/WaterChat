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
        /*
        var mp = MessagePasser.getInstance(Config.address)
        var dest: MacAddr = 1
        mp.rm.sendRouteRequest(dest)
        */
        
        
        var mp = MessagePasser.getInstance(Config.address)
        
        var rr = RouteRequest()
        var from: MacAddr = Config.address + 1
        rr.destMacAddr = Config.address
        rr.origMacAddr = from
        rr.PREQID = 1
        rr.origSeqNum = 3
        rr.U = 1
        
        mp.rm.reveiveRouteRequest(from, message: rr)
    }
}
