//
//  UserListViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var userListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("enter user list")
        userListTable.dataSource = self
        userListTable.delegate = self
        println("done")
        //userListTable.numberOfRowsInSection(1)
        //userListTable.tableFooterView
        // Do any additional setup after loading the view.
        //userListTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell {
        /*let cell = UITableViewCell()
        //let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        //label.text = "Hello Man"
        //cell.addSubview(label)
        cell.textLabel?.text = "Hello Man"
        return cell*/
        
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SizeCell", forIndexPath: indexPath) as UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = "Hello"
        /*if indexPath.row == selectedSizeIndex {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }*/
        
        return cell

    }

    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
