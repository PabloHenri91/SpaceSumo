//
//  MissionScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class MissionScene: GameScene {
    
    enum states {
        //Estado principal
        case mission
        
        //Estados de saida da scene
        case chooseSector
    }
    
    //Estados iniciais
    var state = states.mission
    var nextState = states.mission
    
    //buttons
    var buttonBack:Button!
    
    var sector = 0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.buttonBack = Button(textureName: "buttonGraySquare", icon: "back", x: 10, y: 146, xAlign: .left, yAlign: .down)
        self.addChild(self.buttonBack)
        
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
            case states.chooseSector:
                self.view?.presentScene(ChooseSector(), transition: self.transition)
                break
                
            default:
                break
            }
        }
    }

}
