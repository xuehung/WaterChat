//
//  UserGroupViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class UserGroupViewController: UITabBarController {
    var profile = UserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()
        println("now in user group view")
        // Do any additional setup after loading the view.
        println(self.profile.userName)
        println(self.profile.isFemale)
        println(self.profile.birthDate)
        println(self.profile.moreInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func readUserInfoAndDoStuff(segue: UIStoryboardSegue){
        //CreateProfileViewController source =
        //UserProfile profile = source.profile
        println("now read")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
