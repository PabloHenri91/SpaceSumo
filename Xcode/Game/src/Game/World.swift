//
//  World.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class World: Control, SKPhysicsContactDelegate {
    
    var physicsWorld:SKPhysicsWorld!
    var defaultGravity = CGVector(dx: 0, dy: 0)
    
    var bodyA: SKPhysicsBody!
    var bodyB: SKPhysicsBody!
    
    init(physicsWorld:SKPhysicsWorld) {
        super.init(textureName: "missionBackground", z:10000, xAlign: .center, yAlign: .center)
        
        self.physicsWorld = physicsWorld
        physicsWorld.gravity = self.defaultGravity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            self.bodyA = contact.bodyA
            self.bodyB = contact.bodyB
        } else {
            self.bodyA = contact.bodyB
            self.bodyB = contact.bodyA
        }

        
        //Somente para debug
        var bodyAcategoryBitMask = ""
        var bodyBcategoryBitMask = ""
        
        switch (self.bodyA.categoryBitMask) {
        case World.categoryBitMask.playerShip.rawValue:
            bodyAcategoryBitMask = "playerShip"
            break
        case World.categoryBitMask.myLaser.rawValue:
            bodyAcategoryBitMask = "myLaser"
            break
        case World.categoryBitMask.laser.rawValue:
            bodyAcategoryBitMask = "laser"
            break
        case World.categoryBitMask.ufo.rawValue:
            bodyAcategoryBitMask = "ufo"
            break
        case World.categoryBitMask.enemy.rawValue:
            bodyAcategoryBitMask = "enemy"
            break
        case World.categoryBitMask.allyShip.rawValue:
            bodyAcategoryBitMask = "allyShip"
            break
        case World.categoryBitMask.botAllyShip.rawValue:
            bodyAcategoryBitMask = "botAllyShip"
            break
        default:
            bodyAcategoryBitMask = "unknown"
            break
        }
        
        switch (self.bodyB.categoryBitMask) {
        case World.categoryBitMask.playerShip.rawValue:
            bodyBcategoryBitMask = "playerShip"
            break
        case World.categoryBitMask.myLaser.rawValue:
            bodyBcategoryBitMask = "myLaser"
            break
        case World.categoryBitMask.laser.rawValue:
            bodyBcategoryBitMask = "laser"
            break
        case World.categoryBitMask.ufo.rawValue:
            bodyBcategoryBitMask = "ufo"
            break
        case World.categoryBitMask.enemy.rawValue:
            bodyBcategoryBitMask = "enemy"
            break
        case World.categoryBitMask.allyShip.rawValue:
            bodyBcategoryBitMask = "allyShip"
            break
        case World.categoryBitMask.botAllyShip.rawValue:
            bodyBcategoryBitMask = "botAllyShip"
            break
        default:
            bodyBcategoryBitMask = "unknown"
            break
        }
        //
        
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
        case World.categoryBitMask.playerShip.rawValue + World.categoryBitMask.laser.rawValue:
            (self.bodyA.node as? PlayerShip)?.didBeginContact(self.bodyB, contact: contact)
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.botAllyShip.rawValue:
            (self.bodyB.node as? BotAllyShip)?.didBeginContact(self.bodyA, contact: contact)
            break
            
        case World.categoryBitMask.playerShip.rawValue + World.categoryBitMask.myLaser.rawValue:
            //laser foi criado dentro de playerShip precisa fazer nada ainda.
            break
            
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.enemy.rawValue:
            //laser foi criado dentro de enemy precisa fazer nada ainda.
            break
            
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.ufo.rawValue:
            //laser foi criado dentro de ufo precisa fazer nada ainda.
            break
            
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.allyShip.rawValue:
            //laser foi criado dentro de allyShip precisa fazer nada ainda.
            break
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.botAllyShip.rawValue:
            //laser foi criado dentro de botAllyShip precisa fazer nada ainda.
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.enemy.rawValue:
            (self.bodyB.node as? Enemy)?.didBeginContact(self.bodyA, contact: contact)
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.ufo.rawValue:
            (self.bodyB.node as? Ufo)?.didBeginContact(self.bodyA, contact: contact)
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.allyShip.rawValue:
            //nao precisa fazer nada aqui porque nao temos dano
            break
            
        default:
            print("didBeginContact: " + bodyAcategoryBitMask + " -> " + bodyBcategoryBitMask)
            break
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            self.bodyA = contact.bodyA
            self.bodyB = contact.bodyB
        } else {
            self.bodyA = contact.bodyB
            self.bodyB = contact.bodyA
        }
        
        //Somente para debug
        var bodyAcategoryBitMask = ""
        var bodyBcategoryBitMask = ""
        
        switch (self.bodyA.categoryBitMask) {
        case World.categoryBitMask.playerShip.rawValue:
            bodyAcategoryBitMask = "playerShip"
            break
        case World.categoryBitMask.myLaser.rawValue:
            bodyAcategoryBitMask = "myLaser"
            break
        case World.categoryBitMask.laser.rawValue:
            bodyAcategoryBitMask = "laser"
            break
        case World.categoryBitMask.ufo.rawValue:
            bodyAcategoryBitMask = "ufo"
            break
        case World.categoryBitMask.enemy.rawValue:
            bodyAcategoryBitMask = "enemy"
            break
        case World.categoryBitMask.allyShip.rawValue:
            bodyAcategoryBitMask = "allyShip"
            break
        case World.categoryBitMask.botAllyShip.rawValue:
            bodyAcategoryBitMask = "botAllyShip"
            break
        default:
            bodyAcategoryBitMask = "unknown"
            break
        }
        
        switch (self.bodyB.categoryBitMask) {
        case World.categoryBitMask.playerShip.rawValue:
            bodyBcategoryBitMask = "playerShip"
            break
        case World.categoryBitMask.myLaser.rawValue:
            bodyBcategoryBitMask = "myLaser"
            break
        case World.categoryBitMask.laser.rawValue:
            bodyBcategoryBitMask = "laser"
            break
        case World.categoryBitMask.ufo.rawValue:
            bodyBcategoryBitMask = "ufo"
            break
        case World.categoryBitMask.enemy.rawValue:
            bodyBcategoryBitMask = "enemy"
            break
        case World.categoryBitMask.allyShip.rawValue:
            bodyBcategoryBitMask = "allyShip"
            break
        case World.categoryBitMask.botAllyShip.rawValue:
            bodyBcategoryBitMask = "botAllyShip"
            break
        default:
            bodyBcategoryBitMask = "unknown"
            break
        }
        //
        
        //lower category is always stored in bodyA
        switch (self.bodyA.categoryBitMask + self.bodyB.categoryBitMask) {
            
            //self.bodyA + self.bodyB
        case World.categoryBitMask.playerShip.rawValue + World.categoryBitMask.myLaser.rawValue:
            (self.bodyA.node as? PlayerShip)?.didEndContact(self.bodyB, contact: contact)
            break
            
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.ufo.rawValue:
            (self.bodyB.node as? Ufo)?.didEndContact(self.bodyA, contact: contact)
            break
            
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.enemy.rawValue:
            (self.bodyB.node as? Enemy)?.didEndContact(self.bodyA, contact: contact)
            break
            
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.allyShip.rawValue:
            (self.bodyB.node as! AllyShip).didEndContact(self.bodyA, contact: contact)
            break
        case World.categoryBitMask.myLaser.rawValue + World.categoryBitMask.botAllyShip.rawValue:
            (self.bodyB.node as! BotAllyShip).didEndContact(self.bodyA, contact: contact)
            break
            
        case World.categoryBitMask.playerShip.rawValue + World.categoryBitMask.laser.rawValue:
            //laser ricocheteou no playerShip
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.enemy.rawValue:
            //laser ricocheteou no enemy
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.ufo.rawValue:
            //laser ricocheteou no ufo
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.botAllyShip.rawValue:
            //laser ricocheteou no botAllyShip
            break
            
        case World.categoryBitMask.laser.rawValue + World.categoryBitMask.allyShip.rawValue:
            //laser ricocheteou no allyShip
            break
            
        default:
            print("didEndContact: " + bodyAcategoryBitMask + " -> " + bodyBcategoryBitMask)
            break
        }
    }
    
    struct categoryBitMask : OptionSetType {
        typealias RawValue = UInt32
        private var value: UInt32 = 0
        init(_ value: UInt32) { self.value = value }
        init(rawValue value: UInt32) { self.value = value }
        init(nilLiteral: ()) { self.value = 0 }
        static var allZeros: categoryBitMask { return self.init(0) }
        static func fromMask(raw: UInt32) -> categoryBitMask { return self.init(raw) }
        var rawValue: UInt32 { return self.value }
        
        static var none: categoryBitMask { return self.init(0) }
        
        static var playerShip: categoryBitMask { return categoryBitMask(1 << 0) }
        static var myLaser: categoryBitMask { return categoryBitMask(1 << 1) }
        static var laser: categoryBitMask { return categoryBitMask(1 << 2) }
        static var ufo: categoryBitMask { return categoryBitMask(1 << 3) }
        static var enemy: categoryBitMask { return categoryBitMask(1 << 4) }
        static var allyShip: categoryBitMask { return categoryBitMask(1 << 5) }
        static var botAllyShip: categoryBitMask { return categoryBitMask(1 << 6) }
    }
    
    struct collisionBitMask {
        
        static var none: UInt32 = 0
        
        static var playerShip: UInt32 =
            categoryBitMask.playerShip.rawValue |
                categoryBitMask.botAllyShip.rawValue |
                categoryBitMask.allyShip.rawValue |
                categoryBitMask.laser.rawValue |
                categoryBitMask.ufo.rawValue |
                categoryBitMask.enemy.rawValue
        
        static var myLaser: UInt32 = 0
        
        static var laser: UInt32 =
            categoryBitMask.playerShip.rawValue |
                categoryBitMask.botAllyShip.rawValue |
                categoryBitMask.allyShip.rawValue |
                categoryBitMask.ufo.rawValue |
                categoryBitMask.enemy.rawValue
        
        static var ufo: UInt32 =
            categoryBitMask.playerShip.rawValue |
                categoryBitMask.botAllyShip.rawValue |
                categoryBitMask.allyShip.rawValue |
                categoryBitMask.laser.rawValue |
                categoryBitMask.ufo.rawValue |
                categoryBitMask.enemy.rawValue
        
        static var enemy: UInt32 =
            categoryBitMask.playerShip.rawValue |
                categoryBitMask.botAllyShip.rawValue |
                categoryBitMask.allyShip.rawValue |
                categoryBitMask.laser.rawValue |
                categoryBitMask.ufo.rawValue |
                categoryBitMask.enemy.rawValue
        
        static var allyShip: UInt32 = 0
        
        static var botAllyShip: UInt32 =
            categoryBitMask.playerShip.rawValue |
                categoryBitMask.botAllyShip.rawValue |
                categoryBitMask.allyShip.rawValue |
                categoryBitMask.laser.rawValue |
                categoryBitMask.ufo.rawValue |
                categoryBitMask.enemy.rawValue
    }
    
    struct contactTestBitMask {
        
        static var playerShip: UInt32 =
        categoryBitMask.myLaser.rawValue |
            categoryBitMask.laser.rawValue
        
        static var myLaser: UInt32 =
        categoryBitMask.playerShip.rawValue |
            categoryBitMask.allyShip.rawValue |
            categoryBitMask.ufo.rawValue |
            categoryBitMask.enemy.rawValue
        
        static var laser: UInt32 =
        categoryBitMask.playerShip.rawValue |
            categoryBitMask.allyShip.rawValue |
            categoryBitMask.ufo.rawValue |
            categoryBitMask.enemy.rawValue
        
        static var ufo: UInt32 =
        categoryBitMask.myLaser.rawValue |
            categoryBitMask.laser.rawValue
        
        static var enemy: UInt32 =
        categoryBitMask.myLaser.rawValue |
            categoryBitMask.laser.rawValue
        
        static var allyShip: UInt32 =
            categoryBitMask.myLaser.rawValue |
                categoryBitMask.laser.rawValue
        
        static var botAllyShip: UInt32 =
            categoryBitMask.myLaser.rawValue |
                categoryBitMask.laser.rawValue
        
    }
}
