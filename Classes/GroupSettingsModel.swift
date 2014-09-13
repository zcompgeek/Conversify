//
//  GroupSettingsModel.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

/// Model intended for use with the Group Settings Modal
class GroupSettingsModel {
    
    // from parent: func sendLeaveGroup(userID: String, groupID: String) -> Bool
    
    func sendAddMember(userID: String) -> Bool {
        // TODO send request
        return false
    }
    
    func sendRemoveMember(userID: String) -> Bool {
        // TODO send request
        return false
    }
    
    func sendAddAdmin(userID: String) -> Bool {
        // TODO send request
        return false
    }
    
    func sendRemoveAdmin(userID: String) -> Bool {
        // TODO send request
        return false
    }
    
    /// Grabs userIDs and adminIDs and populates the appropriate group fieldswith them
    func getSettings(userID: String, inout group: Group) -> Bool {
        // TODO send request
        return false
    }
    
    func sendUpdateGroupName(groupID: String, groupName: String) -> Bool {
        // TODO send request
        return false
    }
}
