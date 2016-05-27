//
//  ManageContactsViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/26/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit

class ManageContactsViewController: UITableViewController {
    
    let userid = NSUserDefaults.standardUserDefaults().stringForKey("userID")
//    var names = NSUserDefaults.standardUserDefaults().arrayForKey("allcontacts")
//    var lastnames = NSUserDefaults.standardUserDefaults().arrayForKey("allcontactsLast")
//    var numbers = NSUserDefaults.standardUserDefaults().arrayForKey("contactPhones")
//    var emails = NSUserDefaults.standardUserDefaults().arrayForKey("contactEmails")
    var names = [String]()
    var lastnames = [String]()
    var numbers = [String]()
    var emails = [String]()
  
//    var names = ["Joe Smith", "Bloody Mary", "Frankenstein"]
//    var names = [String]()
//    var numbers = ["123123", "3435352", "897897"]
    // var numbers = [String]()
//    var emails = ["7898998", "93889@asdj", "asdfoi.asdfo"]
//    var emails = [String]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(userid, names, lastnames)
        print(NSUserDefaults.standardUserDefaults().stringForKey("allcontacts"))
//        print("Names Two Array", namesTwo)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().arrayForKey("allcontacts") == nil {
            names = ["No names listed yet"]
        }
        else {
        names = NSUserDefaults.standardUserDefaults().arrayForKey("allcontacts") as! [String]
        }
        if NSUserDefaults.standardUserDefaults().arrayForKey("allcontactsLast") == nil {
            lastnames = ["No last names listed yet"]
        }
        else {
        lastnames = NSUserDefaults.standardUserDefaults().arrayForKey("allcontactsLast") as! [String]
        }
        if NSUserDefaults.standardUserDefaults().arrayForKey("contactPhones") == nil {
            numbers = ["No numbers listed yet"]
        }
        else {
        numbers = NSUserDefaults.standardUserDefaults().arrayForKey("contactPhones") as! [String]
        }
        if NSUserDefaults.standardUserDefaults().arrayForKey("contactEmails") == nil {
            emails = ["No emails listed yet"]
        }
        else {
        emails = NSUserDefaults.standardUserDefaults().arrayForKey("contactEmails") as! [String]
        }
        tableView.reloadData()
        
           }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell") as! ContactCell
        cell.contactNameLabel.text = "\(names[indexPath.row])" + " " + "\(lastnames[indexPath.row])"
        cell.contactNumberLabel.text = "\(numbers[indexPath.row])"
        cell.contactEmailLabel.text = "\(emails[indexPath.row])"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    
}