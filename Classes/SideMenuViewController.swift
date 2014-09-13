//
//  SideMenuViewController.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import UIKit

class SideMenuViewController : UIViewController {

    @IBOutlet var segControl : UISegmentedControl?
    
    @IBAction func segControl(sender : AnyObject) {
        if let index = sender.selectedSegmentIndex {
            switch index {
            case 0 :
                ()
            case 1 :
                ()
            case 2 :
                ()
            default :
                ()
            }
        }
    }
    
    override func viewDidLoad()  {
        
    }

}