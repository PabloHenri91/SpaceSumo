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
    
    
    override init() {
        super.init()
        
        var textureName:String!
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
        
        let spriteNode = SKSpriteNode(imageNamed: textureName)
        spriteNode.texture?.filteringMode = .Linear
        
        self.addChild(spriteNode)
        
        let size = spriteNode.texture!.size()
        let scale = min(32/size.width, 32/size.height)
        spriteNode.size = CGSize(width: size.width * scale, height: size.height * scale)
        
        
        self.screenPosition = CGPoint(x: Int.random(Int(((1920/2) + 1334)/2)), y: Int.random(Int(((1080/2) + 750)/2)))//TODO: posicao inicial
        self.yAlign = .center
        self.xAlign = .center
        
        self.resetPosition()
        
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = World.categoryBitMask.playerShip.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.playerShip
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.playerShip
        
        self.physicsBody?.linearDamping = 2
        self.physicsBody?.angularDamping = 2
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
            print("didBeginContact: playerShip -> laser")
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
    
    func update(currentTime: NSTimeInterval, applyAngularImpulse:Bool, applyForce:Bool) {
        
        if self.healthPoints > 0 {
            
            if isOnScree() {
                self.lastOnScreen = currentTime
            }
            
            if currentTime - self.lastOnScreen > 1 {
                self.screenPosition = CGPoint(x: ((1920/2) + 1334)/4, y: ((1080/2) + 750)/4)
                self.resetPosition()
                self.physicsBody?.velocity = CGVector.zero
            }
            
            if applyAngularImpulse || applyForce {
                
                let dx = Float(Control.totalDx)
                let dy = Float(Control.totalDy)
                let auxRotation = CGFloat(-atan2f(dx, dy))
                var totalRotation = auxRotation - self.zRotation
                
                if applyAngularImpulse {
                    
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
            
            if currentTime - self.lastLaser > 0.1 {
                let laser = Laser(position: self.position, zRotation: self.zRotation, shooter: self.physicsBody!)
                self.parent?.addChild(laser)
                self.lastLaser = currentTime
            }
        }
    }
    
    func isOnScree() -> Bool {
        
        if(self.position.x >  Config.currentSceneSize.width) {
            return false
        }
        if(self.position.x < 0) {
            return false
        }
        if(self.position.y > 0) {
            return false
        }
        if(self.position.y <  -Config.currentSceneSize.height) {
            return false
        }
        
        return true
    }
}
