//
//  BoxMissionResult.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 4/26/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class BoxMissionResult: Box {
    init(result:[CellMissionResult]) {
        
        super.init(textureName: "boxWhite279x400")
        
        let cells = result.sort({ $0.score > $1.score })
        
        self.addChild(ScrollNode(cells: cells, x: 20, y: 50, spacing: 20, scrollDirection: ScrollNode.scrollDirections.vertical))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CellMissionResult: Control {
    
    var score = 0
    
    init(playerShip:PlayerShip) {
        super.init()
        self.score = Int(playerShip.labelScore!.getText())!
        
        let label0 = Label(text: playerShip.labelName!.getText(), fontSize:GameFonts.fontSize.large, horizontalAlignmentMode:.Left)
        label0.screenPosition = CGPoint(x: 72, y: 14)
        label0.resetPosition()
        
        let label1 = Label(text: "score  " + self.score.description, fontSize:GameFonts.fontSize.large, horizontalAlignmentMode:.Left)
        label1.screenPosition = CGPoint(x: 72, y: 34)
        label1.resetPosition()
        
        let control = Control(textureName: playerShip.textureName)
        self.loadInfo(label0, label1: label1, texture: control)
    }
    
    init(allyShip:AllyShip) {
        super.init()
        self.score = Int(allyShip.labelScore!.getText())!
        let label0 = Label(text: allyShip.name!, fontSize:GameFonts.fontSize.large, horizontalAlignmentMode:.Left)
        label0.screenPosition = CGPoint(x: 72, y: 14)
        label0.resetPosition()
        
        let label1 = Label(text: "score  " + self.score.description, fontSize:GameFonts.fontSize.large, horizontalAlignmentMode:.Left)
        label1.screenPosition = CGPoint(x: 72, y: 34)
        label1.resetPosition()
        
        let control = Control(textureName: allyShip.textureName)
        self.loadInfo(label0, label1: label1, texture: control)
    }
    
    func loadInfo(label0:Label, label1:Label, texture:Control) {
        self.addChild(label0)
        self.addChild(label1)
        self.addChild(texture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
