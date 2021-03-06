//
//  Button.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 10/29/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Button: Control {
    
    static var buttonList = Set<Button>()
    
    var button:SKSpriteNode!
    var buttonPressed:SKSpriteNode!
    
    var pressed:Bool = false
    
    var event:Event<Void>?
    
    func addHandler(handler: Void -> ()) {
        if let _ = self.event { } else {
            self.event = Event()
        }
        self.event!.addHandler(handler)
    }
    
    enum labelColors {
        case black
        case white
    }
    
    private var labelColor = labelColors.black
    
    init(textureName:String, icon:String = "", text:String = "", fontSize:GameFonts.fontSize = .medium, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up, alpha:CGFloat = CGFloat(1), touchArea:CGSize = CGSize.zero,
        top:Int = 0, bottom:Int = 0, left:Int = 0, right:Int = 0, fontColor:labelColors = .black) {
            super.init()
            
            self.labelColor = fontColor
            
            self.screenPosition = CGPoint(x: x, y: y)
            self.yAlign = yAlign
            self.xAlign = xAlign
            self.zPosition = Config.HUDZPosition
            
            self.resetPosition()
            
            let texture = SKTexture(imageNamed: textureName)
            texture.filteringMode = .Nearest
            
            if (top != 0 || bottom != 0 || left != 0 || right != 0) {
                let spriteNode = SKSpriteNode(texture: nil, color: SKColor.clearColor(), size: CGSize(
                    width: Int(texture.size().width) + left + right,
                    height: Int(texture.size().height) + top + bottom))
                spriteNode.texture?.filteringMode = .Nearest
                
                spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
                self.addChild(spriteNode)
                spriteNode.position = CGPoint(x: -left, y: top)
            }
            
            self.button = SKSpriteNode(texture: texture, size: texture.size())
            self.button.texture?.filteringMode = .Nearest
            self.button.color = SKColor(red: 1, green: 1, blue: 1, alpha: alpha)
            self.button.colorBlendFactor = 1
            self.button.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(self.button)
            
            if (icon != "") {
                let iconTexture = SKTexture(imageNamed: icon)
                iconTexture.filteringMode = .Nearest
                
                let xScale = (self.button.size.width - 10) / iconTexture.size().width
                let yScale = (self.button.size.height - 10) / iconTexture.size().height
                let scale = min(xScale, yScale)
                
                let icon = SKSpriteNode(texture: iconTexture, size: CGSize(width: iconTexture.size().width * scale, height: iconTexture.size().height * scale))
                icon.texture?.filteringMode = .Nearest
                
                icon.color = SKColor(red: 0, green: 0, blue: 0, alpha: 0.75 * alpha)
                icon.colorBlendFactor = 1
                self.button.addChild(icon)
                icon.position = CGPoint(x: texture.size().width/2, y: -texture.size().height/2)
                icon.zPosition = self.button.zPosition + 1
            }
            
            if (text != "") {
                let labelNode = SKLabelNode(fontNamed: GameFonts.fontName)
                labelNode.text = NSLocalizedString(text, tableName: nil, comment:"")
                labelNode.fontSize = fontSize.rawValue
                
                switch self.labelColor {
                case .black:
                    labelNode.fontColor = GameColors.black
                    break
                case .white:
                    labelNode.fontColor = GameColors.white
                    break
                }
                
                labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
                labelNode.position = CGPoint(x: texture.size().width/2, y: -texture.size().height/2)
                self.button.addChild(labelNode)
                labelNode.zPosition = labelNode.zPosition + 1
            }
            
            let texturePressed = SKTexture(imageNamed: "\(textureName)Pressed")
            texturePressed.filteringMode = .Nearest
            self.buttonPressed = SKSpriteNode(texture: texturePressed, size: texturePressed.size())
            self.buttonPressed.texture?.filteringMode = .Nearest
            self.buttonPressed.color = SKColor(red: 1, green: 1, blue: 1, alpha: alpha)
            self.buttonPressed.colorBlendFactor = 1
            self.buttonPressed.anchorPoint = CGPoint(x: 0, y: 1)
            self.buttonPressed.hidden = true
            self.addChild(self.buttonPressed)
            
            if (icon != "") {
                let iconTexturePressed = SKTexture(imageNamed: icon)
                iconTexturePressed.filteringMode = .Nearest
                let xScale = (self.buttonPressed.size.width - 10) / iconTexturePressed.size().width
                let yScale = (self.buttonPressed.size.height - 10) / iconTexturePressed.size().height
                let scale = min(xScale, yScale)
                
                let iconPressed = SKSpriteNode(texture: iconTexturePressed, size: CGSize(width: iconTexturePressed.size().width * scale, height: iconTexturePressed.size().height * scale))
                iconPressed.texture?.filteringMode = .Nearest
                
                iconPressed.color = SKColor(red: 1, green: 1, blue: 1, alpha: 0.75 * alpha)
                iconPressed.colorBlendFactor = 1
                self.buttonPressed.addChild(iconPressed)
                iconPressed.position = CGPoint(x: texturePressed.size().width/2, y: -texturePressed.size().height/2 - 2)
                iconPressed.zPosition = self.buttonPressed.zPosition + 1
            }
            
            if (text != "") {
                let labelNodePressed = SKLabelNode(fontNamed: GameFonts.fontName)
                labelNodePressed.text = NSLocalizedString(text, tableName: nil, comment:"")
                labelNodePressed.fontSize = fontSize.rawValue
                
                switch self.labelColor {
                case .black:
                    labelNodePressed.fontColor = GameColors.white
                    break
                case .white:
                    labelNodePressed.fontColor = GameColors.black
                    break
                }
                
                labelNodePressed.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                labelNodePressed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
                //TODO: deslocamento vindo por parâmetro
                labelNodePressed.position = CGPoint(x: texturePressed.size().width/2, y: -texturePressed.size().height/2 - 2)
                self.buttonPressed.addChild(labelNodePressed)
                labelNodePressed.zPosition = labelNodePressed.zPosition + 1
            }
            
            Button.buttonList.insert(self)
            
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func resetButtons() {
        for button in Button.buttonList {
            button.resetPosition()
        }
    }
    
    #if os(iOS)
    class func update(taps: Set<UITouch>) {
        for button in Button.buttonList {
            if let event = button.event {
                for tap in taps {
                    if let parent = button.parent {
                        let location = tap.locationInNode(parent)
                        if button.containsPoint(location) {
                            event.raise()
                        }
                    }
                }
            }
            button.update()
        }
    }
    #endif
    
    #if os(OSX)
    class func update(touch: NSEvent) {
        for button in Button.buttonList {
            if let event = button.event {
                if let parent = button.parent {
                    let location = touch.locationInNode(parent)
                    if button.containsPoint(location) {
                        event.raise()
                    }
                }
            }
            button.update()
        }
    }
    #endif
    
    #if os(tvOS)
    
    class func raiseSelectedButtonEvent() {
        GameScene.selectedButton?.event?.raise()
    }
    
    class func update(touches: Set<UITouch>) {
        
        if let _ = GameScene.nextButton {
            GameScene.selectedButton?.buttonRelease()
            GameScene.nextButton?.buttonPress()
            GameScene.selectedButton = GameScene.nextButton
            GameScene.nextButton = nil
        }
    }
    #endif
    
    func update() {
        #if os(iOS) || os(OSX)
        var i = 0
        for touch in Control.touchesArray {
            if let parent = self.parent {
                let location = touch.0.locationInNode(parent)
                if self.containsPoint(location) {
                    i += 1
                }
            }
        }
        if(i > 0) {
            self.buttonPress()
        } else {
            self.buttonRelease()
        }
        #endif
    }
    
    class func update() {
        #if os(iOS) || os(OSX)
        for button in Button.buttonList {
            button.update()
        }
        #endif
        
        #if os(tvOS)
            
            if let selectedButton = GameScene.selectedButton {
                
                var distanceToNextButon = CGFloat.max
                
                if((Control.totalDx * Control.totalDx) + (Control.totalDy * Control.totalDy) > 10 * 10) { //10 px de tolerancia
                    
                    if(abs(Control.totalDx) > abs(Control.totalDy)) {
                        if(Control.totalDx > 0) {
                            for button in buttonList {
                                if button.hidden == false {
                                    let buttonPosition = button.positionInScene()
                                    let selectedButtonPosition = selectedButton.positionInScene()
                                    
                                    if(buttonPosition.x > selectedButtonPosition.x) {
                                        let distanceToSelectedButon = CGPoint.distance(buttonPosition, selectedButtonPosition)
                                        if(distanceToSelectedButon < distanceToNextButon) {
                                            GameScene.nextButton = button
                                            distanceToNextButon = distanceToSelectedButon
                                        }
                                    }
                                    button.buttonRelease()
                                }
                            }
                        } else {
                            for button in buttonList {
                                if button.hidden == false {
                                    let buttonPosition = button.positionInScene()
                                    let selectedButtonPosition = selectedButton.positionInScene()
                                    
                                    if(buttonPosition.x < selectedButtonPosition.x) {
                                        let distanceToSelectedButon = CGPoint.distance(buttonPosition, selectedButtonPosition)
                                        if(distanceToSelectedButon < distanceToNextButon) {
                                            GameScene.nextButton = button
                                            distanceToNextButon = distanceToSelectedButon
                                        }
                                    }
                                    button.buttonRelease()
                                }
                            }
                        }
                    } else {
                        if(Control.totalDy > 0)  {
                            for button in buttonList {
                                if button.hidden == false {
                                    let buttonPosition = button.positionInScene()
                                    let selectedButtonPosition = selectedButton.positionInScene()
                                    
                                    if(buttonPosition.y > selectedButtonPosition.y) {
                                        let distanceToSelectedButon = CGPoint.distance(buttonPosition, selectedButtonPosition)
                                        if(distanceToSelectedButon < distanceToNextButon) {
                                            GameScene.nextButton = button
                                            distanceToNextButon = distanceToSelectedButon
                                        }
                                    }
                                    button.buttonRelease()
                                }
                            }
                        } else {
                            for button in buttonList {
                                if button.hidden == false {
                                    let buttonPosition = button.positionInScene()
                                    let selectedButtonPosition = selectedButton.positionInScene()
                                    
                                    if(buttonPosition.y < selectedButtonPosition.y) {
                                        let distanceToSelectedButon = CGPoint.distance(buttonPosition, selectedButtonPosition)
                                        if(distanceToSelectedButon < distanceToNextButon) {
                                            GameScene.nextButton = button
                                            distanceToNextButon = distanceToSelectedButon
                                        }
                                    }
                                    button.buttonRelease()
                                }
                            }
                        }
                    }
                }
                
                selectedButton.buttonPress()
                GameScene.nextButton?.buttonPress()
                
            } else {
                
                if((Control.totalDx * Control.totalDx) + (Control.totalDy * Control.totalDy) > 10 * 10) { //10 px de tolerancia
                    
                    if(abs(Control.totalDx) > abs(Control.totalDy)) {
                        if(Control.totalDx > 0) {
                            //print("right")
                        } else {
                            //print("left")
                        }
                    } else {
                        if(Control.totalDy > 0)  {
                            //print("up")
                        } else {
                            //print("down")
                        }
                    }
                }
            }
            
        #endif
    }
    
    func buttonPress() {
        self.pressed = true
        self.button.hidden = true
        self.buttonPressed.hidden = false
    }
    
    func buttonRelease() {
        self.pressed = false
        self.button.hidden = false
        self.buttonPressed.hidden = true
    }
    
    override func removeFromParent() {
        Button.buttonList.remove(self)
        super.removeFromParent()
    }
    
    #if os(tvOS)
    override func containsPoint(p: CGPoint) -> Bool {
        return super.containsPoint(CGPoint(
            x: GameScene.selectedButton!.position.x + 1,
            y: GameScene.selectedButton!.position.y - 1))
        
    }
    #endif
    
    func positionInScene() -> CGPoint {
        if let scene = self.scene {
            return self.convertPoint(self.position, toNode: scene)
        }
        print("button.scene == nil! Algo saiu errado")
        return CGPoint.zero
    }
}
