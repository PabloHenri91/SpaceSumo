//
//  Hangar.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
    enum states : String {
        //Estado principal
        case hangar
        
        //Estados de saida da scene
        case mainMenu
        case chooseSector
        case mission
        case connectionClosed
        case multiplayer
        case reconnecting
    }
    
    //Estados iniciais
    var state = states.hangar
    var nextState = states.hangar
    
    //buttons
    var buttonBack:Button!
    
    var buttonLevelUp:Button!
    var buttonGo:Button!
    var buttonWeapons:Button!
    var buttonMultiplayer:Button!
    var buttonGameInfo:Button!
    var buttonChooseMission:Button!
    
    var currentRoom:RoomCell?
    
    var nextSector = 0
    
    var offlineMode = true
    
    var lastSecondUpdate:NSTimeInterval = 0
    
    var lastSocketErrorMessage = ""
    
    var serverManager = ServerManager.sharedInstance
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
            
        self.offlineMode = !(self.serverManager.socket.status == .Connected)
        
        if self.offlineMode {
            self.serverManager.socket.onAny({ (SocketAnyEvent) in
            })
            self.serverManager.socket.disconnect()
            self.currentRoom = RoomCell(x: 91, y: 146, xAlign: .center, yAlign: .center)
        } else {
            if let roomCell = self.currentRoom {
                //entrei no hangar mas ja estava em uma sala
                roomCell.screenPosition = CGPoint(x: 91, y: 146)
                roomCell.xAlign = .center
                roomCell.yAlign = .center
                roomCell.buttonJoin.removeFromParent()
                roomCell.resetPosition()
                
                roomCell.names.append(self.serverManager.displayName)
                roomCell.loadRoomInfo(roomId: roomCell.roomId!, names: roomCell.names)
            } else {
                self.currentRoom = RoomCell(x: 91, y: 146, xAlign: .center, yAlign: .center)
                self.serverManager.socket.emit("createRoom")
            }
            self.addHandlers()
        }
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
        self.addChild(self.buttonBack)
        
        self.buttonLevelUp = Button(textureName: "buttonGreen", text:"leve up!", x: 139, y: 20, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonLevelUp)
        
        self.buttonGo = Button(textureName: "buttonYellow", text:"go!", x: 245, y: 20, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonGo)
        
        self.buttonWeapons = Button(textureName: "buttonGreen", text:"weapons", x: 139, y: 62, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonWeapons)
        
        self.buttonMultiplayer = Button(textureName: "buttonGreen", text:"multiplayer", x: 245, y: 62, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonMultiplayer)
        
        self.buttonGameInfo = Button(textureName: "buttonGreen", text:"game info", x: 139, y: 104, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonGameInfo)
        
        self.buttonChooseMission = Button(textureName: "buttonGreen", text:"choose mission", x: 245, y: 104, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonChooseMission)
        
        let sectorCell = SectorCell(type: self.nextSector, x:351, y:20, xAlign: .center, yAlign: .center)
        self.addChild(sectorCell)
        
        //Serve para setar o foco inicial no tvOS
        GameScene.selectedButton = self.buttonGo
       
        self.addChild(self.currentRoom!)//TODO disconnect recebido fora do estado esperado em HangarScene mainMenu, fatal error: unexpectedly found nil while unwrapping an Optional value
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            
            if currentTime - self.lastSecondUpdate > 1 { // Executado uma vez por segundo
                switch (self.state) {
                    
                case states.reconnecting:
                    if(!self.offlineMode) {
                        if (self.serverManager.socket.status == .Closed) {
                            self.nextState = states.connectionClosed
                        }
                    }
                    break
                    
                default:
                    break
                }
                //print(self.serverManager.socket.status.description)
                
                self.lastSecondUpdate = currentTime
            }
            
            switch (self.state) {
            default:
                
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case states.mainMenu:
                if(!self.offlineMode) {
                    self.serverManager.socket.disconnect()
                }
                
                self.view?.presentScene(MainMenuScene(), transition: self.transition)
                break
                
            case states.chooseSector:
                self.view?.presentScene(ChooseSector(), transition: self.transition)
                break
                
            case states.mission:
                self.serverManager.socket.emit("update", "go!")
                let scene = MissionScene(size:CGSize(width: 1920.0/2, height: 1080.0/2))
                self.currentRoom?.removeFromParent()
                scene.currentRoom = self.currentRoom
                self.view?.presentScene(scene, transition: self.transition)
                break
                
            case states.connectionClosed:
                let box = Box(textureName: "boxWhite256x64")
                let label = Label(text: self.lastSocketErrorMessage, x:128, y:32)
                box.addChild(label)
                self.addChild(box)
                
                self.blackSpriteNode.zPosition = box.zPosition - 1
                self.blackSpriteNode.hidden = false
                
                let button = Button(textureName: "buttonGray", text:"ok   D:", x: 119, y: 142, xAlign: .center, yAlign: .down)
                self.addChild(button)
                button.zPosition = self.blackSpriteNode.zPosition + 1
                
                button.addHandler( { [weak self] in
                    guard let scene = self else { return }
                    //Troca de scene
                    scene.nextState = states.mainMenu
                    })
                
                break
                
            case states.multiplayer:
                self.view?.presentScene(MultiplayerLobbyScene(), transition: self.transition)
                break
                
            default:
                break
            }
        }
    }
    
    func addHandlers() {
        self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) in
            
            //print(socketAnyEvent.description)
            
            guard let scene = self else { return }
            
            switch scene.state {
                
            case states.mainMenu:
                
                switch (socketAnyEvent.event) {
                    
                case "error":
                    if let message = socketAnyEvent.items?.firstObject as? String {
                        scene.lastSocketErrorMessage = message
                    } else {
                        scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
                    }
                    break
                    
                case "disconnect":
                    //Desconectou para ir para o mainMenu
                    break
                    
                default:
                    print(socketAnyEvent.event + " nao foi processado em HangarScene " + scene.state.rawValue)
                    break
                }
                
                break
                
            case states.reconnecting:
                
                switch (socketAnyEvent.event) {
                    
                case "error":
                    if let message = socketAnyEvent.items?.firstObject as? String {
                        scene.lastSocketErrorMessage = message
                    } else {
                        scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
                    }
                    break
                    
                case "disconnect":
                    print("disconnect")
                    //nao foi possivel reconectar, nao preciso fazer nada aqui
                    break
                    
                case "connect":
                    print("reconectou!")
                    
                    //reconnect foi bem sussedido, preciso avisar o server quem sou eu
                    scene.serverManager.socket.emit("userDisplayInfo", scene.serverManager.displayName)
                    scene.state = states.hangar
                    scene.nextState = states.hangar
                    
                    break
                    
                case "reconnectAttempt":
                    print("reconnecting...")
                    break
                    
                default:
                    print(socketAnyEvent.event + " nao foi processado em HangarScene " + scene.state.rawValue)
                    break
                }
                
                break
            case states.hangar:
                
                switch (socketAnyEvent.event) {
                    
                case "error":
                    if let message = socketAnyEvent.items?.firstObject as? String {
                        scene.lastSocketErrorMessage = message
                    } else {
                        scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
                    }
                    break
                    
                case "update":
                    if let message = socketAnyEvent.items?.firstObject {
                        if message as? String == "go!" {
                            scene.nextState = states.mission
                        }
                    }
                    
                    break
                    
                case "roomInfo":
                    //Recebi informacoes da sala
                    if let message = socketAnyEvent.items?.firstObject as? Dictionary<String, AnyObject> {
                        if let roomId = message["roomId"] as? String {
                            if let usersDisplayInfo = message["usersDisplayInfo"] as? Array<String> {
                                scene.currentRoom?.loadRoomInfo(roomId: roomId, names: usersDisplayInfo)
                            }
                        }
                    }
                    break
                    
                case "removePlayer":
                    scene.serverManager.socket.emit("getRoomInfo", (scene.currentRoom?.roomId)!)
                    break
                    
                case "addPlayer":
                    //Algum player entrou na minha sala?
                    if let otherName = socketAnyEvent.items?.firstObject as? String {
                        var names = scene.currentRoom?.names
                        names?.append(otherName)
                        scene.currentRoom!.loadRoomInfo(roomId: scene.currentRoom!.roomId!, names: names!)
                    }
                    break
                    
                case "reconnect":
                    print("reconnecting...")
                    scene.state = states.reconnecting
                    scene.nextState = states.reconnecting
                    break
                    
                case "currentRoomId":
                    
                    if let currentRoomId = socketAnyEvent.items?.firstObject as? String {
                        scene.currentRoom!.loadRoomInfo(roomId: currentRoomId, names: [scene.serverManager.displayName])
                    }
                    
                    break
                    
                default:
                    print(socketAnyEvent.event + " nao foi processado em HangarScene " + scene.state.rawValue)
                    break
                }
                
                break
                
            default:
                print(socketAnyEvent.event + " recebido fora do estado esperado em HangarScene " + scene.state.rawValue)
                break
            }
        }
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                let location = touch.locationInNode(self)
                switch (self.state) {
                case states.hangar:
                    if(self.buttonBack.containsPoint(location)) {
                        self.nextState = states.mainMenu
                        return
                    }
                    
                    if(self.buttonChooseMission.containsPoint(location)) {
                        self.nextState = states.chooseSector
                        return
                    }
                    
                    if(self.buttonGo.containsPoint(location)) {
                        self.nextState = states.mission
                        return
                    }
                    
                    if(self.buttonMultiplayer.containsPoint(location)) {
                        self.nextState = states.multiplayer
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
            self.nextState = states.mainMenu
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
