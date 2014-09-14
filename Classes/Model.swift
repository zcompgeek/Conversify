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
        // Call VC delegate that there's new data
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
            println("IDDD: \(curUser.userID)")
            var storedVars = NSUserDefaults.standardUserDefaults()
            storedVars.setObject(curUser.userID, forKey: "userID")
        }
    }
    
    func JSONStringify(jsonObj: AnyObject) -> String {
        var e: NSError?
        let jsonData: NSData! = NSJSONSerialization.dataWithJSONObject(
            jsonObj,
            options: NSJSONWritingOptions(0),
            error: &e)
        if e != nil {
            return ""
        } else {
            return NSString(data: jsonData, encoding: NSUTF8StringEncoding)
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
    
    // ----------- GroupSettings (Modal) -----------
    
    // ----------- Home -----------
    
    // ----------- Messages -----------
    
    // ----------- ComposeMessages -----------
    
}

