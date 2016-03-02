//
//  TextField.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/1/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class TextField: Control, UITextFieldDelegate {
    
    static var textFieldList = Set<TextField>()
    
    var textField:UITextField!
    
    var text = ""
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(x:Int = 0, y:Int = 0, z:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up, view:UIView) {
        super.init()
        let spriteNode = SKSpriteNode(imageNamed: "boxWhite128x32")
        spriteNode.texture?.filteringMode = .Nearest

        
        self.screenPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        
        
        
        self.zPosition = (z == 0 ? Config.HUDZPosition : CGFloat(z))
        
        spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
        self.addChild(spriteNode)
        
        self.textField = UITextField(frame: CGRect(x: 0, y: 0 , width: 150, height: 50))
        self.textField.backgroundColor = SKColor.clearColor()
        self.textField.textAlignment = .Center
        self.textField.delegate = self
        view.addSubview(self.textField)
        
        self.resetPosition()
        
        TextField.textFieldList.insert(self)
    }
    
    static func resetTextFields() {
        for textField in TextField.textFieldList {
            textField.resetPosition()
        }
    }
    
    override func resetPosition() {
        super.resetPosition()
        
        let size = self.calculateAccumulatedFrame()
        
        let scale = Config.scale
        
        let x = self.position.x * scale
        let y = self.position.y * scale
        
        self.textField.frame = CGRect(x: x, y: -y, width: size.width * scale, height: size.height * scale)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.scene?.view?.endEditing(true)
        if let text = self.textField.text {
            self.text = text
        }
        return true
    }
    
    override func removeFromParent() {
        TextField.textFieldList.remove(self)
        super.removeFromParent()
        self.textField.removeFromSuperview()
    }
}
