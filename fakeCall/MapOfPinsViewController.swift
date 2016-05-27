//
//  MapOfPinsViewController.swift
//  fakeCall
//
//  Created by Amy Giver on 5/27/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation




class MapOfPinsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapOfPins: MKMapView!
    
    var coordinates = [CLLocationCoordinate2D]()
    var incidentTitles = [String]()
    var dates = [String]()
    
//    func get_all_incidents(){
//    
//    let url = NSURL(string:"http://52.38.127.224/incidents/get_detailed_incidents")
//    let session = NSURLSession.sharedSession()
//    let task = session.dataTaskWithURL(url!, completionHandler: {
//        
//        data, response, error in
//        do {
//            
//            if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
//                print("all", jsonResult)
//            }
//        } catch
//        {
//            print("Something went wrong")
//        }
//    }) //close completion handler, url!
//    task.resume()
//    }


    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let url = NSURL(string:"http://52.38.127.224/incidents/get_detailed_incidents")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            
            data, response, error in
            do {
                
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                        if let incidents = jsonResult["all"] {
                            print("ALL DATAAAAAA", incidents)
                            
                      dispatch_async(dispatch_get_main_queue(), {
                        self.displayAlertMessage("This map is for entertainment purposes only. If you feel that you are in a real emergency, please contact your local police and for fuck's sake get your nose out of the app store.")
                            
                        print(incidents as? NSArray)
                            for incident in incidents as! NSArray {
                                if let latlong = incident["coordinates"] {
                                    
                                    if let uwlatlong = latlong {
                                        var latlongsplit = uwlatlong.componentsSeparatedByString(" ")
                                        
                                        var lat = latlongsplit[1]
                                        var long = latlongsplit[3]
                                        
                                        var trunclat = String(lat.characters.dropLast())
                                        var trunclong = String(long.characters.dropLast())
                                        
                                        var latdegrees = Double(trunclat)
                                        var longdegrees = Double(trunclong)
                                        var latdegreesReal : CLLocationDegrees = latdegrees!
                                        var longdegreesReal : CLLocationDegrees = longdegrees!
                                        var location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latdegreesReal, longdegreesReal)
                                        
                                        self.coordinates.append(location)
                                        
            
                                    }//closes if let uwlatlong
    
                                }//closes if let latlong
                               
                        
                            }//closes incident in incidents
                        for incident in incidents as! NSArray {
                            if let title = incident["title"] as? String{
                                self.incidentTitles.append(title)
                            }
                        }
                        for incident in incidents as! NSArray {
                            if let date = incident["date"] as? String {
                                self.dates.append(date)
                            }
                        }
                            }) //closes dispatch
                    }
                }
            } catch
            {
                print("Something went wrong")
            }
        }) //close completion handler, url!
        task.resume()
     //
//        var latitude: CLLocationDegrees = 48.399193
//        var longitude: CLLocationDegrees = 9.993341
//        
//        var latDelta: CLLocationDegrees = 0.01
//        var longDelta: CLLocationDegrees = 0.01
//        
//        var theSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
//        
//       
//        
//        
//        var churchLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
//        var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(churchLocation, theSpan)
//        self.mapOfPins.setRegion(theRegion, animated: true)
//        var theUlmMinsterAnnotation = MKPointAnnotation()
//        theUlmMinsterAnnotation.coordinate = churchLocation
//        theUlmMinsterAnnotation.title = "Ulm Minster"
//        theUlmMinsterAnnotation.subtitle = "A famous church in Germany"
//        self.mapOfPins.addAnnotation(theUlmMinsterAnnotation)
//        
//        var latitudes: CLLocationDegrees = 44.399193
//        var longitudes: CLLocationDegrees = 9.993341
//        
//        var somewhereElse: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudes, longitudes)
//        var theOtherRegion:MKCoordinateRegion = MKCoordinateRegionMake(somewhereElse, theSpan)
//        self.mapOfPins.setRegion(theOtherRegion, animated: true)
//        var theOtherAnnotation = MKPointAnnotation()
//        theOtherAnnotation.coordinate = somewhereElse
//        theOtherAnnotation.title = "Somewhere Else"
//        theOtherAnnotation.subtitle = "No idea"
//        self.mapOfPins.addAnnotation(theOtherAnnotation)
//        
        
        
        
    }
    
    
    func displayAlertMessage(userMessage: String) {
        var alert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default) {action in
            self.displayPins()
        }
        alert.addAction(okAction)
        self.presentViewController(alert, animated:true, completion:nil)
    }

    func displayPins() {
        print("Is this the aray??/",self.coordinates)
        var count = 0
        print("More arrays", self.dates, self.incidentTitles)
        for coordinate in coordinates {
            var latDelta: CLLocationDegrees = 0.01
            var longDelta: CLLocationDegrees = 0.01
            var theSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
            var location = coordinate
            var theRegion: MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
             self.mapOfPins.setRegion(theRegion, animated: true)
            var locationAnnotation = MKPointAnnotation()
            count += 1
            locationAnnotation.coordinate = location
            if count > self.incidentTitles.count-1 {
                locationAnnotation.title = "Incident"
            }
            else {
            locationAnnotation.title = self.incidentTitles[count]
            }
            if count > self.dates.count-1 {
                locationAnnotation.subtitle = "Something unpleasnat"
            }
            else {
            locationAnnotation.subtitle = self.dates[count]
            }
            self.mapOfPins.addAnnotation(locationAnnotation)

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func homeButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("backToHomeSegue", sender: self)
    }
    
}
