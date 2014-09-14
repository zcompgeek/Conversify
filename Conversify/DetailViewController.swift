//
//  DetailViewController.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
                            
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var optInSwitch: UISwitch!

    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        var source : NewMessageViewController = segue.sourceViewController as NewMessageViewController
        if let message = source.messageToSend {
            if let cells = detailItem {
                //replace with send command
                cells.messages.append(message)
                tableView.reloadData()
            }
        }
    }

    var detailItem: Conversation? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        if let thread : Conversation = self.detailItem {
            optInSwitch.on = thread.optIn
        }
        
        
        
    }

    override func willMoveToParentViewController(parent: UIViewController?) {
        if let thread : Conversation = detailItem {
            thread.optIn = optInSwitch.on
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        var nib = UINib(nibName: "threadTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "threadCell")
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
    
    func acceptNewMessage(message: Message) {
        threadToAdd.messages.append(message)
        tableView.reloadData()
    }

}

