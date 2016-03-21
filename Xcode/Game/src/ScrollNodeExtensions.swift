//
//  ScrollNodeExtensions.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/21/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

extension ScrollNode {

    func append(control:Control) {
        
        let size = control.calculateAccumulatedFrame().size
        self.width = Int(size.width)
        self.height = Int(size.height)
        
        control.xAlign = .left
        control.yAlign = .up
        
        switch(scrollDirection) {
        case scrollDirections.horizontal:
            self.width = Int(size.width)
            control.screenPosition = CGPoint(x: ((self.width * Int(Config.screenScale)) + spacing) * self.cells.count, y: 0)
            break
            
        case scrollDirections.vertical:
            self.height = Int(size.height)
            control.screenPosition = CGPoint(x: 0, y: ((self.height * Int(Config.screenScale)) + spacing) * self.cells.count)
            break
        }
        
        control.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 10, height: 10))
        control.physicsBody!.affectedByGravity = false
        control.physicsBody!.categoryBitMask = 0
        control.physicsBody!.linearDamping = 4
        
        //a primeira celula é adicionada na origem do nodo mas as outras acompanha as existentes
        if self.cells.count > 0 {
            if let lastCell = self.cells.last {
                
                if let lastCellPhysicsBodyVelocity = lastCell.physicsBody?.velocity {
                    control.physicsBody?.velocity = lastCellPhysicsBodyVelocity
                }
                
                let lastCellPosition = lastCell.position
                
                switch(self.scrollDirection) {
                case scrollDirections.horizontal:
                    let x = lastCellPosition.x + CGFloat(self.width + spacing)
                    let y = lastCellPosition.y
                    
                    control.position = CGPoint(x: x, y: y)
                    break
                    
                case scrollDirections.vertical:
                    let x = lastCellPosition.x
                    let y = lastCellPosition.y - CGFloat(self.height + self.spacing)
                    
                    control.position = CGPoint(x: x, y: y)
                    break
                }
            }
        } else {
            control.resetPosition()
        }
        
        self.addChild(control)
        self.cells.append(control)
        Control.controlList.remove(control) //TODO: nao remover da lista mas marcar que nao deve ser alinhado automaticamente
        
        if let firstCell = cells.first {
            
            let firstCellPosition = firstCell.position
            firstCell.resetPosition()
            
            self.firstCellPositionX = firstCell.position.x
            self.firstCellPositionY = firstCell.position.y
            
            firstCell.position = firstCellPosition
        }
        
        self.canScroll = self.cells.count > 0
    }
    
    func remove() {
        //
    }
}
