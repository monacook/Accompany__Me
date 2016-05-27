//
//  ConfirmationPageViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/25/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit

class ConfirmationPageViewController: UITableViewController {
    
    var reportingMode = NSUserDefaults.standardUserDefaults().boolForKey("isReportingLocation")
    var incidentIDArray = NSUserDefaults.standardUserDefaults().arrayForKey("incidentsArray")
    var incidentTypes = NSUserDefaults.standardUserDefaults().arrayForKey("incidentTitles")
    var locationCoords = NSUserDefaults.standardUserDefaults().stringForKey("locationCoords")
    var incidentDescription = NSUserDefaults.standardUserDefaults().stringForKey("incidentDescription")
    var dateOfIncident = NSUserDefaults.standardUserDefaults().stringForKey("incidentDate")
    
    
    
    let section = ["Date", "Location", "Incident Types", "Incident Description"]
    
//    var items = [["may","june"], ["here", "there"], ["oops", "yeah"], ["Something long"]]
    var items = [Array<String>]()
    var dateItems = [String]()
    var locationItems = [String]()
    var incidentItems = [String]()
    var descItems = [String]()
    

    
       override func viewDidLoad() {
        
        super.viewDidLoad()
        if let dOfI = dateOfIncident {
            dateItems.append(dOfI)
        }
        else {
            dateItems.append("No date provided.")
        }
        items.append(dateItems)
        
        if let unwrappedCoords = locationCoords {
            let splitcoords = unwrappedCoords.componentsSeparatedByString(" ")
            let latitude = splitcoords[1]
            let longitude = splitcoords[3]
            let latitudeNoComma = "Latitude: " + String(latitude.characters.dropLast())
            locationItems.append(latitudeNoComma)
            let longitudeNoPara = "Longitude: " + String(longitude.characters.dropLast())
            locationItems.append(longitudeNoPara)
        }
        else {
            locationItems.append("Location not provided.")
        }
        items.append(locationItems)
        
        if let inTypes = incidentTypes {
            for inType in inTypes {
                incidentItems.append(inType as! String)
            }
        }
        else {
            incidentItems.append("Incident Type not provided.")
        }
        items.append(incidentItems)
        
        if let incDesc = incidentDescription {
            if incDesc != "nil" && incDesc != "Describe the incident." {
                descItems.append(incDesc)
            }
            else {
                descItems.append("No description provided.")
            }
        }
        else {
            descItems.append("No description provided.")
        }
        items.append(descItems)
        
        
        print("THE COUNT", dateItems, locationCoords, "split", locationItems, incidentItems, descItems)
//        
//        if incidentTypes!.count <= 0 {
//            somethingWrongAlert()
//        }
//        else {
//        print("Gonna print incidents", incidentTypes!)
//
//        items.append(array)
//        print("a")
//        items.append(incidentTypes as! Array<String>)
//        print("b")
//
//        
//        }
//       
//        else {
//            items.append(["No description provided"])
//             print("c")
//        }
//        print("coordinates", locationCoords)
//        }
//        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if incidentTypes!.count <= 0 {
            
            somethingWrongAlert()
            return "String"
        }
        else {
        return self.section[section]
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if incidentTypes!.count <= 0 {
            somethingWrongAlert()
            return 1
        }
        else {
        
        return self.section.count
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if incidentTypes!.count <= 0 {
            somethingWrongAlert()
            return 1
        }
        else {
        
        return self.items[section].count
        }
    }
    
    override func tableView(tableiew: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        
        return cell
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func somethingWrongAlert() {
        
        let alert = UIAlertController(title: "Oops!!", message: "Looks like you got here without actually reporting something. Go back!", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){ action in
            print("okay")
            let appDomain = NSBundle.mainBundle().bundleIdentifier!
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
            self.performSegueWithIdentifier("backToHomeSegue", sender: self)
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
        
        
    }
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
       let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        performSegueWithIdentifier("backToHomeSegue", sender: self)
        
        
    }
    
}
