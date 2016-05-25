//
//  ViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/23/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import MediaPlayer
import MessageUI



class ViewController: UIViewController, CancelButtonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioPlayerDelegate, AVAudioRecorderDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    
//    let imagePicker: UIImagePickerController! = UIImagePickerController()
//    let saveFileName = "/test.mp4"
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var soundPlayer: AVAudioPlayer!
    
    
    
    //record a video
    
    
//    @IBAction func recordVideo(sender: AnyObject) {
//
//    if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
//        
//        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
//            imagePicker.sourceType = .Camera
//            imagePicker.mediaTypes = [kUTTypeMovie as String]
//            imagePicker.allowsEditing = false
//            imagePicker.delegate = self
//            presentViewController(imagePicker,animated: true, completion: {})
//        }
//    else {
//            
//            var alert = UIAlertController(title: "Rear camera doesn't exist", message: "Application cannot access the camera.", preferredStyle: UIAlertControllerStyle.Alert)
//            let okAction = UIAlertAction(title: "Fine.", style: UIAlertActionStyle.Default){ action in
//                print("okay")
//            }
//            alert.addAction(okAction)
//            self.presentViewController(alert, animated: true, completion: nil)
//    
//        }
//    }
//    else {
//        var alert = UIAlertController(title: "Camera inaccessible", message: "Application cannot access the camera.", preferredStyle: UIAlertControllerStyle.Alert)
//        let okAction = UIAlertAction(title: "Fine.", style: UIAlertActionStyle.Default){ action in
//            print("okay")
//        }
//        alert.addAction(okAction)
//        self.presentViewController(alert, animated: true, completion: nil)
//        
//        }
//
//    }
//    
//    //finished recording a video
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        print("Got a video")
//        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
//            //save video to the main photo album
//            let selectorToCall = #selector(ViewController.videoWasSavedSuccessfully(_:didFinishSavingWithError:context:))
//            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
//            //save video to app directory so we can play it later
//            let videoData = NSData(contentsOfURL: pickedVideo)
//            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//            let documentsDirectory: AnyObject = paths[0]
//            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
//            videoData?.writeToFile(dataPath, atomically: false)
//        }
//        imagePicker.dismissViewControllerAnimated(true, completion: {
//            //anything you want to happen when user saves a video
//        })
//    }
//    
//    //called when the user selects cancel
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        print("user canceled image")
//        dismissViewControllerAnimated(true, completion: {
//            //anything for canceling
//        })
//    }
//    
//    func videoWasSavedSuccessfully(video: String, didFinishSavingWithError error: NSError!, context: UnsafeMutablePointer<()>){
//        print("Video saved")
//        if let theError = error {
//            print("An error happened while saving teh video = \(theError)")
//        }
//        else {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//         
//                //What you want to happen
//            })
//        }
//    }
//
//
//    var ringtoneEffect: AVAudioPlayer!
//    let path = NSBundle.mainBundle().pathForResource("ringtone.mp3", ofType: nil)!
    
//    @IBAction func playVideo(sender: AnyObject) {
//        print("play a video")
//        //find the video in the app's document directory
//        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
//        let documentsDirectory: AnyObject = paths[0]
//        let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
//        let videoAsset = (AVAsset(URL: NSURL(fileURLWithPath: dataPath)))
//        let playerItem = AVPlayerItem(asset: videoAsset)
//        
//        //play the video
//        let player = AVPlayer(playerItem: playerItem)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.presentViewController(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
//    }
    
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

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadRecordingUI() {
//        recordButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        recordButton.setTitle("Tap to Record", forState: .Normal)
        recordButton.titleLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
        recordButton.addTarget(self, action: #selector(recordTapped), forControlEvents: .TouchUpInside)
        view.addSubview(recordButton)
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("recording.m4a")
        print("AUDIO FILE NAMEEEE", audioFilename)
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
    
    
    @IBAction func playSound(sender: UIButton) {
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
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        print("Get Documents", documentsDirectory)
        return documentsDirectory
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func soundButtonPressed(sender: UIButton) {
               
        performSegueWithIdentifier("phoneCall", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "phoneCall" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ReceiveCallViewController
            controller.cancelButtonDelegate = self
        }
    }
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
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
    
    func getFileURLAsString() -> String {
        print("get file url")
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        let fileurl = documentsDirectory.stringByAppendingString("/recording.m4a")
        print("documentsDirectory.....", fileurl)
        return String(fileurl)
    }

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
    
    
    @IBAction func sendMessage(sender: UIButton) {
//        if MFMessageComposeViewController.canSendText() {
//            let messageVC = MFMessageComposeViewController()
//            messageVC.body = "enter a message"
//            messageVC.recipients = ["Enter tel-nr"]
//            messageVC.messageComposeDelegate = self
//            self.presentViewController(messageVC, animated: false, completion: nil)
//        }
//        else {
//            print("Can't send text")
//        }
        
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject("Have you heard?")
            mailComposer.setMessageBody("Listen up!", isHTML: false)
            let filepath = getFileURLAsString()
            let fileData = NSData(contentsOfFile: filepath)
            mailComposer.addAttachmentData(fileData!, mimeType: "audio/mp3", fileName: "yelping")
            mailComposer.addAttachmentData(fileData!, mimeType: "audio/m4a", fileName: "yelpingm4a")
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        // handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func mapkitButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("mapkitSegue", sender: self)
    }
    
    

}

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
}


