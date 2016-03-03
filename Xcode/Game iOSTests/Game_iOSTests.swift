//
//  Game_iOSTests.swift
//  Game iOSTests
//
//  Created by Pablo Henrique Bertaco on 3/3/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import XCTest
import SpriteKit

class Game_iOSTests: XCTestCase {
    
    var view:SKView!
    var scene:SKScene!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.view = SKView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        
        Config.skViewBoundsSize = self.view.bounds.size
        Config.updateSceneSize()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        //super.tearDown()
    }
    
    func testMainMenuScene() {
        self.scene = MainMenuScene()
        self.view.presentScene(self.scene)
    }
    
    func testMainMenuConnect() {
        
        self.scene = MainMenuScene()
        self.view.presentScene(self.scene)
        
        XCTAssertTrue({
            if let scene = self.scene as? MainMenuScene {
                scene.nextState = MainMenuScene.states.connect
                scene.update(GameScene.currentTime)
                
                return true
            } else {
                return false
            }
            }())
    }
    
    
    func testMainMenuHangar() {
        
        self.scene = MainMenuScene()
        self.view.presentScene(self.scene)
        
        XCTAssertTrue({
            if let scene = self.scene as? MainMenuScene {
                scene.nextState = MainMenuScene.states.connect
                scene.update(GameScene.currentTime)
                scene.nextState = MainMenuScene.states.hangar
                scene.update(GameScene.currentTime)
                return true
            } else {
                return false
            }
            }())
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            self.scene = MainMenuScene()
            self.view.presentScene(self.scene)
        }
    }
}
