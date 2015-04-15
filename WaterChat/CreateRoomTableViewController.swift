//
//  CreateRoomTableViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class CreateRoomTableViewController: UITableViewController {

    
    @IBOutlet weak var roomName: UITextField!
    @IBOutlet weak var subjectLabel: UILabel!
    
    var size:Int = 10
    //var room = RoomInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectLabel.text = String(size)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectedSize(segue:UIStoryboardSegue) {
        let sizePickerViewController = segue.sourceViewController as SizePickerTableViewController
        if let selectedSize = sizePickerViewController.selectedSize {
            subjectLabel.text = String(selectedSize)
            size = selectedSize
        }
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            roomName.becomeFirstResponder()
        }
    }
    
    @IBAction func cancelToRoomsViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveRoomDetail(segue:UIStoryboardSegue) {
        println("in func create new room")
        println("name: \(self.roomName.text)")
        println("size: \(self.size)")
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

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
        
        /*var stringGender: NSString
        if (self.isFemale.isEnabledForSegmentAtIndex(0)){
            stringGender = "female"
        }
        else {
            stringGender = "male"
        }*/
        var room = RoomInfo(name: self.roomName.text, maxNum: self.size)
        var rm = RoomManager()
        rm.addRoomToList(room)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        println("in segue")
        println(segue.identifier)
        if (segue.identifier == "PickMaximumSize"){
            println("pick size")
        }
        else if (segue.identifier == "SaveRoomDetail") {
            readData()
            //room.name = self.roomName.text
            //room.maximumNumber = self.
            //player = Player(name: self.nameTextField.text, game: "Chess", rating: 1)
            println("create new room")
            println("name: \(self.roomName.text)")
            println("size: \(self.size)")
        }
        else{
            println("just cancel")
        }
        
    }
    

}
