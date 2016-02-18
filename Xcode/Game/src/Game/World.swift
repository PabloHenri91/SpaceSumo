////
////  World.swift
////  SpaceGame
////
////  Created by Pablo Henrique Bertaco on 11/22/15.
////  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
////
//
//import SpriteKit
//
//class World: SKNode {
//    
//    var physicsWorld:SKPhysicsWorld!
//    var defaultGravity = CGVector(dx: 0, dy: 0)
//    
//    var bodyA: SKPhysicsBody!
//    var bodyB: SKPhysicsBody!
//    
//    init(physicsWorld:SKPhysicsWorld) {
//        super.init()
//        
//        self.physicsWorld = physicsWorld
//        physicsWorld.gravity = self.defaultGravity
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func didBeginContact(contact: SKPhysicsContact) {
//        //Assign the two physics bodies so that the one with the lower category is always stored in firstBody
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            self.bodyA = contact.bodyA
//            self.bodyB = contact.bodyB
//        } else {
//            self.bodyA = contact.bodyB
//            self.bodyB = contact.bodyA
//        }
//        
//        switch (self.bodyA.categoryBitMask) {
////        case World.categoryBitMask.???.rawValue:
////            (self.bodyA.node as? ???)?.didBeginContact(self.bodyB, contact: contact)
////            break
//        default:
//            break
//        }
//    }
//    
//    func didEndContact(contact: SKPhysicsContact) {
//        
//    }
//    
//    struct categoryBitMask : OptionSetType {
//        typealias RawValue = UInt32
//        private var value: UInt32 = 0
//        init(_ value: UInt32) { self.value = value }
//        init(rawValue value: UInt32) { self.value = value }
//        init(nilLiteral: ()) { self.value = 0 }
//        static var allZeros: categoryBitMask { return self.init(0) }
//        static func fromMask(raw: UInt32) -> categoryBitMask { return self.init(raw) }
//        var rawValue: UInt32 { return self.value }
//        
//        static var none: categoryBitMask { return self.init(0) }
//        
//        static var playerShip: categoryBitMask { return categoryBitMask(1 << 0) }
//        static var laser: categoryBitMask { return categoryBitMask(1 << 1) }
//        static var ufo: categoryBitMask { return categoryBitMask(1 << 2) }
//        static var enemy: categoryBitMask { return categoryBitMask(1 << 3) }
//        
//    }
//    
//    struct collisionBitMask {
//        
//        static var playerShip: UInt32 =
//        categoryBitMask.playerShip.rawValue |
//            categoryBitMask.ufo.rawValue |
//            categoryBitMask.enemy.rawValue //|
//            //categoryBitMask.laser.rawValue
//        
//        static var ufo: UInt32 =
//        categoryBitMask.playerShip.rawValue |
//            categoryBitMask.ufo.rawValue |
//            categoryBitMask.enemy.rawValue |
//            categoryBitMask.laser.rawValue
//        
//        static var enemy: UInt32 =
//        categoryBitMask.playerShip.rawValue |
//            categoryBitMask.ufo.rawValue |
//            categoryBitMask.enemy.rawValue |
//            categoryBitMask.laser.rawValue
//        
//        
//        static var laser: UInt32 =
//        //categoryBitMask.playerShip.rawValue |
//            categoryBitMask.ufo.rawValue |
//            categoryBitMask.enemy.rawValue |
//            categoryBitMask.laser.rawValue
//    }
//    
//    struct contactTestBitMask {
//        
//        static var playerShip: UInt32 = categoryBitMask.none.rawValue
//        
//        
//        static var ufo: UInt32 = categoryBitMask.laser.rawValue
//        
//        
//        static var enemy: UInt32 = categoryBitMask.laser.rawValue
//        
//        
//        static var laser: UInt32 =
//        categoryBitMask.ufo.rawValue |
//            categoryBitMask.enemy.rawValue
//    }
//}
