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
    func sendPassiveWebsocketMessage(obj: AnyObject)
    func setPassiveWebsocketState(state: Int)
    func warnWebsocketWriteFail(error: NSError?)
    
}

class PassiveWebsocketDelegate : WebsocketDelegate {
    
    var delegate: PassiveWebsocketProtocol?
    
    init(listener: PassiveWebsocketProtocol) {
        delegate = listener
    }
    
    func websocketDidConnect() {
        println("Passive Websocket is connected")
        delegate?.setPassiveWebsocketState(1)
    }
    
    func websocketDidDisconnect(error: NSError?) {
        if error != nil {
            println("Passive Websocket is disconnected: \(error!.localizedDescription)")
        }
        delegate?.setPassiveWebsocketState(0)
    }
    
    func websocketDidWriteError(error: NSError?) {
        if error != nil {
            println("Passive Websocket Error: \(error!.localizedDescription)")
        }
        delegate?.warnWebsocketWriteFail(error)
    }
    
    func websocketDidReceiveMessage(text: String) {
        //
        println("got some text: \(text)")
        delegate?.onPassiveWebsocketReceiveMessage(text)
        //self.socket.writeString(text) //example on how to write a string the socket
    }
    
    func websocketDidReceiveData(data: NSData) {
        println("got some data: \(data.length)")
        //self.socket.writeData(data) //example on how to write binary data to the socket
    }
    
}