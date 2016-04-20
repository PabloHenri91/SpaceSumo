//
//  Box.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/1/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Box: Control {
    
    init(name:String = "", textureName:String, x:Int = -1, y:Int = -1, z:Int = 0, xAlign:Control.xAlignments = .center, yAlign:Control.yAlignments = .center) {
        
        let texture = SKTexture(imageNamed: textureName)
        texture.filteringMode = .Nearest
        
        let position = CGPoint(
            x: x == -1 ? Config.sceneSize.width/2 - texture.size().width/2 : CGFloat(x),
            y: y == -1 ? Config.sceneSize.height/2  - texture.size().height/2 : CGFloat(y))
        
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.texture?.filteringMode = .Nearest
        
        super.init(spriteNode: spriteNode, x: Int(position.x), y: Int(position.y), xAlign: xAlign, yAlign: yAlign)
        
        self.zPosition = Config.HUDZPosition * 2
        
        self.size = self.calculateAccumulatedFrame().size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
