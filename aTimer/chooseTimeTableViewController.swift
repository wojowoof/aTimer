//
//  chooseTimeTableViewController.swift
//  aTimer
//
//  Created by Jack Woychowski on 1/19/16.
//  Copyright © 2016 Jack Woychowski. All rights reserved.
//

import UIKit

class chooseTimeTableViewController: UITableViewController {

    @IBOutlet weak var time30sec: UITextField!
    @IBOutlet weak var time1Min: UITextField!
    @IBOutlet weak var time2min: UITextField!
    @IBOutlet weak var time5min: UITextField!
    @IBOutlet weak var time10min: UILabel!

    var chosenTime: NSTimeInterval?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setChosenTime(timestring: String) {
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "mm:ss"
        dateformatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date = dateformatter.dateFromString(timestring)
        let zdate = dateformatter.dateFromString("00:00")
        let cal = NSCalendar.currentCalendar()
        let minsec = cal.components([NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: date!);
        print("Date from string ", timestring, " = ", date)
        print("Minsec: \(minsec.minute), \(minsec.second)")
        chosenTime = cal.dateFromComponents(minsec)?.timeIntervalSinceDate(zdate!);
        print("Chosen time is ", chosenTime)
    }

    func getChosenTime() -> Int {
        let chosenrow = self.tableView.indexPathsForSelectedRows![0].item
        print("Chosen row: ", chosenrow)
        let cell = self.tableView.cellForRowAtIndexPath(self.tableView.indexPathsForSelectedRows![0])
        let lbl = cell!.viewWithTag(7) as? UILabel
        let timestr = lbl!.text!
        print("Text at chosen row: ", timestr)

        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "mm:ss"
        dateformatter.timeZone = NSTimeZone(abbreviation: "UTC")
        let date = dateformatter.dateFromString(timestr)
        let cal = NSCalendar.currentCalendar()
        let minsec = cal.components([NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: date!);
        print("chosen: min \(minsec.minute), \(minsec.second)")
        return (60 * minsec.minute) + minsec.second
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected row at ", indexPath)
    }

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "chooseTimeDone" {
            if let paths = self.tableView.indexPathsForSelectedRows {
                if (paths[0].section != 0) {
                    print("Unknown section?")
                } else {
                    print("Row: ", paths[0].row)
                    if let cell = self.tableView.cellForRowAtIndexPath(paths[0]) {
                        let label = cell.viewWithTag(7) as? UILabel;
                        print("Text at row: ", label!.text!)
                        setChosenTime(label!.text!)
                    } else {
                        print("No cell?")
                    }
                }
            } else {
                print("No paths");
            }
        } else {
            print("Unknown segue ", segue, " ID ", segue.identifier)
        }
    }

}
