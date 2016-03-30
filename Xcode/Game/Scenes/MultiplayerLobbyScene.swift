//
//  MultiplayerLobby.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/11/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class MultiplayerLobbyScene: GameScene {
    
    enum states : String {
        //Estado principal
        case multiplayerLobby
        
        //Estados de saida da scene
        case hangar
        case joinRoom
        case joinRoomAccepted
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
                        
                    case "joinRoom":
                        scene.nextState = states.joinRoomAccepted
                        break
                        
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
                        print(socketAnyEvent.event + " nao foi processado em MultiplayerLobbyScene " + scene.state.rawValue)
                        break
                    }
                    
                    break
                    
                default:
                    print(socketAnyEvent.event + " recebido fora do estado esperado " + scene.state.rawValue)
                    break
                }
            }
        #endif
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case states.hangar:
                self.view?.presentScene(HangarScene(), transition: self.transition)
                break
            default:
                break
            }
        }
        
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
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                let location = touch.locationInNode(self)
                switch (self.state) {
                case states.multiplayerLobby:
                    if(self.buttonBack.containsPoint(location)) {
                        self.nextState = states.hangar
                        return
                    }
                    
                    break
                default:
                    break
                }
            }
        }
    }
    
    #if os(tvOS)
    override func pressBegan(press: UIPress) -> Bool {
        
        switch press.type {
        case .Menu:
            self.nextState = states.hangar
            break
            
        case .Select:
            self.touchesEnded(taps: Set<UITouch>([UITouch()]))
            break
        default:
            break
        }
        
        return false
    }
    #endif
}
