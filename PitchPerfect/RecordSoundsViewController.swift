//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Yakeem Noel on 4/26/19.
//  Copyright © 2019 Yakeem Noel. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK:label and buttons on first viewController 
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // setting audio recorder to AVAudio
    var audioRecorder : AVAudioRecorder!
    
    // MARK: func for view did load, stop record button set top false at start up
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // used to test that viewWillAppear was executed
        print("View will appear called")
    }
    // MARK: function I created to alter UI experiance.. change the label, enable the stop record button and record button
    // NOTE: the function has a similar name func configureUI
    func uiConfig(recordAudio:Bool) -> Void {
        if recordAudio {
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
        } else {
            recordingLabel.text = "Tap to Record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
        
    // MARK: when record is pressed uiConfig function is called followed by code to record
    @IBAction func recordAudio(_ sender: AnyObject) {
        uiConfig(recordAudio: true)
        // this is where the audio file is being saved
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)

        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath! , settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    //MARK: when stoprecord button is press  uiConfig is called and set to false, so the else part of the function is excuted
    @IBAction func stopRecording(_ sender: AnyObject) {
        uiConfig(recordAudio: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        
        } else {
            print("recording was not successful")
        }
    }
    // MARK:  segue for when "stoprecording" is identified the segue displays the playsoundsviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


