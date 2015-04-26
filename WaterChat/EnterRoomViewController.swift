//
//  EnterRoomViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/25/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class EnterRoomViewController: UINavigationController {
    var curRoom = RoomInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("enter room vc room name \(curRoom.name)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Logger.log("in enterroom nav segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var svc = segue.destinationViewController as! ChatRoomViewController;
        svc.curRoom = curRoom
    }*/


}
