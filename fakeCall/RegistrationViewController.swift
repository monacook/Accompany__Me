//
//  RegistrationViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/26/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var userFirstNameTextField: UITextField!
    
    @IBOutlet weak var userLastNameTextField: UITextField!

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var userAgeTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("registration")
        self.userFirstNameTextField.delegate = self
        self.userLastNameTextField.delegate = self
        self.usernameTextField.delegate = self
        self.userPasswordTextField.delegate = self
        self.userConfirmPasswordTextField.delegate = self
        self.userAgeTextField.delegate = self
        
    }
    
    
    @IBAction func registerButtonTapped(sender: UIButton) {
        let userFirstName = userFirstNameTextField.text
        let userLastName = userLastNameTextField.text
        let username = usernameTextField.text
        let userPassword = userPasswordTextField.text
        let userConfirmPassword = userConfirmPasswordTextField.text
        let userAge = userAgeTextField.text
        
        //check for empty fields
        
        if (userFirstName!.isEmpty || userLastName!.isEmpty || username!.isEmpty || userPassword!.isEmpty || userConfirmPassword!.isEmpty || userAge!.isEmpty){
            displayAlertMessage("All fields are required")
            return
        }
        //check that passwords match
        
        if userPassword! != userConfirmPassword! {
            displayAlertMessage("Passwords do not match")
            return
        }
        //send user data to server side
        
        let myURL = NSURL(string: "http://52.38.127.224/users/add_user")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        let postString = "firstname=\(userFirstName!)&lastname=\(userLastName!)&username=\(username!)&password=\(userPassword!)&age=\(userAge!)"
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
                    print("after registration button", jsonResult)
                    if let userid = jsonResult["newid"] {
                        NSUserDefaults.standardUserDefaults().setObject(true, forKey:"isLoggedIn")
                        NSUserDefaults.standardUserDefaults().setObject(userid, forKey:"userID")
                        NSUserDefaults.standardUserDefaults().setObject(userFirstName, forKey:"firstName")
                        NSUserDefaults.standardUserDefaults().setObject(userLastName, forKey:"lastName")
                        NSUserDefaults.standardUserDefaults().setObject(username, forKey:"username")
                        NSUserDefaults.standardUserDefaults().setObject(userPassword, forKey:"password")
                        NSUserDefaults.standardUserDefaults().setObject(userAge, forKey:"age")
                        NSUserDefaults.standardUserDefaults().synchronize()
                        dispatch_async(dispatch_get_main_queue(), {
                            var alert = UIAlertController(title: "Registration successful", message: "You are registered! Be sure to add some contacts next!", preferredStyle: UIAlertControllerStyle.Alert)
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
                                self.performSegueWithIdentifier("regToProfileSegue", sender: self)
                        }
                            alert.addAction(okAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        }) //closes dispatch
                    }//closes if let userid
                }//closes if let jsonResult
                else {
                    self.displayAlertMessage("Sorry, your registration failed.")
                }
            }//closes do
            catch {
                print(error)
            }
        }//closes let task
        task.resume()
        
    
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        print("Done with typing")
        return false
    }

    
    func textField(textField: UITextField, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {//recognizes enter key in keyboard
            textField.resignFirstResponder()
            return false
        }
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == userConfirmPasswordTextField {
            animateViewMoving(true, moveValue: 160)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == userAgeTextField{
            animateViewMoving(false, moveValue:160)
        }
    }
    


    
    func animateViewMoving(up: Bool, moveValue: CGFloat){
        var movementDuration: NSTimeInterval = 0.3
        var movement: CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        UIView.commitAnimations()
    }
    
    
    func displayAlertMessage(userMessage: String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)

    }
    
    
    
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("regToLoginSegue", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
