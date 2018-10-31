//
//  RecordSoundsViewController.swift
//
//  Pitch Perfect
//
//  Created by John Fandrey on 3/14/18.
//  Copyright © 2018 Learning. All rights reserved.
//

import UIKit

// The AVFoundation framework needs to be added so that this View Controller can access swifts audio functions.

import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
       
    var audioRecorder: AVAudioRecorder!     // Create the AudioRecorder variable so that this View Controller can access Audio Recorder in different functions.
    
    // Create Outlets for the RecordingLabel, Record Button, and Stop Recording Button.
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // Load the View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateRecordingLabel(record: false)
        // Do any additional setup after loading the view, typically from a nib.
    }
   
    func updateRecordingLabel(record: Bool) {               // This function changes the buttons to the appropriate states to reflect changes either recording or waiting to record.
        recordingLabel.text = (record ? "Recording in progress . . ." : "Press to Record.")
        recordButton.isEnabled = !record
        stopRecordingButton.isEnabled = record
    }

    
// Create the code to be run once the record button is pressed.
    
    @IBAction func RecordAudio(_ sender: Any) {
        updateRecordingLabel(record: true)                      // Calls the updateRecordinglabel function.
        // The next few lines of code create the filepath for the recording and stores it as a URL.  Note the file is named 'recordedVoice.wav.
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String  // We need to tell swift where to store the file.
        let recordingName = "recordedVoice.wav"  // A string is created to store the name of the recorded file.
        let pathArray = [dirPath, recordingName]  // The path array is an array of strings that store the directory path and the file name.
        let filePath = URL(string: pathArray.joined(separator: "/")) // The filepath is a URl that is the combined directory path and file names.
        
        let session = AVAudioSession.sharedInstance() // Create an AVAudioSession.  Since there is only one set of audio hardware on a device there is only one audio session and the audio session is shared among all devices.
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)  // Sets up the app for recording and playing audio.  The 'try' statement is used with an '!' because it does not handle any errors.
        
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:]) // Creates an AVAudioRecorder.
        audioRecorder.delegate = self               // Allows this view controller to act as the delegate for AVAudioRecorder.

        
        // The next three lines of code set the properties of 'audioRecorder' so that it is ready to record.
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    // The code for 'stopRecording' changes the recording label text and stops the audioRecorder.
    @IBAction func stopRecording(_ sender: Any) {
        updateRecordingLabel(record: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // The code for audioRecorderDidFinishRecording checks to enssure that the file was successfully saved before the segue to the next view controller is executed.
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            displayError("The recording was not properly saved. Please try recording again.")
        }
    }
    
    func displayError(_ error: String){
        // Code for displaying an alert notification was obtained at https://www.ioscreator.com/tutorials/display-alert-ios-tutorial-ios10.  The tutorial for displaying this type of alert was posted by Arthur Knopper on January 10, 2017.
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // The prepare(for segue: , sender:) function provides the recorded audio file to the PlaySoundsViewController. 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}
