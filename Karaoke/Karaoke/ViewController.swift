//
//  ViewController.swift
//  Karaoke
//
//  Created by Chen on 11/09/2017.
//  Copyright © 2017 HUAYUN. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let urlOnline = URL(string: "http://vodmpqbwao2.vod.126.net/vodmpqbwao2/7618deedca2b415a8393bfb124c5a6bf_1504954277642_1504954363125_21266373-00001.mp4")!
    let urlLocal = Bundle.main.url(forResource: "a", withExtension: "mp4")!
    
    let engine = AVAudioEngine()
    let audioPlayer = AVAudioPlayerNode()
    var videoPlayer: AVPlayer!
    var videoPlayerLayer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.interruptSpokenAudioAndMixWithOthers, .allowBluetooth, .defaultToSpeaker])
        try! AVAudioSession.sharedInstance().setActive(true)

        setupMicAndAudio()
        setupPlayerAndLayerThenStart()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let layer = videoPlayerLayer {
            layer.frame = view.bounds
        }
    }
}

// AVPlayerLayer
extension ViewController {
    
    func setupPlayerAndLayerThenStart() {
        
        // video player
        let url = urlLocal
        let item = AVPlayerItem(url: url)
        videoPlayer = AVPlayer(playerItem: item)
        
        
        // video player layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayerLayer.frame = view.bounds
        view.layer.addSublayer(videoPlayerLayer)
        
        // start
        videoPlayer.play()
    }
}


// Mic
extension ViewController {
    
    func setupMicAndAudio() {
        let mainMixer = engine.mainMixerNode
        
        
        let mic = engine.inputNode!
        mic.volume = 1.0
        engine.connect(mic, to: mainMixer, format: mic.inputFormat(forBus: AVAudioNodeBus.allZeros))
        
        
        // player
//        let fileURL = urlLocal
//        let file = try! AVAudioFile(forReading: fileURL)
//        audioPlayer.volume = 1.0
//        engine.attach(audioPlayer)
//        engine.connect(audioPlayer, to: mainMixer, format: file.processingFormat)
//        audioPlayer.scheduleFile(file, at: nil, completionHandler: nil)
        
        
        // start
        do {
            try self.engine.start()
//            self.audioPlayer.play()
        } catch let error {
            print(error)
        }
    }
}

