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

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        #if os(iOS) || os(OSX)
            self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
            self.addChild(self.buttonBack)
        #endif
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        
        let rootObject: [String: AnyObject] = ["event": "someEvent", "object": "someData"]
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(rootObject)
        
        do {
            //TODO: session.sendData
            //try GameScene.session.sendData(data, toPeers: GameScene.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
        } catch _ {
            
        }
    }
}
