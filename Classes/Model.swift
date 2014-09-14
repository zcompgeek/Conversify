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
    var curGroups: [String:Group?] = Dictionary<String,Group?>()
    var curGroupToConversations: [String:Conversation?] = Dictionary<String,Conversation?>()
    var curMessages: [String:Message] = Dictionary<String,Message>()
    var userAuthenticated = false
    var messagesLoaded = false
    var passiveWebsocket, liveWebsocket : Websocket
    var waitingOnPull = 0
    

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
    
    func attemptAuthenticateUser() {
        println("authenticating ID:\(curUser.userID)")
        if curUser.userID == nil {
            return
        }
        var request = [
            "method":"authenticateUser",
            "arguments":[curUser.userID!, curUser.deviceID!]
        ]
        sendPassiveWebsocketMessage(request)
        
    }
    
    func pullAllData() {
        getGroupsForUser(curUser.userID!)
        waitingOnPull = 1
        while waitingOnPull != 0 {
            sleep(1)
        }
        for groupid in curGroups.keys {
            getConversationsByGroupID(groupid)
        }
        waitingOnPull = 1
        while waitingOnPull != 0 {
            sleep(1)
        }
        // TODO pull all groups
        // TODO pull all convos
        // TODO pull all messages
    }
    
    /// Loads data that was stored between sessions
    func loadPersistentData() {
        curUser.deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
        var storedVars = NSUserDefaults.standardUserDefaults()
        curUser.userID = storedVars.objectForKey("userID") as? String
        curUser.userPhone = storedVars.objectForKey("userPhone") as? String
        curUser.userEmail = storedVars.objectForKey("userEmail") as? String
        curUser.userName = storedVars.objectForKey("userName") as? String
    }
    
    // +++++++++++ Live Websocket +++++++++++
    
    func onLiveWebsocketReceiveMessage(text: String) {
        println("App received message '\(text)' in live socket")
        var obj = JSON.parse(text)["object"]
       // var message : Message = Message(obj["message_id"], obj["sender_id"], obj["content"], obj["time_update"])
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
        var obj = JSON.parse(text)
        if ((obj[1][0].asString == "failure") || obj[1][0].isNull) {
            println("Failed query. \(obj)")
            return
        }
        println(obj)
        var method = obj["methodName"].asString!
        println(method)
        if method == "authenticateUser" {
            userAuthenticated = obj["results"][1].asString == "true" ? 1 : 0
        } else if method == "addUser" {
            curUser.userID = obj["results"][1].asString
            var storedVars = NSUserDefaults.standardUserDefaults()
            storedVars.setObject(curUser.userID, forKey: "userID")
        } else if method == "getGroupsForUser" {
            curGroups = Dictionary<String,Group?>()
            for i in 1..<obj["results"].length {
                println(i)
                println(obj["results"][i].asString!)
                curGroups[(obj["results"][i].asString)!] = Group(name: (obj["results"][i].asString)!)
            }
            println(curGroups)
            waitingOnPull = 0
        } else if method == "getConversationsForGroup" {
            curGroupToConversations = Dictionary<String,Conversation?>()
            for i in 1..<obj["results"].length {
                println(i)
                println(obj["results"][i].asString!)
                curGroupToConversations[(obj["results"][i][6].asString)!] = Conversation(conversation_id: (obj["results"][i][0].asInt)!, name: (obj["results"][i][1].asString)!)
            }
            println(curGroupToConversations)
            waitingOnPull = 0
        }
    }
    
    func sendPassiveWebsocketMessage(obj: AnyObject) {
        var str = JSON(obj).toString()
        println(str)
        passiveWebsocket.writeString(str)
    }
    
    func setPassiveWebsocketState(state: Int) {
        passiveWebsocketState = state
    }
    
    // ----------- Groups -----------
    
    func leftGroup(groupID: String) {
        
    }
    
    func getGroupsForUser(userID : String) {
        var request = [
            "method":"getGroupsForUser",
            "arguments":[userID]
        ]
        sendPassiveWebsocketMessage(request)
    }
    
    // ----------- User Settings -----------
    // Note that init places us in an infinite loop on the func that calls this submit until we successfully authenticate w/ db
    
    func submitRegistration(userName: String, userEmail: String, userPhone: String) {
        var storedVars = NSUserDefaults.standardUserDefaults()
        curUser.userName = userName
        curUser.userEmail = userEmail
        curUser.userPhone = userPhone
        storedVars.setObject(userName, forKey: "userName")
        storedVars.setObject(userEmail, forKey: "userEmail")
        storedVars.setObject(userPhone, forKey: "userPhone")
        var curTime = NSDate.date().timeIntervalSince1970
        var request = [
            "method":"addUser",
            "arguments": [
                userName, userEmail, userPhone, curUser.deviceID!, curTime
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
    
    func getConversationsByGroupID(groupID: String) {
        var request = [
            "method":"getUserConversationForGroup",
            "arguments":[groupID, curUser.userID!]
        ]
        sendPassiveWebsocketMessage(request)
    }
    
    // ----------- GroupSettings (Modal) -----------
    
    // ----------- Home -----------
    
    // ----------- Messages -----------
    
    func getMessagesByUserID(userID: String) -> Bool {
        var request = [
            "method":"getUserMessages",
            "arguments":[userID]
        ]
        sendPassiveWebsocketMessage(request)
        return true
    }
    
    // ----------- ComposeMessages -----------
    
}

