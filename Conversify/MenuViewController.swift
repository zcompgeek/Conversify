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
    var groups : ([Group])!
    var segNum : Int!
    var grpNum : Int!
    let model : Model = (UIApplication.sharedApplication().delegate as AppDelegate).model!
    
    override func viewDidLoad() {
        var groupList: [Group] = []
        for (groupID, groupObj) in model.curGroups {
            groupList.append(groupObj!)
        }
        groups = groupList
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: grpNum, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
        segControl.selectedSegmentIndex = segNum
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        grpNum = tableView.indexPathForSelectedRow()?.item
        segNum = segControl.selectedSegmentIndex
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("groupCell", forIndexPath: indexPath) as UITableViewCell
        
        if let label = cell.textLabel {
            label.text =  groups[indexPath.row].groupName
            label.textAlignment = NSTextAlignment.Center
        }
        
        
        return cell
    }
    
    
}