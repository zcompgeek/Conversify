//
//  Model.swift
//  Conversify
//
//  Created by Zach Costa on 9/12/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import Foundation
import UIKit

/// Parent model for Conversify, holds the high level functions.
class Model: LiveWebsocketProtocol, PassiveWebsocketProtocol {
    
    var curUser = User()
    var curGroups: [Group] = []
    var curMessages: [Message] = []
    var userAuthenticated = false

    // Note: Websocket needs a delegate to listen to requests, and my class structure
    // requires that delegate to have this model act as a delegate in return
    var liveWebsocket = Websocket(url: NSURL.URLWithString("ws://localhost:8080"))
    var passiveWebsocket = Websocket(url: NSURL.URLWithString("ws://localhost:8080"))
    var liveWebsocketDelegate : LiveWebsocketDelegate?
    var passiveWebsocketDelegate : PassiveWebsocketDelegate?
    
    init() {
        loadPersistentData()
        liveWebsocketDelegate = LiveWebsocketDelegate(listener: self)
        liveWebsocket.delegate = liveWebsocketDelegate
        liveWebsocket.connect()
        // identify the user to fully populate curUser
    }
    
    /// Loads data that was stored between sessions
    
    // +++++++++++ Initial Stuff +++++++++++
    
    func attemptAuthenticateUser() -> Bool {
        if curUser.userID == nil {
            return false
        }
        // TODO Ask server if this deviceID, userID pair is present instead of assuming
        // userID presence is true. If it's present, update phone, email, name
        return true
        
    }
    
    func pullAllData() {
        // TODO pull groups and messages based on userID
    }
    
    func loadPersistentData() {
        curUser.deviceID = UIDevice.currentDevice().identifierForVendor
        var storedVars = NSUserDefaults()
        curUser.userID = storedVars.stringForKey("userID")
        curUser.userPhone = storedVars.stringForKey("userPhone")
        curUser.userEmail = storedVars.stringForKey("userEmail")
        curUser.userName = storedVars.stringForKey("userName")
        userAuthenticated = attemptAuthenticateUser()
    }
    
    // +++++++++++ Live Websocket +++++++++++
    
    func onLiveWebsocketReceiveData(data: NSData) {
        println("App received data in live socket")
        // Call VC delegate that there's new data
    }
    
    func onLiveWebsocketReceiveMessage(text: String) {
        println("App received message '\(text)' in live socket")
        // Call VC delegate that there's new data
    }
    
    func sendLiveWebsocketMessage(text: String) {
        liveWebsocket.writeString(text)
    }
    
    func sendLiveWebsocketData(data: NSData) {
        liveWebsocket.writeData(data)
    }
    
    // +++++++++++ Passive Websocket +++++++++++
    
    // ----------- Groups -----------
    
    func leftGroup(groupID: String) {
        
    }
    
    func pullGroupData(groupID: String?) -> Group? {
        if groupID == nil {
            return nil
        }
        // TODO pull groupID's data
        return nil
    }
    
    func pullGroupsData() -> [Group]? {
        var result = [Group]?()
        var groupIDs = [String]() // TODO request user's groupID list
        for groupID in groupIDs {
           // result.append(pullGroupData(groupID))
        }
        return result
    }
    
    // ----------- User Settings (Modal) -----------
    // WARNING: if userAuthenticated is false, this needs to be updated before we do anything.
    
    func submitUserSettings(userID: String, userName: String, userEmail: String, userPhone: String) {
        curUser.userID = userID
        curUser.userName = userName
        curUser.userEmail = userEmail
        curUser.userPhone = userPhone
        userAuthenticated = attemptAuthenticateUser()
    }
    
    // ----------- CreateGroup (Modal) -----------
    
    // ----------- Conversations -----------
    
    // ----------- GroupSettings (Modal) -----------
    
    // ----------- Home -----------
    // TODO on load, initialize liveMessageSocket
    
    // ----------- Messages -----------
    
    // ----------- ComposeMessages -----------
    
}

