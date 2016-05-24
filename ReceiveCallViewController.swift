//
//  ReceiveCallViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/23/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import AVFoundation

class ReceiveCallViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
//    let gradientLayer = CAGradientLayer()
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
    var ringtoneEffect: AVAudioPlayer!
    
   
    
 
    
    let path = NSBundle.mainBundle().pathForResource("ringtone.mp3", ofType: nil)!
    
    override func viewDidLoad() {
        
        
           super.viewDidLoad()
                
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            ringtoneEffect = sound
            for _ in 1...5 {
                sound.numberOfLoops = -1
                sound.play()
            }
        } catch {
            print("\(error)")
        }

//        self.view.backgroundColor = UIColor.blueColor()
//        gradientLayer.frame = self.view.bounds
//        let color1 = UIColor.yellowColor().CGColor as CGColorRef
//        let color2 = UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0).CGColor as CGColorRef
//        let color3 = UIColor.clearColor().CGColor as CGColorRef
//        let color4 = UIColor(white: 0.0, alpha: 0.7).CGColor as CGColorRef
//        gradientLayer.colors = [color4, color2, color3, color1]
//        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
//        self.view.layer.addSublayer(gradientLayer)
//        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
        
    }
    
    
    @IBAction func answerButtonPressed(sender: UIButton) {
        ringtoneEffect.stop()
        performSegueWithIdentifier("answerSegue", sender: self)
    }
    
 
    
    
    @IBAction func declineButtonPressed(sender: UIButton) {
        print("Declined")
        ringtoneEffect.stop()
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




