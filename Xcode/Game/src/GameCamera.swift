//
//  GameCamera.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/22/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class GameCamera: SKNode {
    
    let arenaSizeWidth:CGFloat = (1920.0 + 1334)/2
    let arenaSizeHeight:CGFloat = (1080.0 + 750)/2
    
    func update(newPosition:CGPoint) {
        
        self.position = CGPoint(x: newPosition.x - self.scene!.size.width/2, y: newPosition.y + self.scene!.size.height/2)
        
        if(self.position.x <= 0) {
            position.x = 0
        }
        
        if self.position.x >= (arenaSizeWidth - self.scene!.size.width) {
            position.x = (arenaSizeWidth - self.scene!.size.width)
        }
        
        if self.position.y >= 0 {
            position.y = 0
        }
        
        if self.position.y <= -(arenaSizeHeight - self.scene!.size.height) {
            position.y = -(arenaSizeHeight - self.scene!.size.height)
        }
        
        self.scene!.centerOnNode(self)
    }
}

public extension SKScene {
    
    func centerOnNode(node:SKNode)
    {
        if let parent = node.parent {
            let cameraPositionInScene:CGPoint = node.scene!.convertPoint(node.position, fromNode: parent)
            parent.position = CGPoint(
                x: CGFloat(parent.position.x - cameraPositionInScene.x),
                y: CGFloat(parent.position.y - cameraPositionInScene.y))
        }
    }
}
