//
//  Label.swift
//  TowerUp
//
//  Created by Pablo Henrique Bertaco on 8/5/15.
//  Copyright (c) 2015 WTFGames. All rights reserved.
//

import SpriteKit

class Label: Control {
    
    var labelNode:SKLabelNode!
    
    init(color:SKColor = GameColors.black, text:String, fontSize:GameFonts.fontSize = .medium, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up , verticalAlignmentMode:SKLabelVerticalAlignmentMode = .Center, horizontalAlignmentMode:SKLabelHorizontalAlignmentMode = .Center ) {
        super.init()
        self.load(color, text:text, fontSize:fontSize.rawValue, x:x, y:y, xAlign:xAlign, yAlign:yAlign, verticalAlignmentMode:verticalAlignmentMode, horizontalAlignmentMode:horizontalAlignmentMode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(color:SKColor, text:String, fontSize:CGFloat, x:Int, y:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments, verticalAlignmentMode:SKLabelVerticalAlignmentMode, horizontalAlignmentMode:SKLabelHorizontalAlignmentMode) {
        self.screenPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        self.zPosition = Config.HUDZPosition/2
        
        self.resetPosition()
        
        self.labelNode = SKLabelNode(fontNamed: GameFonts.fontName)
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.fontSize = fontSize
        self.labelNode.fontColor = color
        self.labelNode.verticalAlignmentMode = verticalAlignmentMode
        self.labelNode.horizontalAlignmentMode = horizontalAlignmentMode
        
        self.addChild(self.labelNode)
        
        Control.controlList.insert(self)
    }
    
    func getText() -> String{
        if let text = self.labelNode.text {
            return text
        } else {
           return ""
        }
    }
    
    func setText(text:String) {
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.zPosition = Config.HUDZPosition/2
    }
    
    func setText(text:String, color:SKColor) {
        self.labelNode.fontColor = color
        self.labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
        self.labelNode.zPosition = Config.HUDZPosition/2
    }
}
