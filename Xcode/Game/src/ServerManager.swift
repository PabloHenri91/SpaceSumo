//
//  ServerManager.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/16/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

#if os(OSX)
    import Foundation
#endif

#if os(iOS) || os(OSX)
    import MultipeerConnectivity
#endif

//#if os(tvOS)
//      :S
//#endif


class ServerManager: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    
    static var sharedInstance = ServerManager()

    //Multiplayer Online
    var socket:SocketIOClient!
    
    #if os(iOS) || os(OSX)
    var peerID:MCPeerID!
    #endif
    
    var session:MCSession!
    var nearbyServiceBrowser:MCNearbyServiceBrowser!
    var nearbyServiceAdvertiser:MCNearbyServiceAdvertiser!
    
    override init() {
        super.init()
        
        //self.socket = SocketIOClient(socketURL: NSURL(string:"http://Pablos-MacBook-Pro.local:8900")!)
        self.socket = SocketIOClient(socketURL: NSURL(string:"http://172.16.3.149:8900")!)
        
        
        #if os(iOS)
            self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        #endif
        
        #if os(OSX)
            self.peerID = MCPeerID(displayName: NSHost.currentHost().localizedName!)
        #endif
        
        self.session = MCSession(peer: self.peerID)
        self.session.delegate = self
        
        self.nearbyServiceBrowser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: "SpaceGame")
        self.nearbyServiceBrowser.delegate = self
        
        self.nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "SpaceGame")
        self.nearbyServiceAdvertiser.delegate = self
    }
    
    func startBrowsingForPeers() {
        self.nearbyServiceAdvertiser.stopAdvertisingPeer()
        self.nearbyServiceBrowser.startBrowsingForPeers()
        print("startBrowsingForPeers")
    }
    
    func startAdvertisingPeer() {
        self.nearbyServiceBrowser.stopBrowsingForPeers()
        self.nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    
    //MARK: MCNearbyServiceBrowserDelegate
    
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("browser: " + browser.myPeerID.displayName + " foundPeer: " + peerID.displayName)
        browser.invitePeer(peerID, toSession: self.session, withContext: nil, timeout: 30)
    }
    
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("browser: " + browser.myPeerID.displayName + " lostPeer: " + peerID.displayName)
    }
    
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print("browser: " + browser.myPeerID.displayName + " didNotStartBrowsingForPeers: " + error.description)
    }
    
    
    //MARK: MCNearbyServiceAdvertiserDelegate
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("advertiser: " + advertiser.myPeerID.displayName + " didNotStartAdvertisingPeer: " + error.description)
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        print("advertiser: " + advertiser.myPeerID.displayName + " didReceiveInvitationFromPeer: " + peerID.displayName)
        
        invitationHandler(true, self.session)
        self.nearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    
    
    //MARK: MCSessionDelegate
    
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
        certificateHandler(true)
        return
    }
    
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        
        if let dict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [String: AnyObject],
            let event = dict["event"] as? String,
            let object: AnyObject? = dict["object"] as? String {
                dispatch_async(dispatch_get_main_queue()) {
                    print(event)
                    print(object)
                }
        }
    }
    
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        
    }
}
