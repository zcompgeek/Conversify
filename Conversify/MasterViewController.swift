//
//  MasterViewController.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects : [[String]] = []


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        var objectsEntry = ["Look at this awesomse email this awesomse email this awesomse email this awesomse email this awesomse email this awesomse email","Look at this awesomse email","Look at this awesomse email","Look at this awesomse email this awesomse email this awesomse email this awesomse email this awesomse email this awesomse email","Look at this awesomse email","Look at this awesomse email","Look at this awesomse email"]
        objects.insert(objectsEntry, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row]
                (segue.destinationViewController as DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BCell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel?.text = object[0]
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

