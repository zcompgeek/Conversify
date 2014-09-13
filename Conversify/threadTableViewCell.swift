//
//  threadTableViewCell.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import UIKit

class threadTableViewCell : UITableViewCell {
    @IBOutlet var messageLabel : UILabel!
    @IBOutlet var senderLabel : UILabel!
    
    func loadItem(#message: String, sender: String) {
        messageLabel.text = message
        senderLabel.text = sender
    }
}
