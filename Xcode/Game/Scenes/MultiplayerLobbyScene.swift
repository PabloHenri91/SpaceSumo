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
        case connectionClosed
        case mainMenu
    }
    
    //Estados iniciais
    var state = states.multiplayerLobby
    var nextState = states.multiplayerLobby
    
    //buttons
    var buttonBack:Button!
    
    var serverManager:ServerManager!
    
    var nextRoom:RoomCell!
    
    var lastSecondUpdate:NSTimeInterval = 0
    
    var roomScrollNode:ScrollNode!
    var needToGetAllRooms = true
    
    var lastSocketErrorMessage = ""

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        #if os(iOS) || os(OSX)
            self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
            self.addChild(self.buttonBack)
        #endif
        
        self.serverManager = ServerManager.sharedInstance
        
        self.setHandlers()
        self.serverManager.leaveAllRooms()
        
        self.roomScrollNode = ScrollNode(cells: Array<Control>(), x: 72, y: 83, xAlign: .center, yAlign: .center, spacing: 19, scrollDirection: .vertical)
        
        self.addChild(self.roomScrollNode)
    }
    
    func setHandlers() {
            self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) -> Void in
                
            //print(socketAnyEvent.description)
                
                guard let scene = self else { return }
                
                switch scene.state {
                    
                case states.joinRoom:
                    
                    switch(socketAnyEvent.event) {
                        
                    case "error":
                        if let message = socketAnyEvent.items?.firstObject as? String {
                            scene.lastSocketErrorMessage = message
                        } else {
                            scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
                        }
                        break
                        
                    case "update":
                        //Comecou a receber os updates dos outros players
                        break
                        
                    case "roomInfo":
                        //Recebeu a confirmacao do servidor, ja pode ir para o hangar do outro player
                        scene.nextState = states.joinRoomAccepted
                        break
                        
                    default:
                        print(socketAnyEvent.event + " nao foi processado em MultiplayerLobbyScene " + scene.state.rawValue)
                        break
                    }
                    
                    break
                    
                case states.multiplayerLobby:
                    
                    switch(socketAnyEvent.event) {
                        
                    case "error":
                        if let message = socketAnyEvent.items?.firstObject as? String {
                            scene.lastSocketErrorMessage = message
                        } else {
                            scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
                        }
                        break
                        
                    case "roomInfo":
                        
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
                                    if let rawUsersDisplayInfo = message["usersDisplayInfo"] as? [[String]] {
                                        
                                        let roomCell = RoomCell()
                                        var usersDisplayInfo = [UserDisplayInfo]()
                                        
                                        for var rawUserDisplayInfo in rawUsersDisplayInfo {
                                            usersDisplayInfo.append(UserDisplayInfo(socketId: rawUserDisplayInfo[0], displayName: rawUserDisplayInfo[1]))
                                        }
                                        
                                        roomCell.loadLobbyRoom(roomId: roomId, usersDisplayInfo: usersDisplayInfo)
                                        
                                        roomCell.buttonJoin.addHandler({
                                            scene.serverManager.socket.emit("joinRoom", roomId)
                                            scene.nextRoom = roomCell
                                            scene.state = MultiplayerLobbyScene.states.joinRoom
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
                
            case states.mainMenu:
                self.serverManager.disconnect()
                self.view?.presentScene(MainMenuScene(), transition: self.transition)
                break
            case states.hangar:
                self.view?.presentScene(HangarScene(), transition: self.transition)
                break
            case states.joinRoomAccepted:
                let hangarScene = HangarScene()
                hangarScene.serverManager.roomId = nextRoom.roomId
                hangarScene.serverManager.usersDisplayInfo = nextRoom.usersDisplayInfo
                self.view?.presentScene(hangarScene, transition: self.transition)
                break
            case states.connectionClosed:
                let box = Box(textureName: "boxWhite256x64")
                let label = Label(text: self.lastSocketErrorMessage, x:128, y:32)
                box.addChild(label)
                self.addChild(box)
                
                self.blackSpriteNode.zPosition = box.zPosition - 1
                self.blackSpriteNode.hidden = false
                
                let button = Button(textureName: "buttonGray", text:"ok   😓", x:192, y:228, xAlign: .center, yAlign: .down)
                self.addChild(button)
                button.zPosition = self.blackSpriteNode.zPosition + 1
                
                button.addHandler( { [weak self] in
                    guard let scene = self else { return }
                    //Troca de scene
                    scene.nextState = states.mainMenu
                    })
                
                break
            default:
                break
            }
        }
        
        if currentTime - self.lastSecondUpdate > 1 { // Executado uma vez por segundo
            
            if (self.serverManager.socket.status == .NotConnected) {
                self.nextState = states.connectionClosed
            } else {
                if self.needToGetAllRooms == true {
                    //self.needToGetAllRooms = false
                    self.serverManager.socket.emit("getAllRooms")
                }
            }
            
            //print(self.serverManager.socket.status.description)
            
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
