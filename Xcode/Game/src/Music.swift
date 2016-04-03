//
//  Music.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 11/9/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import AVFoundation

class Music: NSObject {
    
    static let sharedInstance = Music()
    
    var audioPlayer:AVAudioPlayer!
    
    var musicName:String = ""
    
    func play(musicNamed name:String) {
        
        if (self.musicName != name) {
            self.musicName = name
            
            var auxName:[String] = name.componentsSeparatedByString(".")
            
            let backgroundMusicURL = NSBundle.mainBundle().URLForResource(auxName[0], withExtension: auxName[1])// TODO: remover auxName[i]
            
            do {
                try self.audioPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL!)
                self.audioPlayer.numberOfLoops = -1
                self.audioPlayer.prepareToPlay()
                self.play()
            } catch {
                #if DEBUG
                    fatalError()
                #endif
            }
        }
    }
    
    func play() {
        self.audioPlayer.play()
    }
}

