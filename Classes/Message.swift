//
//  Message.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

class Message {
    var text : String!
    var message_id : Int!
    var sender_id : Int!
    var timestamp : Int!
    
    init(message_id: Int, sender_id: Int, text: String, timestamp: Int) {
        self.message_id = message_id
        self.sender_id = sender_id
        self.text = text
        self.timestamp = timestamp
    }
}