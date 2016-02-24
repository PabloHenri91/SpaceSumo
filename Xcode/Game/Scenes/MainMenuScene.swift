//
//  MainMenuScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class MainMenuScene: GameScene {
    
    enum states {
        //Estado principal
        case mainMenu
        
        //Estados de saida da scene
        case options
        case credits
        case hangar
    }
    
    //Estados iniciais
    var state = states.mainMenu
    var nextState = states.mainMenu
    
    //buttons
    var buttonPlay:Button!
    var buttonOptions:Button!
    var buttonCredits:Button!
    
    var socket:SocketIOClient!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.buttonPlay = Button(textureName: "buttonYellow", icon: "play", x: 119, y: 79, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonPlay)
        
        self.buttonOptions = Button(textureName: "buttonGreenSquare", icon: "settings", x: 250, y: 146, xAlign: .right, yAlign: .down)
        self.addChild(self.buttonOptions)
        
        self.buttonCredits = Button(textureName: "buttonGreenSquare", icon: "info", x: 292, y: 146, xAlign: .right, yAlign: .down)
        self.addChild(self.buttonCredits)
        
        //Serve para setar o foco inicial no tvOS
        GameScene.selectedButton = self.buttonPlay
        
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
                
                self.socket = SocketIOClient(socketURL: NSURL(string:"http://localhost:8900")!)
                //self.socket = SocketIOClient(socketURL: NSURL(string:"http://172.16.3.149:8900")!)
                
                self.addHandlers()
                self.socket.connect()
                
                let nextSector = 0//TODO: vindo do coredata???
                let scene = HangarScene(nextSector: nextSector)
                self.view?.presentScene(scene, transition: self.transition)
                break
            default:
                break
            }
        }
    }
    
    func addHandlers() {
        
        //socket.on("") { (data:[AnyObject], socketAckEmitter:SocketAckEmitter) -> Void in
        //    print(data.description)
        //}
        
        self.socket.onAny { (socketAnyEvent:SocketAnyEvent) -> Void in
            switch(socketAnyEvent.event) {
            case "connect":
                self.socket.emit("update", "x", "y")
                break
            case "update":
                break
            default:
                print(socketAnyEvent.description)
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
                case states.mainMenu:
                    if(self.buttonPlay.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.hangar
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
