//
//  Config.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 10/29/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class Config: NSObject {
    
    static var skViewBoundsSize:CGSize!
    
    static var translate:CGPoint!
    static var translateInView:CGPoint!
    static var currentSceneSize:CGSize!
    
    static let screenScale:CGFloat = 1 // 1x, 2x, 3x
    
    static let defaultSceneSize:CGSize = CGSize(width: 480/screenScale, height: 270/screenScale)
    static var sceneSize:CGSize = defaultSceneSize
    
    static var HUDZPosition:CGFloat = 1000
    
    static var scale:CGFloat!
    
    static func updateSceneSize() -> CGSize {
        
        let xScale = skViewBoundsSize.width / sceneSize.width
        let yScale = skViewBoundsSize.height / sceneSize.height
        Config.scale = min(xScale, yScale)
        
        Config.translate = CGPoint(
            x: Int(((skViewBoundsSize.width - (sceneSize.width * scale))/2)/scale),
            y: Int(((skViewBoundsSize.height - (sceneSize.height * scale))/2)/scale))
        
        Config.translateInView = CGPoint(
            x: ((skViewBoundsSize.width - (sceneSize.width * scale))/2)/scale,
            y: ((skViewBoundsSize.height - (sceneSize.height * scale))/2))
        
        Config.currentSceneSize = CGSize(
            width: Int(skViewBoundsSize.width / scale),
            height: Int(skViewBoundsSize.height / scale))
        
        return Config.currentSceneSize
    }
}
