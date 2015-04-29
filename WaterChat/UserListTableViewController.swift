//
//  UserListTableViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class UserListTableViewController: UITableViewController {
    
    //var users: [User] = userList
    //var refreshControl:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        println("enter user list table table")
        println(userList.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //self.refreshControl = UIRefreshControl()
        //self.refreshControl?.attributedTitle=NSAttributedString(string: "Pull to refresh")
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        //self.tableView.addSubview(refreshControl!)
        //self.tableView.addSubview(self.refreshControl)
    }

    func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        self.tableView.reloadData()
        Logger.log("refresh")
        Logger.log("userList.count = \(userList.count)")
        self.refreshControl?.endRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return userList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("fill in cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
            as! UITableViewCell
        let user = userList[indexPath.row] as User
        cell.textLabel?.text = user.name as String
        cell.detailTextLabel?.text = user.moreInfo as String
        return cell
    }
    
    
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
    }*/
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //let room = groupList[indexPath.row] as RoomInfo
        
        let row = indexPath.row
        println(row)
        let talkTo = userList[row] as User
        var room = RoomInfo(name: talkTo.name as String, maxNum: 2, privateRoom: true)
        room.memberList.append(talkTo.macAddress as String)
        //var rm = RoomManager()
        //rm.addRoomToList(room)
        currentRoomInfo = room
        
        
        //var rm = RoomManager()
        //let curRoom = rm.enterOneRoom(row)
        //let vc = self.storyboard!.instantiateViewControllerWithIdentifier("chatroomview") as! UIViewController
        //var vc = ChatRoomViewController()
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("chatroomview") as! UIViewController
        //globalCurRoom = curRoom
        //self.showViewController(vc, sender: vc)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    

}
