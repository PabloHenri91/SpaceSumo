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
        case mainMenu
    }
    
    //Estados iniciais
    var state = states.chooseSector
    var nextState = states.chooseSector
    
    //buttons
    var buttonBack:Button!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 146, xAlign: .left, yAlign: .down)
        self.addChild(self.buttonBack)
        
        var cells = Array<Control>()
        
        for var i = 0; i < 10; i++ {
            cells.append(Control(textureName: "boxWhite64x64"))
        }
        
        self.addChild(ScrollNode(cells: cells, x: 135, y: 62, xAlign: .center, yAlign: .center, spacing: 19, scrollDirection: .horizontal))
        
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
            case states.mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: self.transition)
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
                switch (self.state) {
                case states.chooseSector:
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.mainMenu
                        return
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
            return true
            
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
