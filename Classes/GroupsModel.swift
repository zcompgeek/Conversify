//
//  GroupsModel.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/12/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

/// Model intended for use with the Groups view
class GroupsModel {
    
    /// Updates groups with all groups that a user is part of
    func getUserGroups(userID: String, groups: [Group]) -> Bool {
        // TODO request user's groups and put them in groups
        return false
    }
    
    /// Returns if user was successfully removed from the group
    func sendLeaveGroup(userID: String, groupID: String) -> Bool {
        // TODO post leaving group
        return false
    }
    
}