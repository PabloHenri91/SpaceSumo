//
//  AllyShip.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 4/3/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class AllyShip: Control {
    static var allyShipSet = Set<AllyShip>()
    
    var healthPoints = 10
    
    var maxAngularVelocity:CGFloat = 3
    
    var lastLaser:NSTimeInterval = 0
    var lastOnScreen:NSTimeInterval = 0
    
    var force:CGFloat = 25
    
    var labelName:Label?
    var labelScore:Label?
    
    var lastShooterName: String?
    
    override init() {
        super.init()
        
        var textureName:String!
        let i = Int.random(min: 1, max: 3).description
        
//        switch Int.random(4) {
//        case 0:
//            textureName = "playerShip\(i)_blue"
//            break
//        case 1:
//            textureName = "playerShip\(i)_green"
//            break
//        case 2:
//            textureName = "playerShip\(i)_orange"
//            break
//        case 3:
            textureName = "playerShip\(i)_red"
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
        
        self.screenPosition = CGPoint(x: 0, y: 0)
        self.yAlign = .center
        self.xAlign = .center
        
        self.resetPosition()
        
        self.zPosition = 1
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: spriteNode.size)
        self.physicsBody?.categoryBitMask = World.categoryBitMask.allyShip.rawValue
        self.physicsBody?.collisionBitMask = World.collisionBitMask.allyShip
        self.physicsBody?.contactTestBitMask = World.contactTestBitMask.allyShip
        
        self.physicsBody?.linearDamping = 2
        self.physicsBody?.angularDamping = 2
        self.physicsBody?.restitution = 0.5
        
        AllyShip.allyShipSet.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didBeginContact(physicsBody:SKPhysicsBody, contact: SKPhysicsContact) {
        
        switch physicsBody.categoryBitMask {
            
        case World.categoryBitMask.allyShip.rawValue:
            print("didBeginContact: allyShip -> allyShip")
            break
            
        case World.categoryBitMask.myLaser.rawValue:
            print("didBeginContact: allyShip -> myLaser")
            break
            
        case World.categoryBitMask.laser.rawValue:
            self.lastShooterName = (physicsBody.node as? Laser)?.shooterName
            physicsBody.node?.removeFromParent()
            break
            
        case World.categoryBitMask.ufo.rawValue:
            print("didBeginContact: allyShip -> ufo")
            break
            
        case World.categoryBitMask.enemy.rawValue:
            print("didBeginContact: allyShip -> enemy")
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
    
    func setNameLabel() {
        if let name = self.name {
            if let parent = self.parent {
                self.labelName = Label(color: GameColors.white, text: name, fontSize: GameFonts.fontSize.large)
                parent.addChild(self.labelName!)
                
                self.labelScore = Label(color: GameColors.white, text: "0", fontSize: GameFonts.fontSize.large)
                parent.addChild(self.labelScore!)
            }
        }
    }
    
    class func update(currentTime: NSTimeInterval) {
        for allyShip in AllyShip.allyShipSet {
            allyShip.update(currentTime)
        }
    }
    
    func update(currentTime: NSTimeInterval) {
        
        self.labelName?.position = CGPoint(x: self.position.x, y: self.position.y + 64)
        self.labelScore?.position = CGPoint(x: self.position.x, y: self.position.y + -64)
        
        if self.healthPoints > 0 {
            
            //Laser
            if currentTime - self.lastLaser > 0.1 {
                let laser = Laser(position: self.position, zRotation: self.zRotation, shooter: self.physicsBody!, shooterName: self.name!)
                self.parent?.addChild(laser)
                self.lastLaser = currentTime
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
    
    override func removeFromParent() {
        self.labelName?.removeFromParent()
        self.labelScore?.removeFromParent()
        AllyShip.allyShipSet.remove(self)
        super.removeFromParent()
    }
}
