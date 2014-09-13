//
//  GroupsModel.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/12/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

/// Model intended for use with the Groups view
class GroupsModel: Model {
    
    /// Returns a dictionary with all the groups that a user is part of
    /// Returns an array of Group
    func getUserGroups(userID: String) -> [Group]? {
        var groups: [Group]?
        // TODO request user's groups
        // TODO take request results and add them to Group objects
        return groups
    }
    
    /// Returns if user was successfully removed from the group
    func sendLeaveGroup(userID: String, groupID: String) -> Bool {
        // TODO post leaving group
        return false
    }
    
}