//
//  AppDelegate.swift
//  Game OS X
//
//  Created by Pablo Henrique Bertaco on 2/17/16.
//  Copyright (c) 2016 Pablo Henrique Bertaco. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        self.window.delegate = self
        
        Config.skViewBoundsSize = skView.bounds.size
        Config.updateSceneSize()
        
        /* Pick a size for the scene */
        let scene = MainMenuScene()
        /* Set the scale mode to scale to fit the window */
        scene.scaleMode = .AspectFill
        
        self.skView!.presentScene(scene)
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true
    }
    
    func windowDidResize(notification: NSNotification) {
        self.updateSceneSize()
    }
    
    func updateSceneSize() {
        Config.skViewBoundsSize = skView.bounds.size
        self.skView.scene?.size = Config.updateSceneSize()
        Control.resetControls()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
}
