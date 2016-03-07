//
//  Ufo.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Ufo: Control {
    
    static var ufoSet = Set<Ufo>()
    static var noUfosOnScreen = true
    
    var force:CGFloat = 100
    var onScreen = false
    var enemyNode:SKNode
    var movingType = 0
    var lastMovingChange:Double = 0
    var movingChangeInterval:Double = 0
    var destination = CGPoint.zero
    var needToMove = false
    
    init(enemyNode:SKNode) {
        self.enemyNode = enemyNode
        super.init()
        
        var distance = CGPoint.distance(self.position, enemyNode.position)
        
        while(distance < 100) {
            self.position = CGPoint(
                x: Int.random(min: enemyNode.position.x - 100000, max: enemyNode.position.x + 100000),
                y: Int.random(min: enemyNode.position.y - 100000, max: enemyNode.position.y + 100000))
            
            distance = CGPoint.distance(self.position, enemyNode.position)
        }
        
        var textureName:String!
        
        switch Int.random(4) {
        case 0:
            textureName = "ufoBlue"
            break
        case 1:
            textureName = "ufoGreen"
            break
        case 2:
            textureName = "ufoRed"
            break
        case 3:
            textureName = "ufoYellow"
            break
        default:
            break
        }
        
        let spriteNode = SKSpriteNode(imageNamed: textureName)
        spriteNode.texture?.filteringMode = .Linear
        spriteNode.size = CGSize(width: 32, height: 32)
        
        self.addChild(spriteNode)
        
        self.zPosition = -2
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = World.categoryBitMask.ufo.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.ufo
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.ufo
        
        self.physicsBody?.linearDamping = 1
        self.physicsBody?.angularDamping = 1
        
        Ufo.ufoSet.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        Ufo.noUfosOnScreen = true
        
        for ufo in Ufo.ufoSet {
            
            ufo.onScreen = ufo.isOnScree()
            ufo.hidden = !ufo.onScreen
            
            if ufo.onScreen {
                Ufo.noUfosOnScreen = false
            }
        }
        
        for ufo in Ufo.ufoSet {
            ufo.update(currentTime)
        }
    }
    
    
    func update(currentTime: NSTimeInterval) {
        self.randomMove(currentTime)
    }
    
    func randomMove(currentTime: NSTimeInterval) {
        if (self.onScreen) {
            
            if (currentTime - self.lastMovingChange > self.movingChangeInterval) {
                self.lastMovingChange = currentTime
                self.movingChangeInterval = Double.random(min: 0.5, max: 2.5)
                self.movingType = Int.random(min: 1, max: 5)
                
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
            
            if (self.needToMove) {
                if CGPoint.distance(self.position, self.destination) < 64 {
                    self.needToMove = false
                } else {
                    
                    let totalDx = self.destination.x - self.position.x
                    let totalDy = self.destination.y - self.position.y
                    
                    let auxRotation = -atan2(totalDx, totalDy)
                    
                    if CGPoint.distance(CGPoint.zero, CGPoint(x: self.physicsBody!.velocity.dx, y: self.physicsBody!.velocity.dy)) < 100 {
                        self.physicsBody?.applyForce(CGVector(dx: -sin(auxRotation) * self.force, dy: cos(auxRotation) * self.force))
                    }
                }
            }
            
            
        } else {
            if Ufo.noUfosOnScreen {
                self.seekEnemyNode()
                self.movingType = 2
            }
        }
    }
    
    func seekEnemyNode() {
        let totalDx = self.enemyNode.position.x - self.position.x
        let totalDy = self.enemyNode.position.y - self.position.y
        
        let auxRotation = -atan2(totalDx, totalDy)
        
        //Sem verificação de velocidade linear
        self.physicsBody?.applyForce(CGVector(dx: -sin(auxRotation) * self.force, dy: cos(auxRotation) * self.force))
    }
    
    override func removeFromParent() {
        Ufo.ufoSet.remove(self)
        super.removeFromParent()
    }
}
