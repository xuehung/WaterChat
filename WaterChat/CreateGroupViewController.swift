//
//  CreateGroupViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var groupName: UITextField!
    
    @IBOutlet weak var userList: UIScrollView!
    
    var group = ChatGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func readData(){
        self.group.groupName = self.groupName.text
        //self.group.userList.append(<#newElement: T#>)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        readData()
        //self.profile.userName = "Ding"
        println("hello segue")
        //var svc = segue.destinationViewController as UserGroupViewController(to change);
        //svc.group = self.group

    }
    

}
