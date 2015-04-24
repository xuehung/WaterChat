//
//  CreateProfileViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/8/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var isFemale: UISegmentedControl!
    @IBOutlet weak var birthMM: UITextField!
    
    @IBOutlet weak var birthDD: UITextField!
    
    @IBOutlet weak var moreInfo: UITextField!
    
    @IBOutlet weak var joinBtn: UIBarButtonItem!
    
    
    var profile = UserProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println("create profile view controller")
        self.profile = UserProfile()
        //readData()
        
    }
    
    func readData(){

        var stringGender: NSString
        if (self.isFemale.isEnabledForSegmentAtIndex(0)){
            stringGender = "female"
        }
        else {
            stringGender = "male"
        }
        var user = User(name: self.userName.text, gender: stringGender, birthDate: self.birthMM.text+self.birthDD.text, moreInfo: self.moreInfo.text)
        UserManager.setCurrentUser(user)
        
        //user object ready for broadcast
        
        self.profile.userName = self.userName.text
        self.profile.isFemale = self.isFemale.isEnabledForSegmentAtIndex(0)
        self.profile.birthDate = self.birthMM.text+self.birthDD.text
        self.profile.moreInfo = self.moreInfo.text
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
        //if (sender != self.joinBtn) return
        if(self.userName.text.isEmpty){
            var alert = UIAlertController(title: "Could Not Join", message: "Username should not be empty", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            readData()
        }
        //self.profile.userName = "Ding"
        //println("hello segue")
        //var svc = segue.destinationViewController as UserGroupViewController;
        //svc.profile = self.profile
        //var svc = segue.destinationViewController as UserListTableViewController;
        //svc.profile = self.profile
    }
    

}
