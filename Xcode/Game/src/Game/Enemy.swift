//
//  Enemy.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Enemy: Control {
    
    static var enemySet = Set<Enemy>()
    static var noEnemiesOnScreen = true
    
    var maxAngularVelocity:CGFloat = 3
    var force:CGFloat = 50
    var onScreen = false
    var enemyNode:SKNode
    var totalRotationToEnemyNode:CGFloat = 0
    var totalRotationToDestination:CGFloat = 0
    var movingType = 0
    var lastMovingChange:Double = 0
    var movingChangeInterval:Double = 0
    var shouldRotateToDestination = false//TODO: precisa ser analizado
    var destination = CGPoint.zero
    var needToMove = false
    
    var lastLaser:NSTimeInterval = 0
    
    init(enemyNode:SKNode) {
        self.enemyNode = enemyNode
        super.init()
        
        var distance = CGPoint.distance(self.position, enemyNode.position)
        let minDistance = CGPoint.distance(CGPoint.zero, CGPoint(x: Config.currentSceneSize.width, y: Config.currentSceneSize.height))
        
        while(distance < minDistance) {
            self.position = CGPoint(
                x: Int.random(min: enemyNode.position.x - (minDistance * 2), max: enemyNode.position.x + (minDistance * 2)),
                y: Int.random(min: enemyNode.position.y - (minDistance * 2), max: enemyNode.position.y + (minDistance * 2)))
            
            distance = CGPoint.distance(self.position, enemyNode.position)
        }
        
        var textureName:String!
        let i = Int.random(min: 1, max: 5).description
        
        switch Int.random(4) {
        case 0:
            textureName = "enemyBlack\(i)"
            break
        case 1:
            textureName = "enemyBlue\(i)"
            break
        case 2:
            textureName = "enemyGreen\(i)"
            break
        case 3:
            textureName = "enemyRed\(i)"
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
        
        self.zPosition = -2
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = World.categoryBitMask.enemy.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.enemy
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.enemy
        
        self.physicsBody?.linearDamping = 2
        self.physicsBody?.angularDamping = 2
        self.physicsBody?.restitution = 0.5
        
        Enemy.enemySet.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        physicsBody.node?.removeFromParent()
        self.removeFromParent()
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
    
    func isOnScree() -> Bool {
        
        if(self.position.x > self.enemyNode.position.x + Config.currentSceneSize.width/2) {
            return false
        }
        if(self.position.x < self.enemyNode.position.x - Config.currentSceneSize.width/2) {
            return false
        }
        if(self.position.y > self.enemyNode.position.y + Config.currentSceneSize.height/2) {
            return false
        }
        if(self.position.y < self.enemyNode.position.y - Config.currentSceneSize.height/2) {
            return false
        }
        
        return true
    }
    
    
    static func update(currentTime: NSTimeInterval) {
        
        Enemy.noEnemiesOnScreen = true
        
        for enemy in Enemy.enemySet {
            
            enemy.onScreen = enemy.isOnScree()
            enemy.hidden = !enemy.onScreen
            
            if enemy.onScreen {
                Enemy.noEnemiesOnScreen = false
            }
        }
        
        for enemy in Enemy.enemySet {
            enemy.update(currentTime)
        }
    }
    
    
    func update(currentTime: NSTimeInterval) {
        self.onScreen = self.isOnScree()
        self.randomMove(currentTime)
    }
    
    func randomMove(currentTime: NSTimeInterval) {
        if (self.onScreen) {
            
            if (currentTime - self.lastMovingChange > self.movingChangeInterval) {
                self.lastMovingChange = currentTime
                self.movingChangeInterval = Double.random(min: 0.5, max: 2.5)
                self.movingType = Int.random(min: 1, max: 5)
                self.shouldRotateToDestination = !self.shouldRotateToDestination
                
                //Ajuste de movingType
                if self.movingType < 4 {        // 1, 2, 3
                    self.movingType = 1
                } else if self.movingType < 5 { //4
                    self.movingType = 2
                } else {                        //5
                    self.movingType = 3
                }
            }
            
            switch (self.movingType) {
                
            case 1:
                let maxDx = Config.currentSceneSize.width/2
                let maxDy = Config.currentSceneSize.height/2
                
                self.destination = CGPoint(
                    x: Int.random(
                        min: self.enemyNode.position.x - maxDx,
                        max: self.enemyNode.position.x + maxDx),
                    y: Int.random(
                        min: self.enemyNode.position.y - maxDy,
                        max: self.enemyNode.position.y + maxDy))
                
                self.needToMove = true
                self.movingType = 0
                break
                
            case 2:
                self.destination = enemyNode.position
                self.needToMove = true
                self.movingType = 0
                break
                
            case 3:
                self.needToMove = false
                self.movingType = 0
                break
                
            default:
                break
            }
            
            if self.shouldRotateToDestination || self.needToMove {
                self.totalRotationToDestination = self.rotateToPoint(self.destination)
            }
            
            if (self.needToMove) {
                if CGPoint.distance(self.position, self.destination) < 64 {
                    self.needToMove = false
                } else {
                    
                    if ((self.needToMove && abs(self.totalRotationToDestination) < 1) || self.shouldRotateToDestination) {
                        if CGPoint.distance(CGPoint.zero, CGPoint(x: self.physicsBody!.velocity.dx, y: self.physicsBody!.velocity.dy)) < 100 {
                            self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                        }
                    }
                }
            }
            
            //Laser
            
            if currentTime - self.lastLaser > 0.1 {
                let laser = Laser(position: self.position, zRotation: self.zRotation, shooter: self.physicsBody!)
                self.parent?.addChild(laser)
                self.lastLaser = currentTime
            }
            
        } else {
            if Enemy.noEnemiesOnScreen {
                self.seekEnemyNode()
                self.movingType = 2
            }
        }
    }
    
    func rotateToPoint(point:CGPoint) -> CGFloat {
        
        let totalDx = point.x - self.position.x
        let totalDy = point.y - self.position.y
        
        let auxRotation = -atan2(totalDx, totalDy)
        var totalRotation:CGFloat = auxRotation - self.zRotation
        
        
        if(abs(self.physicsBody!.angularVelocity) < self.maxAngularVelocity) {
            
            while(totalRotation < -CGFloat(M_PI)) { totalRotation += CGFloat(M_PI * 2) }
            while(totalRotation >  CGFloat(M_PI)) { totalRotation -= CGFloat(M_PI * 2) }
            
            self.physicsBody?.applyAngularImpulse(totalRotation * 0.0001)
        }
        
        return totalRotation
    }
    
    func seekEnemyNode() {
        
        self.totalRotationToEnemyNode = self.rotateToPoint(self.enemyNode.position)
        
        //Sem verificação de velocidade linear
        if(abs(self.totalRotationToEnemyNode) < 1) {
            self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
        }
    }
    
    override func removeFromParent() {
        Enemy.enemySet.remove(self)
        super.removeFromParent()
    }
}
