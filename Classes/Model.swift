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
    var curConverserations: [Conversation] = []
    var curMessages: [Message] = []
    var userAuthenticated = false
    var passiveWebsocket, liveWebsocket : Websocket
    

    // Note: Websocket needs a delegate to listen to requests, and my class structure
    // requires that delegate to have this model act as a delegate in return
    var liveWebsocketLink = "ws://conversify.herokuapp.com/broadcast"
    var passiveWebsocketLink = "ws://conversify.herokuapp.com/update"
    var liveWebsocketDelegate: LiveWebsocketDelegate?
    var passiveWebsocketDelegate: PassiveWebsocketDelegate?
    var liveWebsocketState = 0, passiveWebsocketState = 0
    
    init() {
        passiveWebsocket = Websocket(url: NSURL.URLWithString(passiveWebsocketLink))
        liveWebsocket = Websocket(url: NSURL.URLWithString(liveWebsocketLink))
        
        passiveWebsocketDelegate = PassiveWebsocketDelegate(listener: self)
        passiveWebsocket.delegate = passiveWebsocketDelegate
        passiveWebsocket.connect()
        
        liveWebsocketDelegate = LiveWebsocketDelegate(listener: self)
        liveWebsocket.delegate = liveWebsocketDelegate
        liveWebsocket.connect()
        
        loadPersistentData()
    }
    
    // +++++++++++ Initial Stuff +++++++++++
    
    func attemptAuthenticateUser() -> Bool {
        println("authenticating")
        if curUser.userID == nil {
            return false
        }
        var request = [
            "methodName":"authenticateUser",
            "arguments":[curUser.userID!, curUser.deviceID!]
        ]
        sendPassiveWebsocketMessage(request)
        return true
        
    }
    
    func pullAllData() {
        // TODO pull all groups
        // TODO pull all convos
        // TODO pull all messages
    }
    
    /// Loads data that was stored between sessions
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
    
    func onLiveWebsocketReceiveMessage(text: String) {
        println("App received message '\(text)' in live socket")
        var obj = JSON.parse(text)["object"]
        var message = Message(obj["message_id"], obj["sender_id"], obj["content"], obj["time_update"])
        /*// get conversation instance from id:
        convo = conversations[obj["conversation_id"]]
        if (convo != nil) {
            convo.messages.append(message)
            // tell view to update if the correct conversation is currently open
        }*/
    }
    
    func sendLiveWebsocketMessage(obj: AnyObject) {
        liveWebsocket.writeString(JSON(obj).toString())
    }
    
    func setLiveWebsocketState(state: Int) {
        liveWebsocketState = state
    }
    
    func warnWebsocketWriteFail(error: NSError?) {
        println("WRITE FAILED. Error: \(error)")
    }
    
    // +++++++++++ Passive Websocket +++++++++++
    
    func onPassiveWebsocketReceiveMessage(text: String) {
        println("App received message '\(text)' in passive socket")
        var obj = JSON.parse(text)["object"]
        if ((obj[1][0].asString == "failure") || obj[1][0].isNull) {
            println("Failed query. \(obj)")
            return
        }
        var method = obj["methodName"].asString
        if method == "authenticateUser" {
            userAuthenticated = obj[1][1].asString == "true" ? 1 : 0
        }
    }
    
    func sendPassiveWebsocketMessage(obj: AnyObject) {
        println("\(JSON(obj).toString())")
        passiveWebsocket.writeString(JSON(obj).toString())
    }
    
    func setPassiveWebsocketState(state: Int) {
        passiveWebsocketState = state
    }
    
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
    
    // ----------- User Settings -----------
    // Note that init places us in an infinite loop on the func that calls this submit until we successfully authenticate w/ db
    
    func submitRegistration(userID: String, userName: String, userEmail: String, userPhone: String) {
        curUser.userID = userID
        curUser.userName = userName
        curUser.userEmail = userEmail
        curUser.userPhone = userPhone
        var curTime: NSDate = NSDate.date()
        var request = [
            "methodName":"updateUser",
            "arguments": [
                userID, userName, userEmail, userPhone,
                curUser.deviceID!, curTime
            ]
        ]
        sendPassiveWebsocketMessage(request)
    }
    
    // ----------- Login -----------
    
    func attemptLogin(userID: String, userPhone: String) -> Bool {
        if userAuthenticated == 0 {
            attemptAuthenticateUser()
        } else {
            return true
        }
        var counter = 0
        while userAuthenticated != 1 && counter < 5 {
            sleep(1)
            counter++
        }
        return userAuthenticated
    }
    
    // ----------- CreateGroup (Modal) -----------
    
    // ----------- Conversations -----------
    
    // ----------- GroupSettings (Modal) -----------
    
    // ----------- Home -----------
    
    // ----------- Messages -----------
    
    // ----------- ComposeMessages -----------
    
}

