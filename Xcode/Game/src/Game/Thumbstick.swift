//
//  Thumbstick.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 1/5/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Thumbstick: Control {
    
    //    var hidden: Bool {
    //        set {
    //            for node in self.children {
    //                node.hidden = newValue
    //            }
    //        }
    //
    //        get {
    //            return false
    //        }
    //    }
    
    var touch:UITouch?
    
    var circleBlack64x64 = SKSpriteNode(imageNamed: "circleBlack64x64")
    var circleWhite32x32 = SKSpriteNode(imageNamed: "circleWhite32x32")
    
    override init() {
        super.init()
        
        #if os(tvOS)
            self.screenPosition = CGPoint(x: 58, y: 317)
            self.yAlign = yAlign
            self.xAlign = xAlign
            
            self.resetPosition()
        #endif
        
        self.addChild(self.circleBlack64x64)
        self.circleBlack64x64.addChild(self.circleWhite32x32)
        
        self.hidden = true
        
        self.zPosition = Config.HUDZPosition
        self.circleBlack64x64.zPosition = self.zPosition + CGFloat(1)
        self.circleWhite32x32.zPosition = self.zPosition + CGFloat(2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(totalDx totalDx:CGFloat, totalDy:CGFloat) {
        
        let rotation = -atan2(totalDx, totalDy)
        
        var dx:CGFloat = 0
        var dy:CGFloat = 0
        
        if CGPoint.distance(CGPoint.zero, CGPoint(x: totalDx, y: totalDy)) < 32 {
            dx = totalDx
            dy = totalDy
        } else {
            dx = -sin(rotation) * 32
            dy = cos(rotation) * 32
        }
        
        self.circleWhite32x32.position = CGPoint(x: dx, y: dy)
    }
}
