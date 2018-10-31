//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by John Fandrey on 3/15/18.
//  Copyright © 2018 Learning. All rights reserved.
//

import UIKit
// Import the AVFoundation framework as this is necessary for playback.
import AVFoundation

class PlaySoundsViewController: UIViewController {
   
    //Create the outlets for the playback buttons.
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var recordedAudioURL: URL! // Stores the URL for the recorded audio file.
    var audioFile: AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb // an enumeration for each button.  This allows the button to have an integer tag that can be referenced.
    }

    @IBAction func playSoundForButton(_ sender: UIButton) { // references the tag for each button and provides the desired sound effect.  
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing) // changes the state of the buttons when playback is occurring.
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio() // stops playback.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio() //calls a function in the extension to prepare for playback.
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying) // Changes the state of the buttons when nothing is being played.
    }


}
