//
//  LiveWebsocketDelegate.swift
//  Conversify
//
//  Created by Tadas Antanavicius on 9/13/14.
//  Copyright (c) 2014 Zach Costa. All rights reserved.
//

import Foundation

protocol LiveWebsocketProtocol {
    func onLiveWebsocketReceiveMessage(text: String)
    func sendLiveWebsocketMessage(obj: AnyObject)
    func setLiveWebsocketState(state: Int)
    
}

class LiveWebsocketDelegate : WebsocketDelegate {
    
    var delegate: LiveWebsocketProtocol?
    
    init(listener: LiveWebsocketProtocol) {
        delegate = listener
    }
    
    func websocketDidConnect() {
        println("Live Websocket is connected")
        delegate?.setLiveWebsocketState(1)
    }
    
    func websocketDidDisconnect(error: NSError?) {
        if error != nil {
            println("Live Websocket is disconnected: \(error!.localizedDescription)")
        }
        delegate?.setLiveWebsocketState(0)
    }
    
    func websocketDidWriteError(error: NSError?) {
        println("Live Websocket Error: \(error!.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(text: String) {
        //
        println("got some text: \(text)")
        delegate?.onLiveWebsocketReceiveMessage(text)
        //self.socket.writeString(text) //example on how to write a string the socket
    }
    func websocketDidReceiveData(data: NSData) {
        println("got some data: \(data.length)")
        //self.socket.writeData(data) //example on how to write binary data to the socket
    }
    
}