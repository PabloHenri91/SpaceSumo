//
//  RoomCell.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/18/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class RoomCell: Control {
    
    var buttonJoin:Button!
    
    var labelName0:Label?
    var labelName1:Label?
    var labelName2:Label?
    var labelName3:Label?
    
    var roomId:String?
    var usersDisplayInfo:[UserDisplayInfo]?
    
    init(x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init(textureName: "boxWhite299x105", x:x, y:y, xAlign:xAlign, yAlign:yAlign)
    }
    
    func loadLobbyRoom(roomId roomId:String, usersDisplayInfo:[UserDisplayInfo], x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        
        self.removeAllChildren()
        
        let box = Control(textureName: "boxWhite337x105")
        box.zPosition = self.zPosition + 1
        self.addChild(box)
        
        self.loadRoomInfo(roomId: roomId, usersDisplayInfo: usersDisplayInfo)
        
        self.buttonJoin = Button(textureName: "buttonYellow", text:"join", x: 230, y: 64, xAlign: .left, yAlign: .up)
        self.buttonJoin.zPosition = self.zPosition + 2
        self.addChild(self.buttonJoin)
    }
    
    func loadRoomInfo(roomId roomId:String, usersDisplayInfo:[UserDisplayInfo]) {
        
        self.roomId = roomId
        self.usersDisplayInfo = usersDisplayInfo
        
        if let label = self.labelName0 {
            label.removeFromParent()
        }
        if let label = self.labelName1 {
            label.removeFromParent()
        }
        if let label = self.labelName2 {
            label.removeFromParent()
        }
        if let label = self.labelName3 {
            label.removeFromParent()
        }
        
        var i = 0
        for userDisplayInfo in usersDisplayInfo {
            
            if let name = userDisplayInfo.displayName {
                switch i {
                    
                case 0:
                    self.labelName0 = Label(text: name.truncate(19, trailing: "..."), x:54, y:15, xAlign: .left, yAlign: .up)
                    self.labelName0!.zPosition = self.zPosition + 2
                    self.addChild(self.labelName0!)
                    break
                case 1:
                    self.labelName1 = Label(text: name.truncate(19, trailing: "..."), x:118, y:32, xAlign: .left, yAlign: .up)
                    self.labelName1!.zPosition = self.zPosition + 2
                    self.addChild(self.labelName1!)
                    break
                case 2:
                    self.labelName2 = Label(text: name.truncate(19, trailing: "..."), x:182, y:15, xAlign: .left, yAlign: .up)
                    self.labelName2!.zPosition = self.zPosition + 2
                    self.addChild(self.labelName2!)
                    break
                    
                case 3:
                    self.labelName3 = Label(text: name.truncate(19, trailing: "..."), x:246, y:32, xAlign: .left, yAlign: .up)
                    self.labelName3!.zPosition = self.zPosition + 2
                    self.addChild(self.labelName3!)
                    break
                    
                default:
                    print("Nome inesperado s;")
                    break
                }
            }
            i += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
