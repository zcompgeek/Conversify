//
//  Message.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

class Message {
    var text : String!
    var message_id : int!
    var sender_id : int!
    var timestamp : int!
    
    init(message_id: int, sender_id: int, text: String, timestamp: int) {
        self.message_id = message_id
        self.sender_id = sender_id
        self.text = text
        self.timestamp = timsetamp
    }
}