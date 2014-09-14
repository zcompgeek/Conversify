//
//  Conversation.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

class Conversation {
    var name : String!
    var messages : [Message]
    
    init(name: String) {
        self.name = name
        messages = []
    }
}
