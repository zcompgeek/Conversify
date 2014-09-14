//
//  NewMessageViewController.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

class NewMessageViewController : UIViewController {
    
    var messageToSend : Message!
    
    @IBOutlet weak var messageField: UITextView!
    
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let buttonPress: AnyObject = sender {
            if buttonPress as? UIBarButtonItem != sendButton {return}
        }
        if (!messageField.text.isEmpty) {
            messageToSend = Message(message_id: 0, sender_id: 0, text: messageField.text, timestamp: 10 )
        }
        
    }
}
