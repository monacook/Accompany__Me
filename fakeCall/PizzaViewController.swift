//
//  PizzaViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/27/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import MessageUI

class PizzaViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var userID = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    var loggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn")
    var contactNumbers = [String]()
    var contactEmails = [String]()
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    
    @IBAction func profileButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("homeToProfileSegue", sender: self)
    }
    
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        // handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    
    
    @IBAction func textMessageButtonPressed(sender: UIButton) {
        print("SMS message", contactEmails, contactNumbers)
        if MFMessageComposeViewController.canSendText() {
            if loggedIn == false {
                let messageVC = MFMessageComposeViewController()
                messageVC.body = "Please call me as soon as possible. It's an emergency."
                messageVC.recipients = ["Enter tel-nr"]
                messageVC.messageComposeDelegate = self
                self.presentViewController(messageVC, animated: false, completion: nil)
            }
            else if loggedIn == true {
                let messageVC = MFMessageComposeViewController()
                messageVC.body = "Please call me as soon as possible. It's an emergency."
                messageVC.recipients = contactNumbers
                messageVC.messageComposeDelegate = self
                 self.presentViewController(messageVC, animated: false, completion: nil)
            }
        }
        else {
            print("Can't send text")
        }
      
    }
    
    func Long() {
        print("longpress")
        
           
        if loggedIn == true {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        profileButton.enabled = false
        }
        else {
            print("Already logged out")
        }
        

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longGesture = UILongPressGestureRecognizer(target: self, action: "Long")
        logOutButton.addGestureRecognizer(longGesture)
        
        
        
        print("Logged in???", loggedIn)
        if loggedIn == true {
            
            profileButton.enabled = true
            let myURL = NSURL(string: "http://52.38.127.224/users/get_users_contacts")
            let request = NSMutableURLRequest(URL: myURL!)
            request.HTTPMethod = "POST"
            let postString = "id=\(userID!)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error in
                if error != nil {
                    print("error = \(error)")
                    return
                }
                var err: NSError?
                
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            print(jsonResult)
                        
                        if let data = jsonResult["contacts"]{
                            print("Getting there", data)
                            for datum in (data as? NSArray)! {
                               self.contactNumbers.append(datum["phone_number"] as! String)
                                self.contactEmails.append(datum["email"] as! String)
                                print(self.contactNumbers)
                                print(self.contactEmails)
                            }
                            }
                        })
                        
                    }//closes if let jsonResult
                    else {
                        self.displayAlertMessage("Sorry, we cannot send your message. If this is an emergency, dial 911.")
                    }
                }//closes do
                catch {
                    print(error)
                }
            }//closes let task
            task.resume()
            
            
        }
        else {
            profileButton.enabled = false
        }
        

       
}
    
    override func viewDidAppear(animated: Bool) {
        if loggedIn == true {
            profileButton.enabled = true
        }
        else {
            profileButton.enabled = false
        }
        
    }
    
    func displayAlertMessage(userMessage: String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

