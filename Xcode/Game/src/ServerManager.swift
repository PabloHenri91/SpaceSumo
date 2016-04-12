//
//  ServerManager.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/16/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#endif

#if os(OSX)
    import Foundation
#endif

class ServerManager {
    
    static var sharedInstance = ServerManager()

    //Multiplayer Online
    var socket:SocketIOClient!
    
    var userDisplayInfo:UserDisplayInfo!
    
    var roomId:String?
    var usersDisplayInfo:[UserDisplayInfo]!
    
     init() {
    
        let options = Set<SocketIOClientOption>(arrayLiteral: SocketIOClientOption.ReconnectAttempts(30), SocketIOClientOption.ReconnectWait(2)
        )
        
        //self.socket = SocketIOClient(socketURL: NSURL(string:"http://Pablos-MacBook-Pro.local:8900")!, options: options)
        //self.socket = SocketIOClient(socketURL: NSURL(string:"http://172.16.3.149:8900")!, options: options)
        self.socket = SocketIOClient(socketURL: NSURL(string:"http://181.41.197.181:8900")!, options: options)// Host1Plus
        
        
        #if os(iOS) || os(tvOS)
            self.userDisplayInfo = UserDisplayInfo(displayName: UIDevice.currentDevice().name)
        #endif
        
        #if os(OSX)
            self.userDisplayInfo = UserDisplayInfo(displayName: NSHost.currentHost().localizedName!)
        #endif
        
        //self.displayName = CharacterGenerator().getName(.random, gender: .random)
    }
    
    func disconnect() {
        self.roomId = nil
        self.socket.disconnect()
    }
    
    
    
    func leaveAllRooms() {
        self.roomId = nil
        self.socket.emit("leaveAllRooms")
    }
}
