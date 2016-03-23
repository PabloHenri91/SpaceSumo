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
        case joinRoom
    }
    
    //Estados iniciais
    var state = states.multiplayerLobby
    var nextState = states.multiplayerLobby
    
    var nextRoomId = ""
    
    //buttons
    var buttonBack:Button!
    
    #if os(iOS) || os(OSX)
    var serverManager:ServerManager!
    #endif
    
    var lastSecondUpdate:NSTimeInterval = 0
    
    var roomScrollNode:ScrollNode!
    var needToGetAllRooms = true

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
        
        self.roomScrollNode = ScrollNode(cells: Array<Control>(), x: 72, y: 83, xAlign: .center, yAlign: .center, spacing: 19, scrollDirection: .vertical)
        
        self.addChild(self.roomScrollNode)
    }
    
    func addHandlers() {
        #if os(iOS) || os(OSX)
            self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) -> Void in
                
                //print(socketAnyEvent.description)
                
                guard let scene = self else { return }
                
                switch scene.state {
                    
                case states.multiplayerLobby:
                    
                    switch(socketAnyEvent.event) {
                        
                    case "getRoom":
                        
                        if let message = socketAnyEvent.items?.firstObject as? Dictionary<String, AnyObject> {
                            
                            if let roomId = message["roomId"] as? String {
                                
                                var doIHaveThisRoom = false
                                
                                for cell in scene.roomScrollNode.cells {
                                    if let roomCell = cell as? RoomCell {
                                        if(roomCell.roomId == roomId) {
                                            doIHaveThisRoom = true
                                        }
                                    }
                                }
                                
                                if (doIHaveThisRoom == true) {
                                    
                                } else {
                                    if let usersDisplayInfo = message["usersDisplayInfo"] as? Array<String> {
                                        let roomCell = RoomCell()
                                        roomCell.loadLobbyRoom(roomId: roomId, names: usersDisplayInfo)
                                        
                                        roomCell.buttonJoin.addHandler({
                                            scene.serverManager.socket.emit("joinRoom", roomId)
                                            scene.nextRoomId = roomId
                                            scene.nextState = MultiplayerLobbyScene.states.joinRoom
                                        })
                                        
                                        scene.roomScrollNode.append(roomCell)
                                    }
                                }
                            }
                        }
                        
                        break
                        
                    default:
                        print(socketAnyEvent.event + " nao foi processado!")
                        break
                    }
                    
                    break
                    
                default:
                    print("Evento recebido fora do estado esperado")
                    break
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
                    if self.needToGetAllRooms == true {
                        //self.needToGetAllRooms = false
                        self.serverManager.socket.emit("getAllRooms")
                    }
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
