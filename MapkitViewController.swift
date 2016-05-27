//
//  MapkitViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/24/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation




class MapkitViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, CancelButtonDelegate{
    
    var incidentTitles = [String]()
    
    @IBOutlet weak var dropToComplete: UILabel!
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
    let reportingMode = NSUserDefaults.standardUserDefaults().boolForKey("isReportingLocation")
    
    @IBOutlet weak var reportButton: UIButton!

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "incidentSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! IncidentReportViewController
            controller.cancelButtonDelegate = self
        }
        if segue.identifier == "confirmationSegue"{
            print ("Helloooo")
        }
        
    }
    
    func cancelButtonPressedFrom(controller: UIViewController){
        dismissViewControllerAnimated(true, completion: nil)

    }

    
    @IBAction func reportButtonPressed(sender: UIButton) {
        if reportingMode == true {
            print("Submitting report")
            performSegueWithIdentifier("confirmationSegue", sender: self)
        }
        if reportingMode == false {
            print("Filing a report")
            performSegueWithIdentifier("incidentSegue", sender: self)
        }
        
        
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)

    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
       
        
        if reportingMode == true {
            self.reportButton.hidden = true
            self.reportButton.enabled = false
            self.dropToComplete.hidden = false
        
        if let incidentIDArray = NSUserDefaults.standardUserDefaults().arrayForKey("incidentsArray") {
            print("Incidents", incidentIDArray)
            
            self.incidentTitles = []
            
            for incident in incidentIDArray {
                
                
                let myURL = NSURL(string: "http://52.38.127.224/incidents/get_categories_by_id")
                let request = NSMutableURLRequest(URL:myURL!)
                request.HTTPMethod = "POST"
                
                let postString = "id=\(incident)"
                
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                    data, response, error in
                    if error != nil {
                        print("error = \(error)")
                        return
                    }
                    var err: NSError?
                    do {
                        if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary {
                            //                                    print("JSON time", jsonResult)
                            if let incidentTitle = jsonResult["category"] {
                                let finalIncident = incidentTitle["title"]!!
                                //                                    print("The title of the incident", finalIncident)
                                self.incidentTitles.append(String(finalIncident))
                                print("\n\n\nadded incident\n\n\n\(self.incidentTitles)\n\n")
                            }
                        }
                    }
                    catch {
                        print(error)
                    }
                    
                }
                task.resume()
                
            }
        }
        else {
            print("NO way")
        }
        }
        if reportingMode == false {
            self.reportButton.hidden = false
            self.reportButton.enabled = true
            self.dropToComplete.hidden = true
            
        }
        
    }
//

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //location delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
//    override func touchesBegan(touches:Set<UITouch>, withEvent event: UIEvent?) {
//        view.endEditing(true)
//        super.touchesBegan(touches, withEvent: event)
//        creeperTitle.resignFirstResponder()
//        let titleOfPin = creeperTitle.text
//        assignTitle(
//
//        
//        
//        
//
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func assignTitle(annotation: MKShape) {
        
        if let newIncidentType = NSUserDefaults.standardUserDefaults().stringForKey("newIncidentType") {
            if newIncidentType != "" {
            self.incidentTitles.append(newIncidentType)
            }
        }
        print("Elusive array", self.incidentTitles)
        
        NSUserDefaults.standardUserDefaults().setObject(incidentTitles, forKey: "incidentTitles")
        var titleString = ""
        for incident in incidentTitles {
            
                titleString += incident + " "
        
        }
       annotation.title = titleString
        self.reportButton.enabled = true
        self.reportButton.setTitle("Submit report", forState: .Normal)
    
        self.reportButton.hidden = false
        self.dropToComplete.hidden = true
        }
    
//
//        let myURL = NSURL(string: "http://52.38.127.224/incidents/get_categories")
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(myURL!, completionHandler: {
//            data, response, error in
//            do {
//                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
//                    if let results = jsonResult["all"]{
//                        let resultsArray = results as! NSArray
////                        let categoryToLookUp = resultsArray[sendertag - 1]
////                        categoryToLookUpTitle = categoryToLookUp["title"] as! String
////                        categoryToLookUpDesc = categoryToLookUp["descriptions"] as! String
////                        self.categoryAlert(categoryToLookUpTitle, description: categoryToLookUpDesc)
//                    }
//                }
//            } catch {
//                print("Something went wrong")
//            }
//        })
//        task.resume()
//
//        
//        
//        
//        
//        
//}
    
    @IBAction func dropPin(sender: UILongPressGestureRecognizer) {
        
        self.mapView.removeAnnotations(mapView.annotations)
        let location = sender.locationInView(self.mapView)
        let locCoord = self.mapView.convertPoint(location, toCoordinateFromView: self.mapView)
         NSUserDefaults.standardUserDefaults().setObject(String(locCoord), forKey: "locationCoords")
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCoord
        annotation.title = String(locCoord)
        self.mapView.addAnnotation(annotation)
        if reportingMode == true {
            assignTitle(annotation)
        }
        
    }


}
