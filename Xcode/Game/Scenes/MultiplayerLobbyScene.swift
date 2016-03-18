//
//  MultiplayerLobby.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/11/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class MultiplayerLobbyScene: GameScene {
    
    enum states {
        //Estado principal
        case multiplayerLobby
        
        //Estados de saida da scene
        case hangar
    }
    
    //Estados iniciais
    var state = states.multiplayerLobby
    var nextState = states.multiplayerLobby
    
    //buttons
    var buttonBack:Button!
    
    #if os(iOS) || os(OSX)
    var serverManager:ServerManager!
    #endif
    
    var lastSecondUpdate:NSTimeInterval = 0

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        #if os(iOS) || os(OSX)
            self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
            self.addChild(self.buttonBack)
        #endif
        
        #if os(iOS) || os(OSX)
            self.serverManager = ServerManager.sharedInstance
            
            self.addHandlers()
            self.serverManager.socket.emit("leaveRooms")
        #endif
    }
    
    func addHandlers() {
        #if os(iOS) || os(OSX)
            self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) -> Void in
                
                guard let scene = self else { return }
                
                if(scene.state == states.multiplayerLobby && scene.nextState == states.multiplayerLobby) {
                    
                    switch(socketAnyEvent.event) {
                        
                    case "getRoom":
                        if let message = socketAnyEvent.items?.firstObject as? Dictionary<String, AnyObject> {
                            
                            if let roomId = message["roomId"] as? String {
                                print(roomId)
                                
                                if let usersDisplayInfo = message["usersDisplayInfo"] as? Array<AnyObject> {
                                    for item in usersDisplayInfo {
                                        if let userDisplayInfo = item as? String {
                                            print(userDisplayInfo)
                                        }
                                    }
                                }
                            }
                        }
                        break
                        
                    default:
                        print(socketAnyEvent.description)
                        break
                    }
                } else {
                    print("Evento recebido fora do estado esperado")
                    print(socketAnyEvent.description)
                }
            }
        #endif
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if currentTime - self.lastSecondUpdate > 1 { // Executado uma vez por segundo
            
            #if os(iOS) || os(OSX)
                if (self.serverManager.socket.status == .Closed) {
                    //TODO: connectionClosed
                } else {
                    self.serverManager.socket.emit("getAllRooms")
                }
                
                print(self.serverManager.socket.status.description)
            #endif
            
            self.lastSecondUpdate = currentTime
        }
        
//        let rootObject: [String: AnyObject] = ["event": "someEvent", "object": "someData"]
//        
//        let data = NSKeyedArchiver.archivedDataWithRootObject(rootObject)
//        
//        do {
//            //TODO: session.sendData
//            //try GameScene.session.sendData(data, toPeers: GameScene.session.connectedPeers, withMode: MCSessionSendDataMode.Reliable)
//        } catch _ {
//            
//        }
    }
}
