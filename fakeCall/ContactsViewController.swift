//
//  ContactsViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/26/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITextFieldDelegate {
    
    
    let userID = NSUserDefaults.standardUserDefaults().stringForKey("userID")
    var names = [String]()
    var lastNames = [String]()
    var phones = [String]()
    var emails = [String]()
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var addContactButton: UIButton!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.phoneTextField.delegate = self
        self.emailTextField.delegate = self
        
        let myURL = NSURL(string:"http://52.38.127.224/users/get_users_contacts")
        
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
                        if let contacts = jsonResult["contacts"] as? NSArray {
                            print("Digging through contacts")
                            
                            for contact in contacts {
                                if let contactFirstName = contact["first_name"]{
                                    
                                    self.names.append(contactFirstName as! String)
                                }
                                if let contactLastName = contact["last_name"]{
                                   self.lastNames.append(contactLastName as! String)
                                }
                                if let contactPhone = contact["phone_number"]{
                                    self.phones.append(contactPhone as! String)
                                }
                                if let contactEmail = contact["email"]{
                                    self.emails.append(contactEmail as! String)
                                }
                            }//closes for loop
                        print("After forloop", self.names, self.phones, self.emails)
                            self.updateDefaults()
                        }
                    })//closes dispatch
                }//closes if let jsonResult
            }//closes do
            catch {
                print(error)
            }
        }//closes let task
        task.resume()
    
        
    }
    
    @IBAction func homeButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("backToHomeSegue", sender: self)
    }
    
    @IBAction func addContactButtonPressed(sender: UIButton) {
        let contactFirstName = firstNameTextField.text
        let contactLastName = lastNameTextField.text
        let contactNumber = phoneTextField.text
        let contactEmail = emailTextField.text
        //check for empty fields
        if(contactFirstName!.isEmpty && contactLastName!.isEmpty && contactNumber!.isEmpty && contactEmail!.isEmpty) {
           displayAlertMessage("Please fill out at least one field.")
        }
        let myURL = NSURL(string:"http://52.38.127.224/users/add_contact")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        let postString = "userid=\(userID!)&firstname=\(contactFirstName!)&lastname=\(contactLastName!)&number=\(contactNumber!)&email=\(contactEmail!)"
        print("To Post", postString)
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
                    print(jsonResult)
                    self.names.append(self.firstNameTextField.text!)
                    self.lastNames.append(self.lastNameTextField.text!)
                    self.phones.append(self.phoneTextField.text!)
                    self.emails.append(self.emailTextField.text!)
                    self.updateDefaults()
                    self.displayAlertMessage("Contact added!")
                }
            }
            catch {
            print(error)
            }
        }//closes let task
        task.resume()
        
    
    }
    
    
    func updateDefaults() {
        NSUserDefaults.standardUserDefaults().setObject(names, forKey: "allcontacts")
        print("Update defaults", names)
        
        NSUserDefaults.standardUserDefaults().setObject(lastNames, forKey: "allcontactsLast")
        print("last", lastNames)
        
        NSUserDefaults.standardUserDefaults().setObject(phones, forKey: "contactPhones")
        print("phones", phones)
        NSUserDefaults.standardUserDefaults().setObject(emails, forKey: "contactEmails")
        print("Emailllls", emails)
        
    }
    
    
    func displayAlertMessage(userMessage: String) {
        let alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
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
        if textField == emailTextField {
            animateViewMoving(true, moveValue: 160)
            addContactButton.enabled = false
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == emailTextField {
            animateViewMoving(false, moveValue:160)
            addContactButton.enabled = true
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
