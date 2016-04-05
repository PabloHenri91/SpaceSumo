//
//  UserDisplayInfo.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 4/4/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

class UserDisplayInfo {
    var socketId:String?
    var displayName:String?
    
    init(displayName:String) {
        self.displayName = displayName
    }
    
    init(socketId:String, displayName:String) {
        self.socketId = socketId
        self.displayName = displayName
    }
}
