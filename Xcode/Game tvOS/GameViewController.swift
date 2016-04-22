//
//  GameViewController.swift
//  Game tvOS
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright (c) 2016 Pablo Henrique Bertaco. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        Config.skViewBoundsSize = skView.bounds.size
        Config.updateSceneSize()
        
        let scene = MainMenuScene()
        
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if (Control.gameScene.pressBegan(press)) {
                super.pressesBegan([press], withEvent: event)
            }
        }
    }
    
    override func pressesChanged(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if (Control.gameScene.pressChanged(press)) {
                super.pressesChanged([press], withEvent: event)
            }
        }
    }
    
    override func pressesEnded(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        for press in presses {
            if (Control.gameScene.pressEnded(press)) {
                super.pressesEnded([press], withEvent: event)
            }
        }
    }
    
    override func pressesCancelled(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        Control.resetInput()
        super.pressesCancelled(presses, withEvent: event)
    }
}
