//
//  SoundManager.swift
//  Lighthouse
//
//  Created by Alina Yu on 12/6/18.
//  Copyright © 2018 Alina Yu. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    static var audioPlayer = AVAudioPlayer()
    
    static var playing = false
    static var muted = false
    
    static func playMusic() {
        // address of the music file.
        let music = Bundle.main.path(forResource: "Moon", ofType: "mp3")
        // copy this syntax, it tells the compiler what to do when action sis received
        do {
            SoundManager.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
        
        SoundManager.audioPlayer.numberOfLoops = -1
            SoundManager.audioPlayer.prepareToPlay()
            SoundManager.audioPlayer.play()
        }
}
