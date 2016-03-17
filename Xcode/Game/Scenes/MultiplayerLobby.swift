//
//  MultiplayerLobby.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/11/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class MultiplayerLobby: GameScene {
    
    //buttons
    var buttonBack:Button!
    
    var serverManager:ServerManager!
    
    var lastSecondUpdate:NSTimeInterval = 0

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        #if os(iOS) || os(OSX)
            self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
            self.addChild(self.buttonBack)
        #endif
        
        self.serverManager = ServerManager.sharedInstance
        
        self.addHandlers()
        self.serverManager.socket.emit("leaveRooms")
    }
    
    func addHandlers() {
        self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) -> Void in
            
            guard let scene = self else { return }
            
            print(socketAnyEvent.description)
            
            switch(socketAnyEvent.event) {
                case "getAllRooms":
                    print("getAllRooms")
                break
                case "hello":
                    
                break
                
            default:
                break
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if currentTime - self.lastSecondUpdate > 1 { // Executado uma vez por segundo
                
            if (self.serverManager.socket.status == .Closed) {
                //TODO: connectionClosed
            } else {
                self.serverManager.socket.emit("getAllRooms")
            }
            
            print(self.serverManager.socket.status.description)
            
            self.lastSecondUpdate = currentTime
        }
        
        
        let rootObject: [String: AnyObject] = ["event": "someEvent", "object": "someData"]
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(rootObject)
        
        do {
            //TODO: session.sendData
            //try GameScene.session.sendData(data, toPeers: GameScene.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
        } catch _ {
            
        }
    }
}
