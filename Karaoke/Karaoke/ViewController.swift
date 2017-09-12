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
    
    let engine = AVAudioEngine()
    var aplayer: AVPlayer!
    
    let player = AVAudioPlayerNode()
    
    var layer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
        
//        let fileURL = URL(string: "http://vodmpqbwao2.vod.126.net/vodmpqbwao2/7618deedca2b415a8393bfb124c5a6bf_1504954277642_1504954363125_21266373-00001.mp4")!
        
//        player.play()
        
//        AVPlayer(url: )
//        let item = AVPlayerItem(url: URL(string: "http://vodmpqbwao2.vod.126.net/vodmpqbwao2/7618deedca2b415a8393bfb124c5a6bf_1504954277642_1504954363125_21266373-00001.mp4")!)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: [.interruptSpokenAudioAndMixWithOthers, .allowBluetooth, .defaultToSpeaker])
        try! AVAudioSession.sharedInstance().setActive(true)
        
        
        let fileURL = Bundle.main.url(forResource: "b", withExtension: "mp4")!
        let item = AVPlayerItem(url: fileURL)
        aplayer = AVPlayer(playerItem: item)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        layer = AVPlayerLayer(player: aplayer)
        layer.frame = UIScreen.main.bounds
        view.layer.addSublayer(layer)
        
        print(layer.isReadyForDisplay)
//        print(layer.player)
        
        ready()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let layer = layer {
            layer.frame = UIScreen.main.bounds
        }
        
    }
    
    func ready() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
            if self.layer.isReadyForDisplay {
                self.aplayer.play()
                do {
                    try self.engine.start()
                    self.player.play()
                } catch let error {
                    print(error)
                }
            } else {
                print("not ready")
                self.self.ready()
            }
        }
    }
    
    func setup() {
        
        // mainMixer
        let mainMixer = engine.mainMixerNode
        
        // mic
        let mic = engine.inputNode!
        mic.volume = 1.0
        engine.connect(mic, to: mainMixer, format: mic.inputFormat(forBus: AVAudioNodeBus.allZeros))
        
//         player
        
        player.volume = 1.0
        engine.attach(player)
        
        let fileURL = Bundle.main.url(forResource: "a", withExtension: "mp4")!
        let file = try! AVAudioFile(forReading: fileURL)
        
        engine.connect(player, to: mainMixer, format: file.processingFormat)
        player.scheduleFile(file, at: nil, completionHandler: nil)
    }

}

