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
            x: x == -1 ? Config.sceneSize.width - texture.size().width : CGFloat(x),
            y: y == -1 ? Config.sceneSize.height  - texture.size().height : CGFloat(y))
        
        let spriteNode = SKSpriteNode(texture: texture)
        spriteNode.texture?.filteringMode = .Nearest
        
        super.init(spriteNode: spriteNode, x: Int(position.x), y: Int(position.y), xAlign: xAlign, yAlign: yAlign)
        
        self.zPosition = Config.HUDZPosition * 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
