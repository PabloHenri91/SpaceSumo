//
//  Control.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 10/29/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Control: SKNode {
    
    static var controlList = Set<Control>()
    
    static var gameScene:GameScene!
    
    static var dx:CGFloat = 0
    static var dy:CGFloat = 0
    
    static var totalDx:CGFloat = 0
    static var totalDy:CGFloat = 0
    
    #if os(iOS) || os(tvOS)
    static var touchesArray = [UITouch: Double]()
    #endif
    
    #if os(OSX)
    static var touchesArray = [NSEvent: Double]()
    
    static var location = NSPoint.zero
    static var previousLocation = NSPoint.zero
    
    #endif
    
    enum xAlignments: Int {
        case left = 0
        case center = 1
        case right = 2
    }
    
    enum yAlignments: Int {
        case up = 0
        case center = 1
        case down = 2
    }
    
    var yAlign = yAlignments.up
    var xAlign = xAlignments.left
    
    var size:CGSize!
    
    var screenPosition:CGPoint = CGPointZero
    
    override init() {
        super.init()
    }
    
    init(name:String = "", textureName:String, size:CGSize = CGSize.zero, x:Int = 0, y:Int = 0, z:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init()
        let spriteNode = SKSpriteNode(imageNamed: textureName)
        spriteNode.texture?.filteringMode = .Nearest
        self.load(name, spriteNode: spriteNode, size:size, x: x, y: y, z:z, xAlign: xAlign, yAlign: yAlign)
    }
    
    init(name:String = "", spriteNode:SKSpriteNode, size:CGSize = CGSize.zero, x:Int = 0, y:Int = 0, z:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init()
        self.load(name, spriteNode: spriteNode, size:size, x: x, y: y, z:z, xAlign: xAlign, yAlign: yAlign)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(name:String, spriteNode:SKSpriteNode, size:CGSize, x:Int, y:Int, z:Int, xAlign:Control.xAlignments, yAlign:Control.yAlignments) {
        self.name = name
        self.screenPosition = CGPoint(x: x, y: y)
        self.yAlign = yAlign
        self.xAlign = xAlign
        
        self.resetPosition()
        
        self.zPosition = (z == 0 ? Config.HUDZPosition : CGFloat(z))
        
        if !(size == CGSize.zero) {
            spriteNode.size = size
        }
        spriteNode.anchorPoint = CGPoint(x: 0, y: 1)
        spriteNode.name = name
        self.addChild(spriteNode)
        
        Control.controlList.insert(self)
    }
    
    class func resetControls() {
        for control in Control.controlList {
            control.resetPosition()
        }
        Button.resetButtons()
        //Switch.resetSwitches()
        ScrollNode.resetScrollNodes()
        GameTextField.resetTextFields()
        
        self.gameScene.blackSpriteNode.size = self.gameScene.size
    }
    
    func resetPosition() {
        self.position = CGPoint(
            x: Int(screenPosition.x/Config.screenScale) + Int(Config.translate.x * CGFloat(xAlign.rawValue)),
            y: -Int(screenPosition.y/Config.screenScale) - Int(Config.translate.y * CGFloat(yAlign.rawValue)))
    }
    
    override func removeFromParent() {
        Control.controlList.remove(self)
        super.removeFromParent()
    }
    
    
    
    //Input
    
    static func resetInput() {
        
        Control.dx = 0
        Control.dy = 0
        
        Control.totalDx = 0
        Control.totalDy = 0
        
        #if os(iOS) || os(tvOS)
            Control.touchesArray = [UITouch: Double]()
        #endif
        
        #if os(OSX)
            Control.touchesArray = [NSEvent: Double]()
            
            Control.location = NSPoint.zero
            Control.previousLocation = NSPoint.zero
        #endif
    }
    
    static func touchesBeganUpdate() {
        #if os(OSX)
            for touch in Control.touchesArray {
                self.location = touch.0.locationInNode(Control.gameScene)
            }
        #endif
    }
    
    static func touchesMovedUpdate() {
        #if os(iOS) || os(tvOS)
            for touch in Control.touchesArray {
                let location = touch.0.locationInNode(Control.gameScene)
                let previousLocation = touch.0.previousLocationInNode(Control.gameScene)
                
                Control.totalDx += location.x - previousLocation.x
                Control.totalDy += location.y - previousLocation.y
                
                Control.dx += location.x - previousLocation.x
                Control.dy += location.y - previousLocation.y
            }
        #endif
        
        #if os(OSX)
            for touch in Control.touchesArray {
                self.previousLocation = self.location
                self.location = touch.0.locationInNode(Control.gameScene)
                
                Control.totalDx += location.x - previousLocation.x
                Control.totalDy += location.y - previousLocation.y
                
                Control.dx += location.x - previousLocation.x
                Control.dy += location.y - previousLocation.y
            }
        #endif
    }
    
    static func touchesEndedUpdate() {
        Control.totalDx = 0
        Control.totalDy = 0
    }
    
    #if os(iOS) || os(tvOS)
    static func touchesBegan(touches: Set<UITouch>, _ responder:UIResponder) {
        Control.touchesEndedUpdate()
        for touch in touches {
            Control.touchesArray.updateValue(GameScene.currentTime, forKey: touch)
        }
        Button.update()
        responder.touchesBegan(touches)
    }
    
    static func touchesMoved(touches: Set<UITouch>, _ responder:UIResponder) {
        Control.touchesMovedUpdate()
        Button.update()
        ScrollNode.updateOnTouchesMoved()
        responder.touchesMoved(touches)
    }
    
    static func touchesEnded(touches: Set<UITouch>, _ responder:UIResponder) {
        ScrollNode.updateOnTouchesEnded()
        
        #if os(iOS) || os(tvOS)
            var taps = Set<UITouch>()
            
            for touch in touches {
                if let value = Control.touchesArray.removeValueForKey(touch) {
                    if(GameScene.currentTime - value < 1) {
                        if(!((Control.totalDx * Control.totalDx) + (Control.totalDy * Control.totalDy) > 10 * 10)) {
                            taps.insert(touch)
                        }
                    }
                }
            }
            
            Button.update(taps)
            
            #if os(iOS)
                if (taps.count > 0) {
                    responder.touchesEnded(taps: taps)
                }
            #endif
            
        #endif
        
        Control.touchesEndedUpdate()
        
        responder.touchesEnded(touches)
    }
    
    static func touchesCancelled(responder:UIResponder) {
        Control.resetInput()
        Button.update()
        Control.touchesEndedUpdate()
        responder.touchesCancelled()
    }
    #endif
    
    #if os(OSX)
    static func mouseDown(theEvent: NSEvent, _ responder:NSResponder) {
        Control.touchesArray.updateValue(GameScene.currentTime, forKey: theEvent)
        Control.touchesBeganUpdate()
        Button.update()
        responder.touchesBegan(Set<NSEvent>(arrayLiteral: theEvent))
    }
    
    static func mouseDragged(theEvent: NSEvent, _ responder:NSResponder) {
        let eventTime = Control.touchesArray.first!.1
        Control.touchesArray.removeAll()
        Control.touchesArray.updateValue(eventTime, forKey: theEvent)
        Control.touchesMovedUpdate()
        Button.update()
        ScrollNode.updateOnTouchesMoved()
        responder.touchesMoved(Set<NSEvent>(arrayLiteral: theEvent))
    }
    
    static func mouseUp(theEvent: NSEvent, _ responder:NSResponder ) {
        let eventTime = Control.touchesArray.first!.1
        
        ScrollNode.updateOnTouchesEnded()
        
        Control.touchesArray.removeAll()
        
        if(GameScene.currentTime - eventTime < 1) {
            Button.update(theEvent)
            responder.touchesEnded(taps: Set<NSEvent>(arrayLiteral: theEvent))
        }
        
        Button.update()
        Control.touchesEndedUpdate()
        responder.touchesEnded(Set<NSEvent>(arrayLiteral: theEvent))
    }
    #endif
}
