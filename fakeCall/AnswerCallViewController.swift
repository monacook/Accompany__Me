//
//  AnswerCallViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/23/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import MessageUI


class AnswerCallViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate {

    
    
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    var counter:Int = 0
     var timer = NSTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {
                [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        print("Failed to record!")
                    }
                }
            }
        } catch {
            print("Failed to record!")
        }

        
         var timerString = String(format:"%02d:%02d", (counter/60)%60, counter%60)
        timerLabel.text = timerString
       
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "updateCounter", userInfo: nil, repeats: true)
        }
    
    
    
    //loadRecordingUI
    func loadRecordingUI(){
        recordButton.setTitle("Tap to Record", forState: .Normal)
        recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        recordButton.addTarget(self, action: #selector(recordTapped), forControlEvents: .TouchUpInside)
        view.addSubview(recordButton)
        print("recording")
        
    }
    
    //startRecording
    func startRecording() {
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        print("AUDIO FILE NAMEEE!", audioFilename)
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        let settings = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey : 12000.0,
                        AVNumberOfChannelsKey : 1 as NSNumber,
                        AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            recordButton.setTitle("Tap to Stop", forState: .Normal)
        } catch {
            finishRecording(success: false)
        }
        
    }


    
    @IBAction func playsound(sender: UIButton) {
        if(sender.titleLabel?.text == "play recording"){
            print("play recording")
            recordButton.enabled = false
            sender.setTitle("Stop", forState: .Normal)
            print("about to prepare player")
            preparePlayer()
            soundPlayer.play()
        } else {
            soundPlayer.stop()
            sender.setTitle("play", forState: .Normal)
        }

        
    }
    
    func finishRecording(success success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        if success {
            recordButton.setTitle("Tap to re-record", forState: .Normal)
            print("Success")
        }
        else {
            recordButton.setTitle("Tap to record", forState: .Normal)
            print("Not success?")
        }
    }
    
    //recordTapped
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    //func audioRecorderDidFinishRecording
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    //func getDocumentsDirectory
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        print("Get Documents", documentsDirectory)
        return documentsDirectory
        
    }
    //func getFileURL -> NSURL
    
    
    func getFileURL() -> NSURL {
        print("get file url")
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        let fileurl = documentsDirectory.stringByAppendingString("/recording.m4a")
        //        let path = getCacheDirectory().stringByAppendingString("recording.m4a")
        //        let filePath = NSURL(fileURLWithPath: path)
        //        print("filepath for the squid", filePath)
        //        return filePath
        print("documentsDirectory.....", fileurl)
        return NSURL(fileURLWithPath: fileurl)
    }
    
    //func getFileURLAsString
    
    func getFileURLAsString() -> String {
        print("get file url")
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        let fileurl = documentsDirectory.stringByAppendingString("/recording.m4a")
        print("documentsDirectory.....", fileurl)
        return String(fileurl)
    }

    //func preparePlayer()
    
    func preparePlayer() {
        print("preparing the player")
        var error: NSError?
        do {
            print("do try AVaudioPlayer")
            soundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch let error1 as NSError {
            error = error1
            soundPlayer = nil
        }
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
        } else {
            print("sound player delegate")
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
        }
    }

    
    
    // UNDER KEYPAD \\
   
    @IBAction func sendMessage(sender: UIButton) {
        print("Emailing, seriously")
        if MFMailComposeViewController.canSendMail() {
            print("Emailing")
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Have you heard?")
            mailComposer.setMessageBody("Listen up!", isHTML: false)
            let filepath = getFileURLAsString()
            let fileData = NSData(contentsOfFile: filepath)
            mailComposer.addAttachmentData(fileData!, mimeType: "audio/mp3", fileName: "yelping")
            mailComposer.addAttachmentData(fileData!, mimeType: "audio/m4a", fileName: "yelpingm4a")
            self.presentViewController(mailComposer, animated: true,                                                            completion: nil)
            print("got mail?")
        }
    }
    
    //func mailComposeController
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //func messageComposeViewController
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult  result: MessageComposeResult) {
        //handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func updateCounter() {
       
        counter+=1
        var timerString = String(format:"%02d:%02d", (counter/60)%60, counter%60)
        timerLabel.text = timerString
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func endCallButtonPressed(sender: UIButton) {
        timer.invalidate()
        performSegueWithIdentifier("returnHomeSegue", sender: self)
    }

}

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
}

