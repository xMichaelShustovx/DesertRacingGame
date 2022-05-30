//
//  VideoManager.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 22.02.2022.
//

import AVKit


class VideoManager {
    
    private static var playerViewController: AVPlayerViewController?

    static func playNewRecordVideo() -> UIViewController? {
        
        let videoURL = Bundle.main.url(forResource: "newRecord", withExtension: "mp4")
        guard videoURL != nil else {return nil}
        let player = AVPlayer(url: videoURL!)
        playerViewController = AVPlayerViewController()
        playerViewController?.showsPlaybackControls = false
        playerViewController?.player = player
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController?.player?.currentItem)
        playerViewController?.player?.play()
        return playerViewController
    }
    
    @objc
    private static func playerDidFinishPlaying() { 
        self.playerViewController?.dismiss(animated: true, completion: nil)
        self.playerViewController = nil
    }
    
    deinit {
        print("Video Manager was killed")
    }
}
