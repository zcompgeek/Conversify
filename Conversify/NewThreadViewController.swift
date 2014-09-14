//
//  NewThreadViewController.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

class NewThreadViewController : UIViewController {
    
    var threadToAdd : Conversation!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let buttonPress: AnyObject = sender {
            if buttonPress as? UIBarButtonItem != doneButton {return}
        }
        if (!nameField.text.isEmpty) {
            //threadToAdd = Conversation()
        }
        
    }
}