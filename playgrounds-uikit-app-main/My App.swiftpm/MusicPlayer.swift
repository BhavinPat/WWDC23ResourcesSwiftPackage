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
        
        if let bundle = Bundle.module1.path(forResource: "bensound-theduel", ofType: "mp3") {
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

import class Foundation.Bundle
private class BundleFinder {}
extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var module1: Bundle = {
        let bundleName = "WWDC23ResourcesSwiftPackage"

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named BioSwift_BioSwift")
    }()
}

