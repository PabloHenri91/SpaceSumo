//
//  PlayerShip.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class PlayerShip: Control {
    
    var healthPoints = 10
    
    var maxAngularVelocity:CGFloat = 3
    
    var lastLaser:NSTimeInterval = 0
    var lastOnScreen:NSTimeInterval = 0
    
    var force:CGFloat = 25
    
    var labelName:Label?
    var labelScore:Label?
    
    var lastShooterName: String?
    
    var auxRotation:CGFloat = 0
    
    var textureName:String!
    
    override init() {
        super.init()
        
        
        let i = Int.random(min: 1, max: 3).description
        
//        switch Int.random(4) {
//        case 0:
            textureName = "playerShip\(i)_blue"
//            break
//        case 1:
//            textureName = "playerShip\(i)_green"
//            break
//        case 2:
//            textureName = "playerShip\(i)_orange"
//            break
//        case 3:
//            textureName = "playerShip\(i)_red"
//            break
//        default:
//            break
//        }
        
        let spriteNode = SKSpriteNode(imageNamed: self.textureName)
        spriteNode.texture?.filteringMode = .Linear
        
        self.addChild(spriteNode)
        
        let size = spriteNode.texture!.size()
        let scale = min(32/size.width, 32/size.height)
        spriteNode.size = CGSize(width: size.width * scale, height: size.height * scale)
        
        
        self.position = CGPoint(x: Int.random(Int(GameCamera.arenaSizeWidth)), y: -Int.random(Int(GameCamera.arenaSizeHeight)))
        
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = World.categoryBitMask.playerShip.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.playerShip
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.playerShip
        
        self.physicsBody?.linearDamping = 2
        self.physicsBody?.angularDamping = 3
        self.physicsBody?.restitution = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        switch physicsBody.categoryBitMask {
            
        case World.categoryBitMask.playerShip.rawValue:
            print("didBeginContact: playerShip -> playerShip")
            break
            
        case World.categoryBitMask.myLaser.rawValue:
            print("didBeginContact: playerShip -> myLaser")
            break
            
        case World.categoryBitMask.laser.rawValue:
            self.lastShooterName = (physicsBody.node as? Laser)?.shooterName
            physicsBody.node?.removeFromParent()
            break
            
        case World.categoryBitMask.ufo.rawValue:
            print("didBeginContact: playerShip -> ufo")
            break
            
        case World.categoryBitMask.enemy.rawValue:
            print("didBeginContact: playerShip -> enemy")
            break
            
        default:
            break
        }
    }
    
    func didEndContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        switch physicsBody.categoryBitMask {
            
        case World.categoryBitMask.myLaser.rawValue:
            (physicsBody.node as? Laser)?.resetBitMasks()
            break
            
        default:
            fatalError()
            break
        }
    }
    
    func setNameLabel(name:String) {
        if let parent = self.parent {
            self.labelName = Label(color: GameColors.white, text: name, fontSize: GameFonts.fontSize.large)
            parent.addChild(self.labelName!)
            
            self.labelScore = Label(color: GameColors.white, text: "0", fontSize: GameFonts.fontSize.large)
            parent.addChild(self.labelScore!)
        }
    }
    
    func update(currentTime: NSTimeInterval, applyAngularImpulse:Bool, applyForce:Bool) {
        
        self.labelName?.position = CGPoint(x: self.position.x, y: self.position.y + 64)
        self.labelScore?.position = CGPoint(x: self.position.x, y: self.position.y + -64)
        
        if self.healthPoints > 0 {
            
            if isOnScree() {
                self.lastOnScreen = currentTime
            }
            
            if currentTime - self.lastOnScreen > 0 {
                self.position = CGPoint(x: GameCamera.arenaSizeWidth/2, y: -GameCamera.arenaSizeHeight/2)
                
                self.physicsBody?.velocity = CGVector.zero
                
//                if let label = self.labelScore {
//                    label.setText(String(Int(label.getText())! + 1))
//                    if let scene = self.scene {
//                        if let missionScene = scene as? MissionScene {
//                            
//                            if let name = missionScene.serverManager.userDisplayInfo.socketId {
//                                missionScene.serverManager.socket.emit("someData", ["score", name, label.getText()])
//                            }
//
//                            
//                        }
//                    }
//                }
                
                if let scene = self.scene {
                    if let missionScene = scene as? MissionScene {
                        if let name = self.lastShooterName {
                            missionScene.serverManager.socket.emit("someData", ["scoreUp", name])
                            
//                            if let selfName = self.name {
//                                missionScene.serverManager.socket.emit("someData", ["dead", selfName])
//                            }
                            
                            //self.labelScore?.setText("0")
                            
                            for allyShip in AllyShip.allyShipSet {
                                if name == allyShip.name! {
                                    let score = Int((allyShip.labelScore?.getText())!)! + 1
                                    allyShip.labelScore?.setText(String(score))
                                    break
                                }
                            }
                            
                            for botAllyShip in BotAllyShip.botAllyShipSet {
                                if name == botAllyShip.name! {
                                    let score = Int((botAllyShip.labelScore?.getText())!)! + 1
                                    botAllyShip.labelScore?.setText(String(score))
                                    break
                                }
                            }
                            
                        }
                    }
                    
                }
                
                self.lastShooterName = ""
                
            }
            
            if applyAngularImpulse || applyForce {
                
                let dx = Float(Control.totalDx)
                let dy = Float(Control.totalDy)
                self.auxRotation = CGFloat(-atan2f(dx, dy))
                var totalRotation = self.auxRotation - self.zRotation
                
                if applyAngularImpulse {
                    
                    if(abs(self.physicsBody!.angularVelocity) < self.maxAngularVelocity) {
                        
                        while(totalRotation < -CGFloat(M_PI)) { totalRotation += CGFloat(M_PI * 2) }
                        while(totalRotation >  CGFloat(M_PI)) { totalRotation -= CGFloat(M_PI * 2) }
                        
                        self.physicsBody?.applyAngularImpulse(totalRotation * 0.0005)
                    }
                }
                
                if applyForce {
                    if(abs(totalRotation) < 1) {
                        self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                    }
                }
            } else {
                if(abs(self.physicsBody!.angularVelocity) < self.maxAngularVelocity) {
                    
                    var totalRotation = self.auxRotation - self.zRotation
                    
                    while(totalRotation < -CGFloat(M_PI)) { totalRotation += CGFloat(M_PI * 2) }
                    while(totalRotation >  CGFloat(M_PI)) { totalRotation -= CGFloat(M_PI * 2) }
                    
                    self.physicsBody?.applyAngularImpulse(totalRotation * 0.0005)
                }
            }
            
            //Laser
            
            if currentTime - self.lastLaser > 0.1 {
                
                if let name = self.name {
                    
                    let laser = Laser(position: self.position, zRotation: self.zRotation, shooter: self.physicsBody!, shooterName: name)
                    
                    self.parent?.addChild(laser)
                    self.lastLaser = currentTime
                    
                }
                
                
                
                
            }
        }
    }
    
    func isOnScree() -> Bool {
        
        if(self.position.x > GameCamera.arenaSizeWidth) {
            return false
        }
        if(self.position.x < 0) {
            return false
        }
        if(self.position.y > 0) {
            return false
        }
        if(self.position.y <  -GameCamera.arenaSizeHeight) {
            return false
        }
        
        return true
    }
}
