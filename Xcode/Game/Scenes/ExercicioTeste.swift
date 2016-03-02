//
//  ExercicioTeste.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/1/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class ExercicioTeste: GameScene {
    
    enum states {
        //Estado principal
        case exercicioTeste
        
        //Estados de saida da scene
        case vai
        
        case login
    }
    
    //Estados iniciais
    var state = states.exercicioTeste
    var nextState = states.exercicioTeste
    
    var textFieldUser:TextField!
    var textFieldPassword:TextField!
    
    var buttonLogin:Button!
    
    var dados:[String:AnyObject]!

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        self.textFieldUser = TextField(x: 103, y: 37, xAlign: .center, yAlign: .center, view: self.view!)
        self.addChild(self.textFieldUser)
        
        self.textFieldPassword = TextField(x: 103, y: 79, xAlign: .center, yAlign: .center, view: self.view!)
        self.addChild(self.textFieldPassword)
        
        self.buttonLogin = Button(textureName: "buttonYellow", text: "vai", x: 119, y: 121, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonLogin)
        
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
                
            case states.vai:
                
                let scene = ExercicioTeste2(dados: self.dados)
                self.view?.presentScene(scene, transition: self.transition)
                
                break
            case states.login:
                
                self.login(self.textFieldUser.textField.text!, password: self.textFieldPassword.textField.text!)
                
                break
            default:
                break
            }
        }
    }
    
    func login(user:String, password:String) {
        
        if let url = NSURL(string:
            "http://server03.local:60080/login/?user=" +
                user +
                "&password=" +
                password) {

        
//        if let url = NSURL(string:
//            "http://server03.local:60080/login/?user=" +
//                self.textFieldUser.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) +
//                "&password=" +
//                self.textFieldPassword.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())) {
        
        //if let url = NSURL(string: "http://server03.local:60080/login/?user=ash&password=mistyS2") {
            
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "GET"
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    return
                }
                
                let response = try! NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                if(response["response"] as! String == "false") {
                    let box = Box(textureName: "boxWhite256x64")
                    let label = Label(text: response["message"] as! String, x:128, y:32)
                    box.addChild(label)
                    self.addChild(box)
                    
                    self.blackSpriteNode.zPosition = box.zPosition - 1
                    
                    self.blackSpriteNode.hidden = false
                    
                    let button = Button(textureName: "buttonGray", text:"ok   D:", x: 119, y: 142, xAlign: .center, yAlign: .down)
                    self.addChild(button)
                    button.zPosition = self.blackSpriteNode.zPosition + 1
                    
                    button.addHandler(
                        { [weak self] in
                            guard let scene = self else { return }
                            scene.nextState = states.exercicioTeste
                            box.removeFromParent()
                            button.removeFromParent()
                            scene.blackSpriteNode.hidden = true
                        })
                    
                } else {
                    self.dados = response
                    self.nextState = states.vai
                }
            }
            
            task.resume()
            
        } else {
            self.nextState = states.exercicioTeste
            
            let box = Box(textureName: "boxWhite256x64")
            let label = Label(text: "Nao poe espaco!", x:128, y:32)
            box.addChild(label)
            self.addChild(box)
            
            self.blackSpriteNode.zPosition = box.zPosition - 1
            
            self.blackSpriteNode.hidden = false
            
            let button = Button(textureName: "buttonGray", text:"ok   D:", x: 119, y: 142, xAlign: .center, yAlign: .down)
            self.addChild(button)
            button.zPosition = self.blackSpriteNode.zPosition + 1
            
            button.addHandler(
                { [weak self] in
                    guard let scene = self else { return }
                    scene.nextState = states.exercicioTeste
                    box.removeFromParent()
                    button.removeFromParent()
                    scene.blackSpriteNode.hidden = true
                })
        }

    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.exercicioTeste:
                    if(self.buttonLogin.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.login
                        return
                    }
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
}
