//
//  ChooseSector.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class ChooseSector: GameScene {
    enum states {
        //Estado principal
        case chooseSector
        
        //Estados de saida da scene
        case hangar
    }
    
    //Estados iniciais
    var state = states.chooseSector
    var nextState = states.chooseSector
    
    //buttons
    var buttonBack:Button!
    
    var sectorScrollNode:ScrollNode!
    
    var nextSector = 0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 146, xAlign: .left, yAlign: .down)
        self.addChild(self.buttonBack)
        
        var cells = Array<Control>()
        
        //TODO: 10 setores???
        for var i = 0; i < 10; i++ {
            cells.append(SectorCell(type: i))
        }
        
        self.sectorScrollNode = ScrollNode(cells: cells, x: 135, y: 62, xAlign: .center, yAlign: .center, spacing: 19, scrollDirection: .horizontal)
        
        self.addChild(self.sectorScrollNode)
        
        //Serve para setar o foco inicial no tvOS
        GameScene.selectedButton = self.buttonBack
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case states.hangar:
                let scene = HangarScene(nextSector: self.nextSector)
                self.view?.presentScene(scene, transition: self.transition)
                break
                
            default:
                break
            }
        }
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                let location = touch.locationInNode(self)
                switch (self.state) {
                case states.chooseSector:
                    if(self.buttonBack.containsPoint(location)) {
                        self.nextState = states.hangar
                        return
                    }
                    
                    if(self.sectorScrollNode.containsPoint(location)) {
                        
                        for cell in self.sectorScrollNode.cells {
                            if(cell.containsPoint(touch.locationInNode(self.sectorScrollNode))) {
                                let sectorCell = cell as! SectorCell
                                
                                self.nextSector = sectorCell.type
                                self.nextState = states.hangar
                                
                                return
                            }
                        }
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    #if os(tvOS)
    override func pressBegan(press: UIPress) -> Bool {
    
        
        switch press.type {
        case .Menu:
            break
            
        case .Select:
            self.touchesEnded(taps: Set<UITouch>([UITouch()]))
            break
        default:
            break
        }
        
        return false
    }
    #endif
}
