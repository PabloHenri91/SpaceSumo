//
//  Hangar.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class HangarScene: GameScene {
    
    enum states {
        //Estado principal
        case hangar
        
        //Estados de saida da scene
        case mainMenu
        case chooseSector
        case mission
        case connectionClosed
        case multiplayer
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
    
    var currentRoom:RoomCell!
    
    var nextSector = 0
    
    var offlineMode = true
    
    var lastSecondUpdate:NSTimeInterval = 0
    
    var lastSocketErrorMessage = ""
    
    #if os(iOS) || os(OSX)
    var serverManager = ServerManager.sharedInstance
    #endif
    
    init() {
        super.init()
        
        #if os(iOS) || os(OSX)
            if  self.serverManager.socket.status == .Connected {
                self.offlineMode = false
                self.addHandlers()
            } else {
                self.serverManager.socket.disconnect()
            }
        #endif
        
        self.nextSector = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
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
        
        #if os(iOS) || os(OSX)
            self.addHandlers()
            self.serverManager.socket.emit("createRoom")
        #endif
        
        self.currentRoom = RoomCell(x: 91, y: 146, xAlign: .center, yAlign: .center)
        self.addChild(self.currentRoom)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            
            if currentTime - self.lastSecondUpdate > 1 { // Executado uma vez por segundo
                #if os(iOS) || os(OSX)
                    switch (self.state) {
                        
                    case states.hangar:
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
                #endif
                
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
                    #if os(iOS) || os(OSX)
                        self.serverManager.socket.disconnect()
                    #endif
                }
                
                self.view?.presentScene(MainMenuScene(), transition: self.transition)
                break
                
            case states.chooseSector:
                self.view?.presentScene(ChooseSector(), transition: self.transition)
                break
                
            case states.mission:
                
                let scene = MissionScene(size:CGSize(width: 1920.0/2, height: 1080.0/2))
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
        #if os(iOS) || os(OSX)
            self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) -> Void in
                
                //print(socketAnyEvent.description)
                
                guard let scene = self else { return }
                
                switch scene.state {
                case states.hangar:
                    
                    switch (socketAnyEvent.event) {
                    case "currentRoomId":
                        
                        if let currentRoomId = socketAnyEvent.items?.firstObject as? String {
                            scene.currentRoom.loadRoomInfo(roomId: currentRoomId, names: [scene.serverManager.peerID.displayName])
                        }
                        
                        break
                        
                    case "error":
                        if let message = socketAnyEvent.items?.firstObject as? String {
                            scene.lastSocketErrorMessage = message
                        } else {
                            scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
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
