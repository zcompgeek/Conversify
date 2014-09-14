//
//  MasterViewController.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    

    var threads : [Conversation] = []
    var model : Model?
    //var refreshControl: UIRefreshControl!

    var currentGroup : Int!
    var currentTab : Int!
    var doneButton : UIBarButtonItem!
    @IBOutlet var plusButton: UIBarButtonItem!
    @IBOutlet var menuButton: UIBarButtonItem!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        currentGroup = 0
        currentTab = 0

        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    @IBAction func refresh(sender:AnyObject)
    {
        // Code to refresh table view
        if let refreshPull: UIRefreshControl = sender as? UIRefreshControl {
            refreshPull.endRefreshing()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        var source : NewThreadViewController = segue.sourceViewController as NewThreadViewController
        if let thread = source.threadToAdd {
                threads.append(thread)
                //replace with new thread command
                println("New Thread \(thread.name)")
                tableView.reloadData()
            
        }
    }
    
    @IBAction func unwindFromMenu(segue: UIStoryboardSegue) {
        var source : MenuViewController = segue.sourceViewController as MenuViewController
        if let seg = source.segNum {
            currentTab = seg
            println("On Seg \(seg)")
        }
        if let grp = source.grpNum {
            currentGroup = grp
            println("On Group \(grp)")
        }
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let buttonPress: AnyObject = sender {
            if buttonPress as? UIBarButtonItem == plusButton {return}
        }
        if let buttonPress: AnyObject = sender {
            if buttonPress as? UIBarButtonItem == menuButton {
                var destController : MenuViewController = (segue.destinationViewController as UINavigationController).viewControllers[0] as MenuViewController
                destController.segNum = currentTab
                destController.grpNum = currentGroup
                return
            }
        }
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let convo = threads[indexPath.row]
                (segue.destinationViewController as DetailViewController).detailItem = convo
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BCell", forIndexPath: indexPath) as UITableViewCell

        let convo = threads[indexPath.row]
        cell.textLabel?.text = convo.name
        return cell
    }
/*
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            threads.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
*/

}

