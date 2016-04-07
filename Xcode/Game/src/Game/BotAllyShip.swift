//
//  BotAllyShip.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 4/7/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class BotAllyShip: AllyShip {
    
    var lastMovingChange:Double = 0
    var movingChangeInterval:Double = 0
    var movingType = 0
    var destination = CGPoint.zero
    var needToMove = false
    
    override init() {
        super.init()
        
        self.screenPosition = CGPoint(x: Int.random(Int(((1920/2) + 1334)/2)), y: Int.random(Int(((1080/2) + 750)/2)))
        self.resetPosition()
        
        self.physicsBody?.categoryBitMask = World.categoryBitMask.botAllyShip.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.botAllyShip
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.botAllyShip
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if self.healthPoints > 0 {
            
            if isOnScree() {
                self.lastOnScreen = currentTime
            }
            
            if currentTime - self.lastOnScreen > 1 {
                self.screenPosition = CGPoint(x: ((1920/2) + 1334)/4, y: ((1080/2) + 750)/4)
                self.resetPosition()
                self.physicsBody?.velocity = CGVector.zero
            }
            
            if (currentTime - self.lastMovingChange > self.movingChangeInterval) {
                self.lastMovingChange = currentTime
                self.movingChangeInterval = Double.random(min: 0.5, max: 2.5)
                self.movingType = 1
            }
            
            switch (self.movingType) {
                
            case 0:
                break
              
                //I want to go to the center of the screen
            case 1:
                self.destination = self.getPositionWithScreenPosition(CGPoint(x: ((1920/2) + 1334)/4, y: ((1080/2) + 750)/4))
                self.needToMove = true
                break
                
            default:
                break
            }
            
            if (self.needToMove) {
                if CGPoint.distance(self.position, self.destination) < 64 {
                    self.needToMove = false
                } else {
                    let dx = Float(self.destination.x - self.position.x)
                    let dy = Float(self.destination.y - self.position.y)
                    let auxRotation = CGFloat(-atan2f(dx, dy))
                    var totalRotation = auxRotation - self.zRotation
                    
                    
                    if(abs(self.physicsBody!.angularVelocity) < self.maxAngularVelocity) {
                        
                        while(totalRotation < -CGFloat(M_PI)) { totalRotation += CGFloat(M_PI * 2) }
                        while(totalRotation >  CGFloat(M_PI)) { totalRotation -= CGFloat(M_PI * 2) }
                        
                        self.physicsBody?.applyAngularImpulse(totalRotation * 0.0001)
                    }
                    
                    if(abs(totalRotation) < 1) {
                        self.physicsBody?.applyForce(CGVector(dx: -sin(self.zRotation) * self.force, dy: cos(self.zRotation) * self.force))
                    }
                }
            }
        }
    }
}
