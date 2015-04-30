//
//  CreateMyProfileTableViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/28/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class CreateMyProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var isMale: UISegmentedControl!
    
    @IBOutlet weak var userBirthday: UILabel!
    
    @IBOutlet weak var moreInfo: UITextField!
    
    
    var profile = UserProfile()
    
    override func viewDidLoad() {
        Logger.log("view start load");
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        // Do any additional setup after loading the view.
        //println("create profile view controller")
        self.profile = UserProfile()
        //readData()
        self.tableView.backgroundColor = UIColor(red: 1,
            green: 1,
            blue: 1,
            alpha: 1)
        Logger.log("view stop load");
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }*/

    @IBAction func selectedDate(segue:UIStoryboardSegue) {
        Logger.log("inside selected Date")
        let datePickerViewController = segue.sourceViewController as! BirthdayPickerViewController
        if let selectedBirthday = datePickerViewController.selectedBirthday {
                let dateFormatter = NSDateFormatter()
                var theDateFormat = NSDateFormatterStyle.ShortStyle
                dateFormatter.dateStyle = theDateFormat
                userBirthday.text = dateFormatter.stringFromDate(selectedBirthday)
        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    
    func readData(){
        
        var stringGender: NSString
        if(self.isMale.selectedSegmentIndex==0){
            stringGender = "male"
            Logger.log("male")
        }
        else{
            stringGender = "female"
            Logger.log("female")
        }
        
        var user = User(name: self.userName.text, gender: stringGender, birthDate: self.userBirthday.text!, moreInfo: self.moreInfo.text)
        UserManager.setCurrentUser(user)
        
        //user object ready for broadcast
        /*
        self.profile.userName = self.userName.text
        self.profile
        self.profile.birthDate = self.userBirthday.text!
        self.profile.moreInfo = self.moreInfo.text*/
    }
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        Logger.log("in segue")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //if (sender != self.joinBtn) return
        if(segue.identifier == "joinWaterChat"){
            if(self.userName.text.isEmpty){
                var alert = UIAlertController(title: "Could Not Join", message: "Username should not be empty", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else{
                readData()
            }
        }
        else if(segue.identifier == "selectBirthday"){
            Logger.log("selectBirthday")
        }
        //self.profile.userName = "Ding"
        //println("hello segue")
        //var svc = segue.destinationViewController as UserGroupViewController;
        //svc.profile = self.profile
        //var svc = segue.destinationViewController as UserListTableViewController;
        //svc.profile = self.profile
    }
    

}
