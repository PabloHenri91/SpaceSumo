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
    var currentRoom:RoomCell?
    
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
        
        self.gameCamera.update(self.playerShip.position)
        
//        for _ in 0 ..< 250 {
//            let ufo = Ufo(enemyNode: self.playerShip)
//            self.world.addChild(ufo)
//        }
//        
//        for _ in 0 ..< 250 {
//            let enemy = Enemy(enemyNode: self.playerShip)
//            self.world.addChild(enemy)
//        }
        
        #if os(iOS) || os(OSX)
            self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 228, xAlign: .left, yAlign: .down)
            self.addChild(self.buttonBack)
        #endif
        
        //Serve para setar o foco inicial no tvOS
        GameScene.selectedButton = self.buttonBack
        
        self.offlineMode = !(self.serverManager.socket.status == .Connected)
        
        if self.offlineMode {
            self.serverManager.socket.onAny({ (SocketAnyEvent) in
            })
        } else {
            self.addHandlers()
            self.addPlayers()
        }
    }
    
    func addPlayers() {
        if let roomCell = self.currentRoom {
            for name in roomCell.names {
                if name != self.serverManager.displayName {
                    let newPlayerShip = PlayerShip()
                    newPlayerShip.name = name
                    self.world.addChild(newPlayerShip)
                }
            }
        }
    }
    
    func addHandlers() {
        self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) in
            
            //print(socketAnyEvent.description)
            
            guard let scene = self else { return }
            
            switch scene.state {
                
            case states.mission:
                switch (socketAnyEvent.event) {
                    
                case "update":
                    if let message = socketAnyEvent.items?.firstObject as? [AnyObject] {
                        for player in PlayerShip.playerShipSet {
                            if let name = message[0] as? String {//TODO: remover message[i]
                                if player.name == name {
                                    if let x = message[1] as? Double {
                                        player.position.x = CGFloat(x)
                                    }
                                    if let y = message[2] as? Double {
                                        player.position.y = CGFloat(y)
                                    }
                                    if let zRotation = message[3] as? Double {
                                        player.zRotation = CGFloat(zRotation)
                                    }
                                    if let physicsBody = player.physicsBody {
                                        if let dx = message[4] as? Double {
                                            physicsBody.velocity.dx = CGFloat(dx)
                                        }
                                        if let dy = message[5] as? Double {
                                            physicsBody.velocity.dy = CGFloat(dy)
                                        }
                                        if let angularVelocity = message[6] as? Double {
                                            physicsBody.angularVelocity = CGFloat(angularVelocity)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break
                    
                case "removePlayer":
                    print(socketAnyEvent.description)//TODO remover player
                    break
                    
                case "addPlayer":
                    if let message = socketAnyEvent.items?.firstObject as? String {
                        let newPlayerShip = PlayerShip()
                        newPlayerShip.name = message
                        scene.world.addChild(newPlayerShip)
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
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
            case states.mission:
                var applyAngularImpulse = false
                var applyForce = false
                
                if Control.totalDx != 0 || Control.totalDy != 0 {
                    applyAngularImpulse = true
                    applyForce = true
                }
                
                self.playerShip.update(currentTime, applyAngularImpulse: applyAngularImpulse, applyForce: applyForce)
                
                if !self.offlineMode {
                    var data = [AnyObject]()
                    data.append(self.serverManager.displayName)
                    data.append(self.playerShip.position.x)
                    data.append(self.playerShip.position.y)
                    data.append(self.playerShip.zRotation)
                    if let physicsBody = self.playerShip.physicsBody {
                        data.append(physicsBody.velocity.dx)
                        data.append(physicsBody.velocity.dy)
                        data.append(physicsBody.angularVelocity)
                    }
                    self.serverManager.socket.emit("update", data)
                }
                
                Ufo.update(currentTime)
                Enemy.update(currentTime)
                break
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case states.hangar:
                Config.sceneSize = CGSize(width: 480/Config.screenScale, height: 270/Config.screenScale)
                Config.updateSceneSize()
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
