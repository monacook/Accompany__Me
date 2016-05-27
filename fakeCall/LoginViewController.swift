//
//  LoginViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/26/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
   
    @IBOutlet weak var notFoundLabel: UILabel!
    
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        notFoundLabel.hidden = true
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    
    @IBAction func signInButtonPressed(sender: AnyObject) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        let usernameText = usernameTextField.text
        let passText = passwordTextField.text
        let myURL = NSURL(string:"http://52.38.127.224/users/get_user_by_username")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        let postString = "username=\(usernameText!)&password=\(passText!)"
        print(postString)
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
                    print("after login button", jsonResult)
                    
                    if jsonResult["notFound"] != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.notFoundLabel.hidden = false
                        })
                    }
                    if jsonResult["foundUser"] != nil {
                        if let userInfo = jsonResult["foundUser"] {
                            dispatch_async(dispatch_get_main_queue(), {
                            self.notFoundLabel.hidden = true
                                
                               
                                    
                                NSUserDefaults.standardUserDefaults().setObject(true, forKey:"isLoggedIn")
                                if let foundage = userInfo["age"] {
                                NSUserDefaults.standardUserDefaults().setObject(foundage, forKey:"age")
                                }
                                if let foundFname = userInfo["first_name"]{
                                    NSUserDefaults.standardUserDefaults().setObject(foundFname, forKey:"firstName")
                                }
                                if let foundid = userInfo["id"]{
                                    NSUserDefaults.standardUserDefaults().setObject(foundid, forKey:"userID")
                                }
                                if let foundLname = userInfo["last_name"]{
                                    NSUserDefaults.standardUserDefaults().setObject(foundLname, forKey:"lastName")
                                }
                                if let foundpass = userInfo["password"]{
                                    NSUserDefaults.standardUserDefaults().setObject(foundpass, forKey:"password")
                                }
                                if let username = userInfo["username"]{
                                    NSUserDefaults.standardUserDefaults().setObject(username, forKey:"username")
                                }
                            print("The gathered info", userInfo["age"], userInfo["first_name"])
                              
                                  self.performSegueWithIdentifier("loginBackHomeSegue", sender: self)
                            })
                        }
                        
                    }
                    
                    
                    
                    
                }//closes if let jsonResult
                else {
                    self.displayAlertMessage("Something's wrong....")
                }
            } //closes do
            catch {
                print(error)
            }
        } //closes let task
        task.resume()
        
//
        
        
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        print("Done with typing")
        return false
    }

    
    
    @IBAction func makeAccountButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("loginToRegSegue", sender: self)
      
    }
    
    func displayAlertMessage(userMessage: String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
        
    }

    
    @IBAction func homeButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("loginBackHomeSegue", sender: self)
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
}
