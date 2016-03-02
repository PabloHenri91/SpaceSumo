//
//  Trainer.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/1/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Trainer: Control {
    
    var age:Int!
    var photo:String!
    var town:String!

    init(name:String, age:Int, photo:String, town:String, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init(textureName: "boxWhite128x64", x:x, y:y, xAlign:xAlign, yAlign:yAlign)
        
        let label = Label(text: name, x:42, y:10)
        self.addChild(label)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            if let imageData = NSData(contentsOfURL:
                NSURL(string: photo)!) {
                    if let image = UIImage(data: imageData) {
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            let texture = SKTexture(image: image)
                            let spriteNode = SKSpriteNode(texture: texture)
                            let icon = Control(spriteNode: spriteNode, x:16, y:16, size:CGSize(width: 32, height: 32))
                            self.addChild(icon)
                        }
                    }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
