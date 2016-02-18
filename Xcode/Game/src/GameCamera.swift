//
//  GameCamera.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/22/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class GameCamera: SKNode {
    
    func update(newPosition:CGPoint) {
        
        self.position = CGPoint(x: newPosition.x - self.scene!.size.width/2, y: newPosition.y + self.scene!.size.height/2)
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
