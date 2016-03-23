//
//  Parallax.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Parallax: SKNode {
    
    static var parallaxSet = Set<Parallax>()
    
    var spriteNodesBack = [SKSpriteNode]()
    var spriteNodesFront = [SKSpriteNode]()
    
    let textureStarsBack:SKTexture
    let textureStarsFront:SKTexture
    
    override init() {
        
        self.textureStarsBack = SKTexture(imageNamed: "stars")
        self.textureStarsBack.filteringMode = .Nearest
        self.textureStarsFront = SKTexture(imageNamed: "starsFront")
        self.textureStarsFront.filteringMode = .Nearest
        
        super.init()
        
        self.reset()
        
        Parallax.parallaxSet.insert(self)
    }
    
    static func resetParallaxes() {
        for parallax in Parallax.parallaxSet {
            parallax.reset()
        }
    }
    
    func reset() {
        
        self.spriteNodesBack = [SKSpriteNode]()
        self.spriteNodesFront = [SKSpriteNode]()
        
        self.removeAllChildren()
        
        self.zPosition = -Config.HUDZPosition
        
        for _ in -1 ... Int(Config.currentSceneSize.width/textureStarsBack.size().width) + 1 {
            for _ in -1 ... Int(Config.currentSceneSize.height/textureStarsBack.size().height + 1) {
                let spriteNode = SKSpriteNode(texture: textureStarsBack)
                spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                spriteNode.zPosition = self.zPosition + CGFloat(1)
                self.spriteNodesBack.append(spriteNode)
                self.addChild(spriteNode)
            }
        }
        
        for _ in -1 ... Int(Config.currentSceneSize.width/textureStarsFront.size().width) + 1 {
            for _ in -1 ... Int(Config.currentSceneSize.height/textureStarsFront.size().height + 1) {
                let spriteNode = SKSpriteNode(texture: textureStarsFront)
                spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                spriteNode.zPosition = self.zPosition + CGFloat(2)
                self.spriteNodesFront.append(spriteNode)
                self.addChild(spriteNode)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(position:CGPoint) {
        
        var i = self.spriteNodesBack.generate()
        for x in -1 ... Int(Config.currentSceneSize.width/textureStarsBack.size().width) + 1 {
            for y in -1 ... Int(Config.currentSceneSize.height/textureStarsBack.size().height) + 1 {
                
                if let spriteNode = i.next() {
                    spriteNode.position = CGPoint(
                        x: (-position.x/2 % spriteNode.size.width) + (spriteNode.size.width * CGFloat(x)),
                        y: (-position.y/2 % spriteNode.size.height) - (spriteNode.size.height * CGFloat(y)))
                }
            }
        }
        
        i = self.spriteNodesFront.generate()
        for x in -1 ... Int(Config.currentSceneSize.width/textureStarsBack.size().width) + 1 {
            for y in -1 ... Int(Config.currentSceneSize.height/textureStarsBack.size().height) + 1 {
                
                if let spriteNode = i.next() {
                    spriteNode.position = CGPoint(
                        x: (-position.x % spriteNode.size.width) + (spriteNode.size.width * CGFloat(x)),
                        y: (-position.y % spriteNode.size.height) - (spriteNode.size.height * CGFloat(y)))
                }
            }
        }
    }
    
    override func removeFromParent() {
        Parallax.parallaxSet.remove(self)
        super.removeFromParent()
    }
}
