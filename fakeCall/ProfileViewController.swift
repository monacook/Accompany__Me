//
//  ProfileViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/26/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate  {
    
    
    
    
    let id = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    var firstName = NSUserDefaults.standardUserDefaults().stringForKey("firstName")
    var lastName = NSUserDefaults.standardUserDefaults().stringForKey("lastName")
    var username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    var password = NSUserDefaults.standardUserDefaults().stringForKey("password")
    var age = NSUserDefaults.standardUserDefaults().stringForKey("age")
    
    
    

    
    
    @IBOutlet weak var firstNameTextField: UITextField!


    @IBOutlet weak var lastNameTextField: UITextField!

    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var welcomeUsername: UILabel!
    
    @IBAction func updateProfileButtonPressed(sender: UIButton) {
        let upfn = firstNameTextField.text
        let upln = lastNameTextField.text
        let upuser = usernameTextField.text
        let uppass = passwordTextField.text
        let upage = ageTextField.text
        if(upfn!.isEmpty || upln!.isEmpty || upuser!.isEmpty || uppass!.isEmpty || upage!.isEmpty){
            displayAlertMessageWithoutMoving("All fields are required to update")
            return
        }
        
        let myURL = NSURL(string: "http://52.38.127.224/users/update_user_and_get_new_info")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        let postString = "firstname=\(upfn!)&lastname=\(upln!)&username=\(upuser!)&password=\(uppass!)&age=\(upage!)&id=\(id!)"
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
                    print("after update button", jsonResult)
                    if let newinfo = jsonResult["updatedInfo"]{
                        dispatch_async(dispatch_get_main_queue(), {
                  
                        self.firstName = newinfo["first_name"] as! String
                        self.lastName = newinfo["last_name"] as! String
                        self.username = newinfo["username"] as! String
                        self.password = newinfo["password"] as! String
                        self.age = newinfo["age"] as! String
                        self.displayAlertMessageDelay("Your profile was updated.")
                        }) //closes dispatch
                    } //closes if let newifo
                }//closes if let jsonResult
                else {
                    self.displayAlertMessageWithoutMoving("Sorry, your update failed.")
                }
            }//closes do
            catch {
                print(error)
            }
        } //closes let task
        task.resume()
        
        
    }
    
    @IBAction func manageContactsButtonPressed(sender: UIButton) {
        print("managing contacts")
        performSegueWithIdentifier("profileToContactsSegue", sender: self)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.ageTextField.delegate = self
        
        
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isLoggedIn") == true {
            welcomeUsername.text = String("Welcome \(username!)")
            firstNameTextField.text = firstName!
            lastNameTextField.text = lastName!
            usernameTextField.text = username!
            passwordTextField.text = password!
            ageTextField.text = age!
        }
        else {
            displayAlertMessage("Oops! You'll need to log in!")
        }

    }
    
    func updateDefaults(){
        print(firstName!, lastName!, username!, password!, age!)
        NSUserDefaults.standardUserDefaults().setObject(firstName!, forKey:"firstName")
        NSUserDefaults.standardUserDefaults().setObject(lastName!, forKey:"lastName")
        NSUserDefaults.standardUserDefaults().setObject(username!, forKey:"username")
        NSUserDefaults.standardUserDefaults().setObject(password!, forKey:"password")
        NSUserDefaults.standardUserDefaults().setObject(age!, forKey:"age")
        NSUserDefaults.standardUserDefaults().synchronize()
        welcomeUsername.text = String("Welcome \(username!)")
        firstNameTextField.text = firstName!
        lastNameTextField.text = lastName!
        usernameTextField.text = username!
        passwordTextField.text = password!
        ageTextField.text = age!



    }
    
    
    
    func displayAlertMessage(userMessage: String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default) { action in
            self.performSegueWithIdentifier("backToHomeSegue", sender: self)
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
        
    }
    
    func displayAlertMessageWithoutMoving(userMessage: String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler: nil)
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
    }
    
    func displayAlertMessageDelay(userMessage: String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default) {action in
           self.updateDefaults()
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
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
        if textField == ageTextField {
            animateViewMoving(true, moveValue: 160)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == ageTextField{
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


    
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}