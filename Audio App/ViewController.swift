//
//  ViewController.swift
//  Audio App
//
//  Created by hooman mohammadi on 8/30/15.
//  Copyright (c) 2015 hooman mohammadi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
  var audioRecorder:AVAudioRecorder!
  var recordedAudio:RecordedAudio!
    
    //var newrecord:RecordedAudio!
    
  @IBOutlet weak var recordProgress: UILabel!
  @IBOutlet weak var stopButton: UIButton!
  @IBOutlet weak var microButton: UIButton!

  @IBAction func recordAudio(sender: UIButton) {
    // record voice    
    recordProgress.hidden = false;
    stopButton.hidden = false;
    microButton.enabled = false;
    
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    
    let recordName = "audio.wav"
    let pathArray = [dirPath, recordName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    println(filePath)
    
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    
    audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
    audioRecorder.delegate = self
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    
    }
  
    func audioRecorderDidFinishRecording(recorder:
        AVAudioRecorder!, successfully flag: Bool) {
        
        recordedAudio = RecordedAudio()
            
        if (flag) {
        //save
        recordedAudio.filePathURL = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        // next scence go
        self.performSegueWithIdentifier("stopRecordingNav", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  (segue.identifier == "stopRecordingNav")
        {
            let playSounndVC:playSoundViewController = segue.destinationViewController as! playSoundViewController
            
            let data = sender as! RecordedAudio
            playSounndVC.receivedAudio = data
        }
    }

  @IBAction func stopRecording(sender: UIButton) {
    recordProgress.hidden = true;
    audioRecorder.stop()
    var audioSession = AVAudioSession.sharedInstance()
    audioSession.setActive(false, error: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
 
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(animated: Bool) {
    stopButton.hidden = true;
    microButton.enabled = true;
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

