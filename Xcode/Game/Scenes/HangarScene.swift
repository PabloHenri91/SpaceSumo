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
        case tvOSMultiplayer
    }
    
    //Estados iniciais
    var state = states.hangar
    var nextState = states.hangar
    
    //buttons
    var buttonBack:Button!
    
    var buttonGo:Button!
    var buttonMultiplayer:Button!
    
    var roomCell:RoomCell!
    
    var nextSector = 0
    
    var offlineMode = true
    
    var lastSecondUpdate:NSTimeInterval = 0
    
    var lastSocketErrorMessage = ""
    
    var serverManager = ServerManager.sharedInstance
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        //Crashlytics.sharedInstance().crash()
            
        self.offlineMode = !(self.serverManager.socket.status == .Connected)
        
        self.roomCell = RoomCell(x: 91, y: 146, xAlign: .center, yAlign: .center)
        
        if self.offlineMode {
            self.serverManager.socket.onAny({ (SocketAnyEvent) in
            })
            self.serverManager.disconnect()
        } else {
            self.setHandlers()
            if let roomId = self.serverManager.roomId {
                
                // Entrei no hangar mas ja estava em uma sala.
                self.serverManager.socket.emit("getRoomInfo", roomId)
                
                self.roomCell.loadRoomInfo(roomId: roomId, usersDisplayInfo: self.serverManager.usersDisplayInfo)
            } else {
                self.serverManager.usersDisplayInfo = [UserDisplayInfo]()
                self.serverManager.socket.emit("createRoom")
            }
        }
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
        self.addChild(self.buttonBack)
        
        self.buttonGo = Button(textureName: "buttonYellow", text:"go!", x: 245, y: 20, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonGo)
        
        self.buttonMultiplayer = Button(textureName: (self.offlineMode ? "buttonGray" : "buttonGreen"), text:"multiplayer", x: 245, y: 62, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonMultiplayer)
        
        //Serve para setar o foco inicial no tvOS
        GameScene.selectedButton = self.buttonGo
       
        self.addChild(self.roomCell)
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
                
            case states.hangar:
                break
                
            case states.tvOSMultiplayer:
                let box = Box(textureName: "boxWhite337x105")
                box.zPosition *= 2
                
                let label0 = Label(text: "Your online room have already been created.")
                let label1 = Label(text: "Ask your friends to join the room: " + self.serverManager.userDisplayInfo.displayName!)
                
                label0.zPosition = box.zPosition + 1
                label0.screenPosition = CGPoint(x: 168, y: 42)
                label0.resetPosition()
                box.addChild(label0)
                
                label1.zPosition = box.zPosition + 1
                label1.screenPosition = CGPoint(x: 168, y: 62)
                label1.resetPosition()
                box.addChild(label1)
                
                self.blackSpriteNode.hidden = false
                self.blackSpriteNode.zPosition = box.zPosition - 1
                self.addChild(box)
                
                let button = Button(textureName: "buttonGreen", text:"roger that! 👍", x:192, y:228, xAlign: .center, yAlign: .down)
                GameScene.selectedButton = button
                
                button.zPosition = box.zPosition + 1
                button.addHandler({ [weak self] in
                     guard let scene = self else { return }
                    scene.nextState = states.hangar
                    box.removeFromParent()
                    button.removeFromParent()
                    scene.blackSpriteNode.hidden = true
                    GameScene.selectedButton = scene.buttonGo
                })
                self.addChild(button)
                self.buttonBack.zPosition = self.blackSpriteNode.zPosition + 1
                
                break
                
            case states.mainMenu:
                if(!self.offlineMode) {
                    self.serverManager.disconnect()
                }
                
                self.view?.presentScene(MainMenuScene(), transition: self.transition)
                break
                
            case states.chooseSector:
                self.view?.presentScene(ChooseSector(), transition: self.transition)
                break
                
            case states.mission:
                self.serverManager.socket.emit("someData", ["go!"])
                let scene = MissionScene(size:MissionScene.defaultSize)
                self.view?.presentScene(scene, transition: self.transition)
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
                
            case states.multiplayer:
                #if os(tvOS)
                    if !self.offlineMode {
                        self.nextState = states.tvOSMultiplayer
                    }
                #else
                    self.view?.presentScene(MultiplayerLobbyScene(), transition: self.transition)
                #endif
                
                break
                
            default:
                break
            }
        }
    }
    
    func setHandlers() {
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
                    scene.serverManager.roomId = nil
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
                    scene.serverManager.socket.emit("userDisplayInfo", scene.serverManager.userDisplayInfo.displayName!)
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
            case states.hangar, states.tvOSMultiplayer:
                
                switch (socketAnyEvent.event) {
                    
                case "error":
                    if let message = socketAnyEvent.items?.firstObject as? String {
                        scene.lastSocketErrorMessage = message
                    } else {
                        scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
                    }
                    break
                    
                case "update":
                    //ja estou recebendo update de players que estao na partida jogando.
                    break
                    
                case "someData":
                    
                    if let message = socketAnyEvent.items?.firstObject as? [String] {
                        var i = message.generate()
                        
                        switch (i.next()!) {
                        case "go!":
                            scene.nextState = states.mission
                            break
                        case "botNames":
                            //TODO: recebi muito rápido o nome dos bots que preciso carregar
                            break
                        case "time":
                            // A partida já está em andamento
                            scene.nextState = states.mission
                            break
                        default:
                            print(socketAnyEvent.description + " nao foi processado em HangarScene " + scene.state.rawValue)
                            break
                        }
                    }
                    
                    break
                    
                case "roomInfo":
                    //Recebi informacoes da sala
                    if let message = socketAnyEvent.items?.firstObject as? [String : AnyObject] {
                        if let roomId = message["roomId"] as? String {
                            if let rawUsersDisplayInfo = message["usersDisplayInfo"] as? [[String]] {
                                var usersDisplayInfo = [UserDisplayInfo]()
                                for var rawUserDisplayInfo in rawUsersDisplayInfo {
                                    usersDisplayInfo.append(UserDisplayInfo(socketId: rawUserDisplayInfo[0], displayName: rawUserDisplayInfo[1]))
                                }
                                scene.serverManager.usersDisplayInfo = usersDisplayInfo
                                scene.roomCell.loadRoomInfo(roomId: roomId, usersDisplayInfo: usersDisplayInfo)
                            }
                        }
                    }
                    break
                    
                case "removePlayer":
                    scene.serverManager.socket.emit("getRoomInfo", scene.serverManager.roomId!)//TODO: nao precisa emitir
                    break
                    
                case "addPlayer":
                     scene.serverManager.socket.emit("getRoomInfo", scene.serverManager.roomId!)//TODO: nao precisa emitir
                    break
                    
                case "reconnect":
                    print("reconnecting...")
                    scene.state = states.reconnecting
                    scene.nextState = states.reconnecting
                    break
                    
                case "mySocketId":
                    if let mySocketId = socketAnyEvent.items?.firstObject as? String {
                        scene.serverManager.roomId = mySocketId
                        scene.serverManager.userDisplayInfo.socketId = mySocketId
                        scene.serverManager.usersDisplayInfo = [scene.serverManager.userDisplayInfo]
                        scene.roomCell.loadRoomInfo(roomId: mySocketId, usersDisplayInfo: scene.serverManager.usersDisplayInfo)
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
                
                if(self.buttonBack.containsPoint(location)) {
                    self.nextState = states.mainMenu
                    return
                }
                
                switch (self.state) {
                case states.hangar:
                    
                    if(self.buttonGo.containsPoint(location)) {
                        self.nextState = states.mission
                        return
                    }
                    
                    if !self.offlineMode {
                        if(self.buttonMultiplayer.containsPoint(location)) {
                            self.nextState = states.multiplayer
                            return
                        }
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
            Button.raiseSelectedButtonEvent()
            self.touchesEnded(taps: Set<UITouch>([UITouch()]))
            break
        default:
            break
        }
        
        return false
    }
    #endif
}
