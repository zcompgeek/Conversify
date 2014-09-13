//
//  PassiveWebsocketDelegate.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import Foundation

protocol PassiveWebsocketProtocol {
    func onPassiveWebsocketReceiveMessage(text: String)
    func onPassiveWebsocketReceiveData(data: NSData)
    
}

class PassiveWebsocketDelegate : WebsocketDelegate {
    
    var delegate: PassiveWebsocketProtocol?
    
    init(listener: PassiveWebsocketProtocol) {
        delegate = listener
    }
    
    func websocketDidConnect() {
        println("Passive Websocket is connected")
        
    }
    
    func websocketDidDisconnect(error: NSError?) {
        println("Passive Websocket is disconnected: \(error!.localizedDescription)")
    }
    
    func websocketDidWriteError(error: NSError?) {
        println("Passive Websocket Error: \(error!.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(text: String) {
        //
        println("got some text: \(text)")
        delegate?.onPassiveWebsocketReceiveMessage(text)
        //self.socket.writeString(text) //example on how to write a string the socket
    }
    func websocketDidReceiveData(data: NSData) {
        println("got some data: \(data.length)")
        delegate?.onPassiveWebsocketReceiveData(data)
        //self.socket.writeData(data) //example on how to write binary data to the socket
    }
    
}