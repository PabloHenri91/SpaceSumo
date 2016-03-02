//
//  pokemonCell.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/1/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class PokemonCell: Control {
    
    static var types = [PokemonCellType]()
    
    var type:Int
    
    init(type:Int, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        
        self.type = type
        
        super.init(textureName: "boxWhite64x64", x:x, y:y, xAlign:xAlign, yAlign:yAlign)
        
        let label = Label(text: PokemonCell.types[type].name, x:32, y:10)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            if let imageData = NSData(contentsOfURL:
                NSURL(string: PokemonCell.types[type].icon)!) {
                if let image = UIImage(data: imageData) {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        let texture = SKTexture(image: image)
                        texture.filteringMode = .Nearest
                        let spriteNode = SKSpriteNode(texture: texture)
                        let icon = Control(spriteNode: spriteNode, x:16, y:16)
                        self.addChild(icon)
                    }
                }
            }
        }
        
        self.addChild(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PokemonCellType {
    
    var number:Int!
    var name:String!
    var icon:String!
    var image:String!
    var level:Int!
    var type1:String!
    var type2:String?
    
    init(number:Int, name:String, icon:String, image:String, level:Int, type1:String, type2:String?) {
        self.number = number
        self.name = name
        self.icon = icon
        self.image = image
        self.level = level
        self.type1 = type1
        self.type2 = type2
    }
}

class Status {
    
}

class Skill {
    
}



