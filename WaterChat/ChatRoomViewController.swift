//
//  ChatRoomViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setToolbarHidden(false, animated: true)
        /*
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            // send your group message
            var rm = RoomManager()
            // get the message string from the screen
            var msg:String = "test"
            rm.sendToRoom(msg)
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            
            var mp = MessagePasser.getInstance(Config.address)
            
            while(true) {
                
                var x = mp.receive()
                // If message is JSON, add user to userList
                if (x is JSONMessage){
                    var xx = x as! JSONMessage
                    var type = xx.dict["type"] as! Int
                    var tt = MessageType(rawValue: UInt8(type))
                    if (tt == MessageType.ROOMTALK) {
                        var rm = RoomManager()
                        var msg = rm.JSONToMsg(xx.dict)
                        
                    }
                }
            }
        }*/

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func testtest(sender: UIButton) {
        // run this code when user presses test button
        println("hello it is test")
        var mp = MessagePasser.getInstance(Config.address)
        // send your group message
        var rm = RoomManager()
        // get the message string from the screen
        var msg:String = "test"
        rm.sendToRoom(msg)
    }

}
