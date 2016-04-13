//
//  MissionScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class MissionScene: GameScene {
    
    enum states : String {
        //Estado principal
        case mission
        case reconnecting
        case connectionClosed
        case mainMenu
        
        //Estados de saida da scene
        case hangar
    }
    
    //Estados iniciais
    var state = states.mission
    var nextState = states.mission
    
    //buttons
    var buttonBack:Button!
    
    var sector = 0
    
    var world:World!
    var gameCamera:GameCamera!
    
    var playerShip:PlayerShip!
    
    let thumbstick = Thumbstick()
    
    var parallax:Parallax!
    
    var offlineMode = true
    var serverManager = ServerManager.sharedInstance
    
    var lastEmit:NSTimeInterval = 0
    var emitInterval:NSTimeInterval = 1/30
    
    var lastSocketErrorMessage = ""
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        
        self.parallax = Parallax()
        self.addChild(self.parallax)
        
        self.world = World(physicsWorld: self.physicsWorld)
        self.addChild(self.world)
        self.physicsWorld.contactDelegate = self.world
        
        self.gameCamera = GameCamera()
        self.world.addChild(self.gameCamera)
        
        self.playerShip = PlayerShip()
        self.world.addChild(self.playerShip)
        self.playerShip.setNameLabel(self.serverManager.userDisplayInfo.displayName!)
        
        self.gameCamera.update(self.playerShip.position)
        
        #if os(iOS) || os(OSX)
            self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
            self.addChild(self.buttonBack)
        #endif
        
        //Serve para setar o foco inicial no tvOS
        GameScene.selectedButton = self.buttonBack
        
        self.offlineMode = !(self.serverManager.socket.status == .Connected)
        
        if self.offlineMode {
            self.addBots()
            self.serverManager.socket.onAny({ (SocketAnyEvent) in
            })
        } else {
            self.setHandlers()
            self.addPlayers()
        }
    }
    
    func addBots() {
        for _ in 0..<1 {
            let newAllyShip = BotAllyShip()
            var someName = CharacterGenerator.sharedInstance.getName(.random, gender: .random)
            someName = someName.componentsSeparatedByString(" ").first!
            newAllyShip.name = "Bot " + someName
            self.world.addChild(newAllyShip)
            newAllyShip.setNameLabel()
        }
    }
    
    func addPlayers() {
        
        var i = 0
        
        for userDisplayInfo in self.serverManager.usersDisplayInfo {
            if userDisplayInfo.socketId! != self.serverManager.userDisplayInfo.socketId! {
                let newAllyShip = AllyShip()
                newAllyShip.name = userDisplayInfo.socketId!
                self.world.addChild(newAllyShip)
                newAllyShip.setNameLabel()
                newAllyShip.labelName!.setText(userDisplayInfo.displayName!)
                i += 1
            }
        }
        
        if self.serverManager.roomId! == self.serverManager.userDisplayInfo.socketId! {
            var botNames = [String]()
            botNames.append("botNames")
            
            if i < 1 {
                for _ in i..<1 {
                    let newBotAllyShip = BotAllyShip()
                    var someName = CharacterGenerator.sharedInstance.getName(.random, gender: .random)
                    someName = someName.componentsSeparatedByString(" ").first!
                    newBotAllyShip.name = "Bot " + someName
                    botNames.append(newBotAllyShip.name!)
                    self.world.addChild(newBotAllyShip)
                    newBotAllyShip.setNameLabel()
                }
                self.serverManager.socket.emit("someData", botNames)
            }
        }
    }
    
    func setHandlers() {
        self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) in
            
            //print(socketAnyEvent.description)
            
            guard let scene = self else { return }
            
            switch scene.state {
                
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
                    scene.serverManager.socket.emit("joinRoom", scene.serverManager.roomId!)
                    scene.state = states.mission
                    scene.nextState = states.mission
                    
                    break
                    
                case "reconnectAttempt":
                    print("reconnecting...")
                    break
                    
                default:
                    print(socketAnyEvent.event + " nao foi processado em HangarScene " + scene.state.rawValue)
                    break
                }
                
                break
                
            case states.mission:
                switch (socketAnyEvent.event) {
                    
                case "error":
                    if let message = socketAnyEvent.items?.firstObject as? String {
                        scene.lastSocketErrorMessage = message
                    } else {
                        scene.lastSocketErrorMessage = "Something went very very wrong.. oops!!"
                    }
                    break
                    
                case "reconnect":
                    print("reconnecting...")
                    scene.state = states.reconnecting
                    scene.nextState = states.reconnecting
                    break
                    
                case "someData":
                    if let message = socketAnyEvent.items?.firstObject as? [String] {
                        var i = message.generate()
                        
                        switch (i.next()!) {
                            case "botNames":
                                for _ in 1..<message.count {
                                    let name = i.next()!
                                    let newAllyShip = AllyShip()
                                    newAllyShip.name = name
                                    scene.world.addChild(newAllyShip)
                                    newAllyShip.setNameLabel()
                                }
                            break
                        case "score":
                            let name = i.next()!
                            for allyShip in AllyShip.allyShipSet {
                                if name == allyShip.name! {
                                    let score = i.next()!
                                    allyShip.labelScore?.setText(score)
                                    break
                                }
                            }
                            
                            break
                        case "removeBots":
                            for _ in 1..<message.count {
                                let name = i.next()!
                                
                                for allyShip in AllyShip.allyShipSet {
                                    if name == allyShip.name! {
                                        allyShip.removeFromParent()
                                        break
                                    }
                                }
                            }
                            break
                        default:
                            print(socketAnyEvent.description + " nao foi processado em MissionScene " + scene.state.rawValue)
                            break
                        }
                    }
                    
                    break
                case "update":
                    if let message = socketAnyEvent.items?.firstObject as? [AnyObject] {
                        for ally in AllyShip.allyShipSet {
                            if let socketId = message[0] as? String {//TODO: remover message[i] ???
                                
                                if ally.name! == socketId {
                                    if let x = message[1] as? Double {
                                        ally.position.x = CGFloat(x)
                                    }
                                    if let y = message[2] as? Double {
                                        ally.position.y = CGFloat(y)
                                    }
                                    if let zRotation = message[3] as? Double {
                                        ally.zRotation = CGFloat(zRotation/1000000)
                                    }
                                    if let physicsBody = ally.physicsBody {
                                        if let dx = message[4] as? Double {
                                            physicsBody.velocity.dx = CGFloat(dx/1000000)
                                        }
                                        if let dy = message[5] as? Double {
                                            physicsBody.velocity.dy = CGFloat(dy/1000000)
                                        }
                                        if let angularVelocity = message[6] as? Double {
                                            physicsBody.angularVelocity = CGFloat(angularVelocity/1000000)
                                        }
                                    }
                                    break
                                }
                            }
                        }
                    }
                    break
                    
                case "removePlayer":
                    if let message = socketAnyEvent.items?.firstObject as? String {
                        for allyShip in AllyShip.allyShipSet {
                            if allyShip.name! == message {
                                allyShip.removeFromParent()
                            }
                        }
                    }
                    break
                    
                case "addPlayer":
                    //TODO: readdPlayer
                    if let message = socketAnyEvent.items?.firstObject as? [String] {
                        
                        let newAllyShip = AllyShip()
                        newAllyShip.name = message[0]
                        scene.world.addChild(newAllyShip)
                        newAllyShip.setNameLabel()
                        newAllyShip.labelName?.setText(message[1])
                        
                        for botAllyShip in BotAllyShip.botAllyShipSet {
                            botAllyShip.removeFromParent()
                        }
                    }
                    break
                    
                default:
                    print(socketAnyEvent.event + " nao foi processado em MissionScene " + scene.state.rawValue)
                    break
                }
                break
                
            default:
                print(socketAnyEvent.event + " recebido fora do estado esperado em MissionScene " + scene.state.rawValue)
                break
            }
        }
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        
        if !self.offlineMode {
            if AllyShip.allyShipSet.count > 0 {
                
                if GameScene.currentTime - self.lastEmit > self.emitInterval {
                    self.lastEmit = GameScene.currentTime
                    
                    var data = [AnyObject]()
                    data.append(self.serverManager.userDisplayInfo.socketId!)//TODO: if let
                    data.append(Int(self.playerShip.position.x))
                    data.append(Int(self.playerShip.position.y))
                    data.append(Int(self.playerShip.zRotation * 1000000))
                    if let physicsBody = self.playerShip.physicsBody {
                        data.append(Int(physicsBody.velocity.dx * 1000000))
                        data.append(Int(physicsBody.velocity.dy * 1000000))
                        data.append(Int(physicsBody.angularVelocity * 1000000))
                    }
                    
                    self.serverManager.socket.emit("update", data)
                    
                    for botAllyShip in BotAllyShip.botAllyShipSet {
                        var data = [AnyObject]()
                        data.append(botAllyShip.name!)
                        data.append(Int(botAllyShip.position.x))
                        data.append(Int(botAllyShip.position.y))
                        data.append(Int(botAllyShip.zRotation * 1000000))
                        if let physicsBody = botAllyShip.physicsBody {
                            data.append(Int(physicsBody.velocity.dx * 1000000))
                            data.append(Int(physicsBody.velocity.dy * 1000000))
                            data.append(Int(physicsBody.angularVelocity * 1000000))
                        }
                        self.serverManager.socket.emit("update", data)
                    }
                }
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
                
            case states.reconnecting:
                if(!self.offlineMode) {
                    if (self.serverManager.socket.status == .Closed) {
                        self.nextState = states.connectionClosed
                    }
                }
                break
                
            case states.mission:
                var applyAngularImpulse = false
                var applyForce = false
                
                if Control.totalDx != 0 || Control.totalDy != 0 {
                    applyAngularImpulse = true
                    applyForce = true
                }
                
                self.playerShip.update(currentTime, applyAngularImpulse: applyAngularImpulse, applyForce: applyForce)
                AllyShip.update(currentTime)
                BotAllyShip.update(currentTime)
                
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
                
            case states.mainMenu:
                if(!self.offlineMode) {
                    self.serverManager.disconnect()
                }
                
                self.view?.presentScene(MainMenuScene(), transition: self.transition)
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
                
            case states.hangar:
                Config.sceneSize = CGSize(width: 480/Config.screenScale, height: 270/Config.screenScale)
                Config.updateSceneSize()
                
                var botNames = [String]()
                botNames.append("removeBots")
                
                for botAllyShip in BotAllyShip.botAllyShipSet {
                    botNames.append(botAllyShip.name!)
                }
                
                self.serverManager.socket.emit("someData", botNames)
                self.serverManager.leaveAllRooms()
                
                self.view?.presentScene(HangarScene(), transition: self.transition)
                break
                
            default:
                break
            }
        }
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        self.gameCamera.update(self.playerShip.position)
        self.parallax.update(self.gameCamera.position)
    }
    
    override func touchesBegan(touches: Set<UITouch>) {
        super.touchesBegan(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in Control.touchesArray.keys {
                let point = touch.locationInNode(self)
                switch (self.state) {
                    
                case states.mission:
                    
                    if let _ = self.thumbstick.touch { } else {
                        self.thumbstick.touch = touch
                        
                        self.addChild(self.thumbstick)
                        self.thumbstick.hidden = false
                        
                        #if os(iOS) || os(OSX)
                            self.thumbstick.position = point
                        #endif
                        
                        self.thumbstick.circleWhite32x32.position = CGPoint.zero
                        
                    }
                    
                    break
                default:
                    break
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>) {
        super.touchesMoved(touches)
        
        self.thumbstick.update(totalDx: Control.totalDx, totalDy: Control.totalDy)
    }
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        if let thumbstickTouch = self.thumbstick.touch {
            for touch in touches {
                if (thumbstickTouch == touch) {
                    self.thumbstick.touch = nil
                    self.thumbstick.hidden = true
                    self.thumbstick.removeFromParent()
                }
            }
        }
    }
    
    override func touchesCancelled() {
        super.touchesCancelled()
        
        self.thumbstick.touch = nil
        self.thumbstick.hidden = true
        self.thumbstick.removeFromParent()
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                let location = touch.locationInNode(self)
                switch (self.state) {
                case states.mission:
                    #if os(iOS) || os(OSX)
                        if(self.buttonBack.containsPoint(location)) {
                            self.nextState = states.hangar
                            return
                        }
                    #endif
                    
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
