//
//  IncidentReportViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/24/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//


import UIKit

class IncidentReportViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, CancelButtonDelegate {
    
     weak var cancelButtonDelegate: CancelButtonDelegate?
    
    var incidentTypesChecked = [Int]()
    var otherIncident = ""
    var dateOfIncident = ""
   
    
    @IBOutlet weak var checkBoxOne: CheckBox!
    @IBOutlet weak var checkBoxTwo: CheckBox!
    @IBOutlet weak var checkBoxThree: CheckBox!
    @IBOutlet weak var checkBoxFour: CheckBox!
    @IBOutlet weak var checkBoxFive: CheckBox!
    @IBOutlet weak var checkBoxSix: CheckBox!
    @IBOutlet weak var checkBoxSeven: CheckBox!
    @IBOutlet weak var checkBoxEight: CheckBox!
    @IBOutlet weak var checkBoxNine: CheckBox!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!

    
    @IBOutlet weak var otherTextField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        incidentTypesChecked = []
        
        if checkBoxOne.isChecked == true {
            incidentTypesChecked.append(1)
        }
        if checkBoxTwo.isChecked == true {
            incidentTypesChecked.append(2)
        }
        if checkBoxThree.isChecked == true {
            incidentTypesChecked.append(3)
        }
        if checkBoxFour.isChecked == true {
            incidentTypesChecked.append(4)
        }
        if checkBoxFive.isChecked == true {
            incidentTypesChecked.append(5)
        }
        if checkBoxSix.isChecked == true {
            incidentTypesChecked.append(6)
        }
        if checkBoxSeven.isChecked == true {
            incidentTypesChecked.append(7)
        }
        if checkBoxEight.isChecked == true {
            incidentTypesChecked.append(8)
        }
        if checkBoxNine.isChecked == true {
            incidentTypesChecked.append(9)
            if otherTextField.text != "" {
                otherIncident = otherTextField.text!
            }
            else {
                //alert that field should not be empty
                emptyFieldAlert()
            }
        }
        if incidentTypesChecked.count <= 0 {
            emptyFieldAlert()
        }
        if dateOfIncident != "" {
             NSUserDefaults.standardUserDefaults().setObject(dateOfIncident, forKey: "incidentDate")
        }
        else {
            //alert that date can't be left empty
            emptyDateAlert()
        }
        
        NSUserDefaults.standardUserDefaults().setObject(incidentTypesChecked, forKey: "incidentsArray")
        NSUserDefaults.standardUserDefaults().setObject(otherIncident, forKey: "newIncidentType")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isReportingLocation")
        NSUserDefaults.standardUserDefaults().setObject(descriptionField.text, forKey: "incidentDescription")

        NSUserDefaults.standardUserDefaults().synchronize()
        
        performSegueWithIdentifier("backToMapView", sender: self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Saved incidents", NSUserDefaults.standardUserDefaults().arrayForKey("incidentsArray"), NSUserDefaults.standardUserDefaults().stringForKey("newIncidentType"))
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        datePicker.maximumDate = NSDate()
        self.descriptionField.delegate = self
        self.otherTextField.delegate = self
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func datePickerChanged(datePicker: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE MMMM dd yyyy HH:mm"
        dateOfIncident = dateFormatter.stringFromDate(datePicker.date)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == descriptionField {
            animateViewMoving(true, moveValue: 200)
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == descriptionField{
            animateViewMoving(false, moveValue:200)
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
    
    
    @IBAction func incidentTypeChecked(sender: UIButton) {
        let sendertag = sender.tag
        var categoryid = Int(0)
        var categoryToLookUpTitle = ""
        
        
        let myURL = NSURL(string: "http://52.38.127.224/incidents/get_categories")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(myURL!, completionHandler: {
            data, response, error in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    if let results = jsonResult["all"]{
                        let resultsArray = results as! NSArray
                        let categoryToLookUp = resultsArray[sendertag - 1]
                        categoryToLookUpTitle = categoryToLookUp["title"] as! String
                        
                        }
                }
            } catch {
                print("Something went wrong")
            }
        })
        task.resume()
    }
    
    
    @IBAction func incidentCategoryTapped(sender: UIButton) {
        let sendertag = sender.tag
        var categoryToLookUpDesc = ""
        var categoryToLookUpTitle = ""
        
        let myURL = NSURL(string: "http://52.38.127.224/incidents/get_categories")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(myURL!, completionHandler: {
            data, response, error in
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    if let results = jsonResult["all"]{
                        let resultsArray = results as! NSArray
                        let categoryToLookUp = resultsArray[sendertag - 1]
                        categoryToLookUpTitle = categoryToLookUp["title"] as! String
                        categoryToLookUpDesc = categoryToLookUp["descriptions"] as! String
                        self.categoryAlert(categoryToLookUpTitle, description: categoryToLookUpDesc)
                        }
                    }
            } catch {
                print("Something went wrong")
            }
        })
        task.resume()
        
    }
    
    func categoryAlert(title: String, description: String){
        
        
        let alert = UIAlertController(title: "\(title)", message: "\(description)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ action in
            print("okay")
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
        
    }
    
    func emptyFieldAlert(){
        let alert = UIAlertController(title: "Empty field", message: "Please select an incident category or fill out the text field to make your own category", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            action in
            print("okay")
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func emptyDateAlert(){
        let alert = UIAlertController(title: "Date not chosen", message: "Please indicate when the incident occurred", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            action in
            print("okay")
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "backToMapView" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! MapkitViewController
            controller.cancelButtonDelegate = self
        }
    }
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        print("Done with typing")
        return false
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {//recognizes enter key in keyboard
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    
    
}
