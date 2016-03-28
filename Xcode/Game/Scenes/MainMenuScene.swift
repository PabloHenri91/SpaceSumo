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
        case connect
        case connecting
    }
    
    //Estados iniciais
    var state = states.mainMenu
    var nextState = states.mainMenu
    
    //buttons
    var buttonPlay:Button!
    var buttonOptions:Button!
    var buttonCredits:Button!
    var buttonOfflineMode:Button!
    
    var labelConnectStatus:Label!
    
    #if os(iOS) || os(OSX)
    var serverManager:ServerManager! //Por seguranca o serverManager nao deve ser iniciado ainda.
    #endif
    
    var connectTime: NSTimeInterval = 0
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.buttonPlay = Button(textureName: "buttonYellow", icon: "play", x: 192, y: 120, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonPlay)
        
        self.buttonOptions = Button(textureName: "buttonGreenSquare", icon: "settings", x: 438, y: 228, xAlign: .right, yAlign: .down)
        self.addChild(self.buttonOptions)
        
        self.buttonCredits = Button(textureName: "buttonGreenSquare", icon: "info", x: 396, y: 228, xAlign: .right, yAlign: .down)
        self.addChild(self.buttonCredits)
        
        self.buttonOfflineMode = Button(textureName: "buttonGray", text:"offline mode", x:192, y:228, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonOfflineMode)
        self.buttonOfflineMode.hidden = true
        
        //Serve para setar o foco inicial no tvOS
        GameScene.selectedButton = self.buttonPlay
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
                
            case states.connecting:
                
                #if os(tvOS)
                    self.nextState = states.hangar
                #endif
                
                if self.buttonOfflineMode.hidden == true {
                    if currentTime - self.connectTime > 3 {
                        self.buttonOfflineMode.hidden = false
                        GameScene.selectedButton = self.buttonOfflineMode
                    }
                }
                
                break
                
            default:
                break
            }
        }  else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case states.hangar:
                
                let scene = HangarScene()
                self.view?.presentScene(scene, transition: self.transition)
                break
            case states.connect:
                
                self.connectTime = currentTime
                
                self.addHandlers()
                
                let box = Control(textureName: "boxWhite128x64", x:176, y:103, xAlign:.center, yAlign:.center)
                box.zPosition = box.zPosition * 4
                self.labelConnectStatus = Label(text: "connecting to server...", x:64, y:32)
                box.addChild(self.labelConnectStatus)
                self.addChild(box)
                
                #if os(iOS) || os(OSX)
                    self.serverManager.socket.connect(timeoutAfter: 33, withTimeoutHandler: { [weak self] () -> Void in
                        guard let scene = self else { return }
                        
                        if(scene.state == states.connect) {
                            scene.labelConnectStatus.setText("connection timed out")
                            ServerManager.sharedInstance.socket.disconnect()
                        }
                        
                        })
                #endif
                
                self.nextState = states.connecting
                
                break
                
            default:
                break
            }
        }
    }
    
    func addHandlers() {
        #if os(iOS) || os(OSX)
            self.serverManager = ServerManager.sharedInstance
            
            self.serverManager.socket.onAny { [weak self] (socketAnyEvent:SocketAnyEvent) -> Void in
                
                //print(socketAnyEvent.description)
                
                guard let scene = self else { return }
                
                switch scene.state {
                    
                case states.connecting:
                    switch(socketAnyEvent.event) {
                        
                    case "connect":
                        scene.labelConnectStatus.parent?.removeFromParent()
                        scene.nextState = states.hangar
                        scene.serverManager.socket.emit("userDisplayInfo", scene.serverManager.peerID.displayName)
                        break
                        
                    case "reconnect":
                        scene.buttonOfflineMode.hidden = false
                        GameScene.selectedButton = scene.buttonOfflineMode
                        break
                        
                    case "error":
                        scene.buttonOfflineMode.hidden = false
                        GameScene.selectedButton = scene.buttonOfflineMode
                        break
                        
                    case "reconnectAttempt":
                        scene.labelConnectStatus.setText("Reconnect Attempt:  " + (ServerManager.sharedInstance.socket.reconnectAttempts + 1 - (socketAnyEvent.items?.firstObject as! Int)).description)
                        break
                        
                    default:
                        print(socketAnyEvent.event + " nao foi processado")
                        break
                    }
                    
                    break
                    
                default:
                    print("Evento recebido fora do estado esperado")
                    break
                }
            }
        #endif
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.mainMenu:
                    if(self.buttonPlay.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.connect
                        return
                    }
                    break
                    
                case states.connecting:
                    if(self.buttonOfflineMode.containsPoint(touch.locationInNode(self))) {
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
