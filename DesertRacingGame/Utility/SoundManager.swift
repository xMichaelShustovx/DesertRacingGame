//
//  SoundManager.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 22.02.2022.
//

import AVFoundation

class SoundManager {
    
    private static var player: AVAudioPlayer?
    
    static func playBackgroundSound() {
        let soundURL = Bundle.main.url(forResource: "backgroundSound", withExtension: "wav")
        guard soundURL != nil else {return}
        self.playSound(url: soundURL!)
    }
    
    static func playCrashSound() {
        let soundURL = Bundle.main.url(forResource: "crashSound", withExtension: "wav")
        guard soundURL != nil else {return}
        self.playSound(url: soundURL!)
    }
    
    static func stopPlaying() {
        self.player?.stop()
        self.player = nil
    }
    
    private static func playSound(url: URL) {
        do {
            self.player = try AVAudioPlayer(contentsOf: url)
            self.player?.prepareToPlay()
            self.player?.play()
        }
        catch {
            print("Couldn't create Audio Player")
            print(error.localizedDescription)
        }
    }
}
