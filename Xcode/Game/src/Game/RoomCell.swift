//
//  RoomCell.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/18/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class RoomCell: Control {
    
    var roomId:String
    
    init(roomId:String, x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        self.roomId = roomId
        super.init(textureName: "boxWhite337x105", x:x, y:y, xAlign:xAlign, yAlign:yAlign)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
