//
//  MusicPlayer.swift
//  UIKit Sample
//
//  Created by Bhavin Patel on 4/9/22.
//

import Foundation
import AVFoundation
import WWDC23ResourcesSwiftPackage
public class MusicPlayer {
    public static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?
    var audioPlayer1: AVAudioPlayer?
    public func startBackgroundMusic() {
        
        if let bundle = Bundle.module.path(forResource: "bensound-theduel", ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                //audioPlayer = try AVAudioPlayer(
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 0.3
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    public func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}
extension Bundle {
    public static var wwdc23: Bundle = .module
}

