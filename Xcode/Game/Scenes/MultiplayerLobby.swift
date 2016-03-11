//
//  MultiplayerLobby.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/11/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit
import MultipeerConnectivity

class MultiplayerLobby: GameScene, MCNearbyServiceAdvertiserDelegate {
    
    //buttons
    var buttonBack:Button!

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        GameScene.nearbyServiceBrowser.stopBrowsingForPeers()
        GameScene.nearbyServiceBrowser.delegate = nil
        
        GameScene.nearbyServiceAdvertiser.delegate = self
        GameScene.nearbyServiceAdvertiser.startAdvertisingPeer()
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        #if os(iOS) || os(OSX)
            self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
            self.addChild(self.buttonBack)
        #endif
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("advertiser: " + advertiser.myPeerID.displayName + " didNotStartAdvertisingPeer: " + error.description)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        print("advertiser: " + advertiser.myPeerID.displayName + " didReceiveInvitationFromPeer: " + peerID.displayName)
        
        invitationHandler(true, GameScene.session)
        GameScene.nearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        
        let rootObject: [String: AnyObject] = ["event": "someEvent", "object": "someData"]
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(rootObject)
        
        do {
            try GameScene.session.sendData(data, toPeers: GameScene.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
        } catch _ {
            
        }
    }
}
