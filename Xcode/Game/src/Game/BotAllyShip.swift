//
//  BotAllyShip.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 4/7/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class BotAllyShip: AllyShip {
    
    static var botAllyShipSet = Set<BotAllyShip>()
    
    var lastMovingChange:Double = 0
    var movingChangeInterval:Double = 0
    var movingType = 0
    var destination = CGPoint.zero
    var needToMove = false
    
    var auxRotation:CGFloat = 0
    
    var targetNode:SKNode?
    
    override init() {
        super.init()
        
        self.position = CGPoint(x: Int.random(Int(GameCamera.arenaSizeWidth)), y: -Int.random(Int(GameCamera.arenaSizeHeight)))
        
        self.physicsBody?.categoryBitMask = World.categoryBitMask.botAllyShip.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.botAllyShip
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.botAllyShip
        
        AllyShip.allyShipSet.remove(self)
        BotAllyShip.botAllyShipSet.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func update(currentTime: NSTimeInterval) {
        for botAllyShip in BotAllyShip.botAllyShipSet {
            botAllyShip.update(currentTime)
        }
    }
    
    func setRandomMovingType(currentTime: NSTimeInterval) {
        self.lastMovingChange = currentTime
        
        self.targetNode = nil
        
        self.movingChangeInterval = Double.random(min: 0.5, max: 2.5)
        self.movingType = Int.random(2) + 1 //integer between 0 and 3-1.
    }

    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if self.healthPoints > 0 {
            
            if isOnScree() {
                self.lastOnScreen = currentTime
            }
            
            if currentTime - self.lastOnScreen > 0 {
                self.position = CGPoint(x: GameCamera.arenaSizeWidth/2, y: -GameCamera.arenaSizeHeight/2)
                
                self.physicsBody?.velocity = CGVector.zero
                
                if let name = self.name {
                    if let label = self.labelScore {
                        label.setText(String(Int(label.getText())! + 1))
                        if let scene = self.scene {
                            if let missionScene = scene as? MissionScene {
                                missionScene.serverManager.socket.emit("someData", ["score", name, label.getText()])
                            }
                        }
                    }
                }
            }
            
            if (currentTime - self.lastMovingChange > self.movingChangeInterval) {
                self.setRandomMovingType(currentTime)
            }
            
            switch (self.movingType) {
                
            case 0:
                self.setRandomMovingType(currentTime)
                break
                
            //I want to go to the center of the screen
            case 1:
                self.destination = CGPoint(x: GameCamera.arenaSizeWidth/2, y: -GameCamera.arenaSizeHeight/2)
                self.needToMove = true
                break
                
            case 2:
                let botAllyShip = BotAllyShip.botAllyShipSet[BotAllyShip.botAllyShipSet.startIndex.advancedBy(Int.random(BotAllyShip.botAllyShipSet.count))]
                
                if botAllyShip.name != self.name {
                    self.targetNode = botAllyShip
                } else {
                    if AllyShip.allyShipSet.count > 0 {
//                        let allyShip = AllyShip.allyShipSet[AllyShip.allyShipSet.startIndex.advancedBy(Int.random(AllyShip.allyShipSet.count))]
//                        self.targetNode = allyShip
                    } else {
                        if let scene = self.scene as? MissionScene {
                            self.targetNode = scene.playerShip
                        }
                    }
                }
                
                self.needToMove = true
                break
                
            default:
                break
            }
            
            if (self.needToMove) {
                
                if let nodePosition = self.targetNode?.position {
                    self.destination = nodePosition
                }
                
                if CGPoint.distance(self.position, self.destination) < 64 {
                    self.needToMove = false
                    self.movingType = 0
                } else {
                    let dx = Float(self.destination.x - self.position.x)
                    let dy = Float(self.destination.y - self.position.y)
                    self.auxRotation = CGFloat(-atan2f(dx, dy))
                    var totalRotation = self.auxRotation - self.zRotation
                    
                    
                    if(abs(self.physicsBody!.angularVelocity) < self.maxAngularVelocity) {
                        
                        while(totalRotation < -CGFloat(M_PI)) { totalRotation += CGFloat(M_PI * 2) }
                        while(totalRotation >  CGFloat(M_PI)) { totalRotation -= CGFloat(M_PI * 2) }
                        
                        self.physicsBody?.applyAngularImpulse(totalRotation * 0.0005)
                    }
                    
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
        }
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        BotAllyShip.botAllyShipSet.remove(self)
    }
}
