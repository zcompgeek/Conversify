//
//  Model.swift
//  Conversify
//
//  Created by Zach Costa on 9/12/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import Foundation

/// Parent model for Conversify, holds the high level functions.
class Model: LiveWebsocketProtocol, PassiveWebsocketProtocol {

    // Note: Websocket needs a delegate to listen to requests, and my class structure
    // requires that delegate to have this model act as a delegate in return
    var liveWebsocket = Websocket(url: NSURL.URLWithString("ws://localhost:8080"))
    var passiveWebsocket = Websocket(url: NSURL.URLWithString("ws://localhost:8080"))
    var liveWebsocketDelegate, passiveWebsocketDelegate : LiveWebsocketDelegate?
    
    func Model() {
        liveWebsocketDelegate = LiveWebsocketDelegate(listener: self)
        liveWebsocket.delegate = liveWebsocketDelegate
        liveWebsocket.connect()
    }
    
    // Live Websocket
    
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
    
    // Passive Websocket
    
    // Groups
    
    // CreateGroup
    
    // Conversations
    
    // GroupSettings
    
    // Home
    // TODO on load, initialize liveMessageSocket
    
    // Messages
    
    // ComposeMessages
    
}

