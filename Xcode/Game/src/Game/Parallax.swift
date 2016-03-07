//
//  Parallax.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Parallax: SKNode {
    
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
        
        self.zPosition = -Config.HUDZPosition
        
        for var x = -1; x <= Int(Config.currentSceneSize.width/textureStarsBack.size().width) + 1; x++ {
            for var y = -1; y <= Int(Config.currentSceneSize.height/textureStarsBack.size().height + 1); y++ {
                let spriteNode = SKSpriteNode(texture: textureStarsBack)
                spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                spriteNode.zPosition = self.zPosition + CGFloat(1)
                self.spriteNodesBack.append(spriteNode)
                self.addChild(spriteNode)
            }
        }
        
        for var x = -1; x <= Int(Config.currentSceneSize.width/textureStarsFront.size().width) + 1; x++ {
            for var y = -1; y <= Int(Config.currentSceneSize.height/textureStarsFront.size().height + 1); y++ {
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
        
        var i = 0
        for var x = -1; x <= Int(Config.currentSceneSize.width/textureStarsBack.size().width) + 1; x++ {
            for var y = -1; y <= Int(Config.currentSceneSize.height/textureStarsBack.size().height) + 1; y++ {
                let spriteNode = self.spriteNodesBack[i]
                
                spriteNode.position = CGPoint(
                    x: (-position.x/2 % spriteNode.size.width) + (spriteNode.size.width * CGFloat(x)),
                    y: (-position.y/2 % spriteNode.size.height) - (spriteNode.size.height * CGFloat(y)))
                
                i++
            }
        }
        
        i = 0
        for var x = -1; x <= Int(Config.currentSceneSize.width/textureStarsFront.size().width) + 1; x++ {
            for var y = -1; y <= Int(Config.currentSceneSize.height/textureStarsFront.size().height) + 1; y++ {
                let spriteNode = self.spriteNodesFront[i]
                
                spriteNode.position = CGPoint(
                    x: (-position.x % spriteNode.size.width) + (spriteNode.size.width * CGFloat(x)),
                    y: (-position.y % spriteNode.size.height) - (spriteNode.size.height * CGFloat(y)))
                
                i++
            }
        }
    }
}
