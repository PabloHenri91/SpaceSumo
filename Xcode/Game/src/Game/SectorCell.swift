//
//  SectorCell.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 2/18/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class SectorCell: Control {
    
    static var types = [SectorCellType](arrayLiteral:
        SectorCellType(name: "1"),
        SectorCellType(name: "2"),
        SectorCellType(name: "3"),
        SectorCellType(name: "4"),
        SectorCellType(name: "5"),
        SectorCellType(name: "6"),
        SectorCellType(name: "7"),
        SectorCellType(name: "8"),
        SectorCellType(name: "9"),
        SectorCellType(name: "10")
    )
    
    var type:Int

    init(type:Int, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        self.type = type
        
        super.init(textureName: "boxWhite64x64", x:x, y:y, xAlign:xAlign, yAlign:yAlign)
        
        let label = Label(text: SectorCell.types[type].name, x:10, y:10)
        
        self.addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SectorCellType {
    var name:String
    
    init(name:String) {
        self.name = name
    }
}
