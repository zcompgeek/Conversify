//
//  MenuViewController.swift
//  Conversify
//
//  Created by Zach Costa on 9/14/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

class MenuViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet var segControl : UISegmentedControl!
    var 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cells = detailItem {
            return cells.messages.count
        }
        println("error in table")
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:threadTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("threadCell") as threadTableViewCell
        
        // this is how you extract values from a tuple
        if let convo = detailItem {
            var message = convo.messages[indexPath.row].text
            cell.loadItem(message: message, sender: "Bob")
        }
        return cell
    }
    
}