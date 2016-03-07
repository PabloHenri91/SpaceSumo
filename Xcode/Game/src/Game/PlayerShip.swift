//
//  PlayerShip.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class PlayerShip: Control {
    
    static var playerShipSet = Set<PlayerShip>()
    
    var healthPoints = 10
    
    var maxAngularVelocity:CGFloat = 3
    
    var lastLaser:NSTimeInterval = 0
    
    var force:CGFloat = 50
    
    override init() {
        super.init()
        
        var textureName:String!
        let i = Int.random(min: 1, max: 3).description
        
        switch Int.random(4) {
        case 0:
            textureName = "playerShip\(i)_blue"
            break
        case 1:
            textureName = "playerShip\(i)_green"
            break
        case 2:
            textureName = "playerShip\(i)_orange"
            break
        case 3:
            textureName = "playerShip\(i)_red"
            break
        default:
            break
        }
        
        let spriteNode = SKSpriteNode(imageNamed: textureName)
        spriteNode.texture?.filteringMode = .Linear
        
        self.addChild(spriteNode)
        
        let size = spriteNode.texture!.size()
        let scale = min(32/size.width, 32/size.height)
        spriteNode.size = CGSize(width: size.width * scale, height: size.height * scale)
        
        self.screenPosition = CGPoint(x: 0, y: 0)
        self.yAlign = .center
        self.xAlign = .center
        
        self.resetPosition()
        
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = World.categoryBitMask.playerShip.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.playerShip
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.playerShip
        
        self.physicsBody?.linearDamping = 1
        self.physicsBody?.angularDamping = 1
        
        PlayerShip.playerShipSet.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        switch physicsBody.categoryBitMask {
            
        case World.categoryBitMask.laser.rawValue:
            
            if let _ = physicsBody.node as? Laser {
                
            }
            break
            
        default:
            break
        }
    }
    
    func didEndContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        switch physicsBody.categoryBitMask {
            
        case World.categoryBitMask.laser.rawValue:
            
            if let _ = physicsBody.node as? Laser {
                
            }
            break
            
        default:
            break
        }
    }
    
    func update(currentTime: NSTimeInterval, applyAngularImpulse:Bool, applyForce:Bool) {
        
        if self.healthPoints > 0 {
            
            if applyAngularImpulse || applyForce {
                
                let dx = Float(Control.totalDx)
                let dy = Float(Control.totalDy)
                let auxRotation = CGFloat(-atan2f(dx, dy))
                var totalRotation = auxRotation - self.zRotation
                
                if applyAngularImpulse  {
                    
                    if(abs(self.physicsBody!.angularVelocity) < self.maxAngularVelocity) {
                        
                        while(totalRotation < -CGFloat(M_PI)) { totalRotation += CGFloat(M_PI * 2) }
                        while(totalRotation >  CGFloat(M_PI)) { totalRotation -= CGFloat(M_PI * 2) }
                        
                        self.physicsBody?.applyAngularImpulse(totalRotation * 0.0001)
                    }
                }
                
                if applyForce {
                    if(abs(totalRotation) < 1) {
                        self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                    }
                }
            }
            
            //Laser
            
            if currentTime - self.lastLaser > 1 {
                let laser = Laser(position: self.position, zRotation: self.zRotation, shooter: self.physicsBody!)
                self.parent?.addChild(laser)
                self.lastLaser = currentTime
            }
        }
    }
    
    override func removeFromParent() {
        PlayerShip.playerShipSet.remove(self)
        super.removeFromParent()
    }
}
