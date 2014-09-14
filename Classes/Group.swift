//
//  Group.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

/// Instances of this class hold details of a group
class Group {
    var groupID, groupName: String?
    var userIDs, adminIDs: Set<String>?
    
    init(name: String) {
        groupName = name
    }
    
    func addUser(userID: String) {
        userIDs?.addElement(userID)
    }
    
    func removeUser(userID: String) {
        userIDs?.removeElement(userID)
    }
    
    func addAdmin(adminID: String) {
        adminIDs?.addElement(adminID)
    }
    
    func removeAdmin(adminID: String) {
        adminIDs?.removeElement(adminID)
    }
    
}
