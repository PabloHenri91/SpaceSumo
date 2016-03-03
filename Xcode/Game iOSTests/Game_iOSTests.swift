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
        
        self.scene = MainMenuScene()
        
        self.view.presentScene(self.scene)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
