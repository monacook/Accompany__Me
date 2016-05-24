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

class AnswerCallViewController: UIViewController {
    
    
    
    @IBOutlet weak var timerLabel: UILabel!
    var counter:Int = 0
     var timer = NSTimer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         var timerString = String(format:"%02d:%02d", (counter/60)%60, counter%60)
        timerLabel.text = timerString
       
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "updateCounter", userInfo: nil, repeats: true)
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
