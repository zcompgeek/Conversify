//
//  Conversation.swift
//  Conversify
//
//  Created by Zach Costa on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

class Conversation {
    var conversation_id : Int!
    var name : String!
    var messages : [Message]
    var optIn: Bool
    
    init(conversation_id: Int, name: String) {
        self.conversation_id = conversation_id
        self.name = name
        messages = []
        optIn = true
    }
}
