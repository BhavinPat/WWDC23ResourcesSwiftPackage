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
    var package = WWDC23ResourcesSwiftPackage()
    public func startBackgroundMusic() {
        audioPlayer = package.music
        if let bundle = Bundle.resource.path(forResource: "bensound-theduel", ofType: "mp3") {
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
import Foundation

private class MyBundleFinder {}

extension Foundation.Bundle {
    
    /**
     The resource bundle associated with the current module..
     - important: When `DateTimePicker` is distributed via Swift Package Manager, it will be synthesized automatically in the name of `Bundle.module`.
     */
    static var resource: Bundle = {
        let moduleName = "WWDC23ResourcesSwiftPackage"
        #if COCOAPODS
        let bundleName = moduleName
        #else
        let bundleName = "\(moduleName)_\(moduleName)"
        #endif
        
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: MyBundleFinder.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        fatalError("Unable to find bundle named \(bundleName)")
    }()
}
