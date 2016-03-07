//
//  Laser.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Laser: Control {
    
    static var laserSet = Set<Laser>()
    
    init(position: CGPoint, zRotation: CGFloat, shooter:SKPhysicsBody) {
        super.init()
        
        let spriteNode = SKSpriteNode(imageNamed: "laserBlue02")
        spriteNode.texture?.filteringMode = .Linear
        
        self.addChild(spriteNode)
        
        self.zPosition = -2
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = World.categoryBitMask.laser.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.laser
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.laser
        
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        
        self.position = position
        self.zRotation = zRotation
        self.physicsBody?.velocity = CGVector(dx: (-sin(zRotation) * 1000) + shooter.velocity.dx, dy: (cos(zRotation) * 1000) + shooter.velocity.dy)
        
        self.runAction({ let a = SKAction(); a.duration = 3; return a }()) { () -> Void in
            self.removeFromParent()
        }
        
        Laser.laserSet.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        switch physicsBody.categoryBitMask {
            
        case World.categoryBitMask.ufo.rawValue:
            if let ufo = physicsBody.node as? Ufo {
                ufo.removeFromParent()
                self.removeFromParent()
            }
            break
            
        case World.categoryBitMask.enemy.rawValue:
            if let enemy = physicsBody.node as? Enemy {
                enemy.removeFromParent()
                self.removeFromParent()
            }
            break
            
        default:
            break
        }
    }
    
    func update(currentTime: NSTimeInterval) {
        
    }
    
    override func removeFromParent() {
        Laser.laserSet.remove(self)
        super.removeFromParent()
    }
}
