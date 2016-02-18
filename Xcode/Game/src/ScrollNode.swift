//
//  ScrollNode.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/9/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class ScrollNode: Control {
    
    static var scrollNodeList = Set<ScrollNode>()
    
    enum scrollDirections {
        case horizontal
        case vertical
    }
    
    var cells: Array<Control>!
    
    var scrollDirection:scrollDirections
    var canScroll:Bool!
    var spacing:Int
    
    var firstCellPositionX:CGFloat = 0
    var firstCellPositionY:CGFloat = 0
    
    let force = 1
    var width = 0
    var height = 0
    
    init(name: String = "", cells: Array<Control>, x:Int = 0, y:Int = 0, z:Int = 0,
        xAlign:Control.xAlignments = .left,
        yAlign:Control.yAlignments = .up, spacing:Int = 40, scrollDirection:scrollDirections = .horizontal,
        index:Int = 0) {
            
            self.scrollDirection = scrollDirection
            self.spacing = spacing
            super.init()
            
            self.screenPosition = CGPoint(x: x, y: y)
            self.yAlign = yAlign
            self.xAlign = xAlign
            
            self.resetPosition()
            
            self.cells = cells
            self.canScroll = true//TODO: vindo por parametro
            
            var i = 0
            for control in self.cells {
                
                let size = control.calculateAccumulatedFrame().size
                
                control.xAlign = .left
                control.yAlign = .up
                
                switch(scrollDirection) {
                case scrollDirections.horizontal:
                    self.width = Int(size.width)
                    control.screenPosition = CGPoint(x: 0 + (((self.width * Int(Config.screenScale)) + spacing) * (i - index)), y: 0)
                    break
                    
                case scrollDirections.vertical:
                    self.height = Int(size.height)
                    control.screenPosition = CGPoint(x: 0, y: 0 + (((self.height * Int(Config.screenScale)) + spacing) * (i - index)))
                    break
                }
                
                control.resetPosition()
                
                control.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10, height: 10))
                control.physicsBody!.affectedByGravity = false
                control.physicsBody!.categoryBitMask = 0
                control.physicsBody!.linearDamping = 4
                
                self.addChild(control)
                
                //TODO: nao remover da lista mas marcar que nao deve ser alinhado automaticamente
                Control.controlList.remove(control)
                i++
            }
            
            if let position = cells.first?.position {
                self.firstCellPositionX = position.x
                self.firstCellPositionY = position.y
            }
            
            ScrollNode.scrollNodeList.insert(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func resetScrollNodes() {
        for scrollNode in ScrollNode.scrollNodeList {
            scrollNode.resetPosition()
        }
    }
    
    class func update() {
        for scrollNode in ScrollNode.scrollNodeList {
            
            var containsPoins = false
            
            for touch in Control.touchesArray {
                if scrollNode.containsPoint(touch.0.locationInNode(scrollNode.parent!)) {
                    containsPoins = true
                    break
                }
            }
            
            if (scrollNode.canScroll == true) {
                
                switch scrollNode.scrollDirection {
                    
                case scrollDirections.horizontal:
                    
                    var outOfBounds = false
                    
                    if !(scrollNode.cells[scrollNode.cells.count - 1].position.x >= scrollNode.firstCellPositionX) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.x - scrollNode.firstCellPositionX)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: -auxMove * scrollNode.force/10, dy: 0))
                        }
                    }
                    
                    if !(scrollNode.cells[0].position.x <= scrollNode.firstCellPositionX) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[0].position.x - scrollNode.firstCellPositionX)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: -auxMove * scrollNode.force/10, dy: 0))
                        }
                    }
                    
                    if(!outOfBounds && !containsPoins) {
                        
                        if(abs(scrollNode.cells[0].physicsBody!.velocity.dx) < 20) {
                            
                            let i = round((scrollNode.firstCellPositionX - scrollNode.cells[0].position.x) / CGFloat(scrollNode.width + scrollNode.spacing/Int(Config.screenScale)))
                            
                            var auxMove:CGFloat = 0
                            
                            auxMove = scrollNode.firstCellPositionX - scrollNode.cells[Int(i)].position.x
                            
                            for cell in scrollNode.cells {
                                cell.physicsBody!.applyForce(CGVector(dx: auxMove, dy: 0))
                            }
                        }
                    }
                    
                    break
                    
                case scrollDirections.vertical:
                    
                    var outOfBounds = false
                    
                    if !(scrollNode.cells[0].position.y >= scrollNode.firstCellPositionY) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[0].position.y - scrollNode.firstCellPositionY)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: 0, dy: -auxMove * scrollNode.force/10))
                        }
                    }
                    if !(scrollNode.cells[scrollNode.cells.count - 1].position.y <= scrollNode.firstCellPositionY) {
                        outOfBounds = true
                        let auxMove:Int = Int(scrollNode.cells[scrollNode.cells.count - 1].position.y - scrollNode.firstCellPositionY)
                        for cell in scrollNode.cells {
                            cell.physicsBody!.applyForce(CGVector(dx: 0, dy: -auxMove * scrollNode.force/10))
                        }
                    }
                    
                    if(!outOfBounds && !containsPoins) {
                        
                        if(abs(scrollNode.cells[0].physicsBody!.velocity.dy) < 20) {
                            
                            let i = round((scrollNode.cells[0].position.y - scrollNode.firstCellPositionY) / CGFloat(scrollNode.height + scrollNode.spacing/Int(Config.screenScale)))
                            
                            let auxMove = scrollNode.firstCellPositionY - scrollNode.cells[Int(i)].position.y
                            
                            for cell in scrollNode.cells {
                                cell.physicsBody!.applyForce(CGVector(dx: 0, dy: auxMove))
                            }
                        }
                    }
                    
                    break
                }
            }
        }
    }
    
    class func updateOnTouchesMoved() {
        
        for scrollNode in ScrollNode.scrollNodeList {
            
            if (scrollNode.canScroll == true) {

                switch scrollNode.scrollDirection {
                    
                case scrollDirections.horizontal:
                    
                    var canMove = true
                    
                    if(Control.dx > 0) {
                        if !(scrollNode.cells[0].position.x <= scrollNode.firstCellPositionX) {
                            canMove = false
                        }
                    } else {
                        if !(scrollNode.cells[scrollNode.cells.count - 1].position.x >= scrollNode.firstCellPositionX) {
                            canMove = false
                        }
                    }
                    
                    if(canMove) {
                        
                        for touch in Control.touchesArray {
                            if scrollNode.containsPoint(touch.0.locationInNode(scrollNode.parent!)) {
                                for cell in scrollNode.cells {
                                    let position = cell.position
                                    cell.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                                    cell.position = CGPoint(x: position.x + Control.dx, y: position.y)
                                    cell.physicsBody!.applyForce(CGVector(dx: Control.dx * CGFloat(scrollNode.force * 5), dy: 0))
                                }
                            }
                        }
                    }
                    
                    break
                    
                case scrollDirections.vertical:
                    
                    for touch in Control.touchesArray {
                        
                        var canMove = true
                        
                        if(Control.dy > 0) {
                            if !(scrollNode.cells[scrollNode.cells.count - 1].position.y <= scrollNode.firstCellPositionY) {
                                canMove = false
                            }
                        } else {
                            if !(scrollNode.cells[0].position.y >= scrollNode.firstCellPositionY) {
                                canMove = false
                            }
                        }
                        
                        if(canMove) {
                            if scrollNode.containsPoint(touch.0.locationInNode(scrollNode.parent!)) {
                                
                                for cell in scrollNode.cells {
                                    let position = cell.position
                                    cell.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                                    cell.position = CGPoint(x: position.x, y: position.y + Control.dy)
                                    cell.physicsBody!.applyForce(CGVector(dx: 0, dy: Control.dy * CGFloat(scrollNode.force * 5)))
                                }
                            }
                        }
                    }
                    
                    break
                }
            }
        }
    }
    
    class func updateOnTouchesEnded() {
        
        for scrollNode in ScrollNode.scrollNodeList {
            
            if (scrollNode.canScroll == true) {
                
                switch scrollNode.scrollDirection {
                    
                case scrollDirections.horizontal:
                    
                    for touch in Control.touchesArray {
                        if scrollNode.containsPoint(touch.0.locationInNode(scrollNode.parent!)) {
                            
                            for cell in scrollNode.cells {
                                let position = cell.position
                                cell.position = CGPoint(x: position.x + Control.dx, y: position.y)
                                cell.physicsBody!.applyForce(CGVector(dx: Control.dx * CGFloat(scrollNode.force * 10), dy: 0))
                            }
                        }
                    }
                    break
                    
                case scrollDirections.vertical:
                    
                    for touch in Control.touchesArray {
                        if scrollNode.containsPoint(touch.0.locationInNode(scrollNode.parent!)) {
                            
                            for cell in scrollNode.cells {
                                let position = cell.position
                                cell.position = CGPoint(x: position.x, y: position.y + Control.dy)
                                cell.physicsBody!.applyForce(CGVector(dx: 0, dy: Control.dy * CGFloat(scrollNode.force * 10)))
                            }
                        }
                    }
                    break
                }
            }
        }
    }
    
    override func removeFromParent() {
        ScrollNode.scrollNodeList.remove(self)
        super.removeFromParent()
    }
}
