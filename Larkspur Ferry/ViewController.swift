//
//  ViewController.swift
//  Larkspur Ferry
//
//  Created by Gareth Jones on 11/23/15.
//  Copyright © 2015 gpj. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromImage: UIImageView!
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var fromText: UILabel!
    @IBOutlet weak var toText: UILabel!
    
    var locationUpdated = false
    
    let locationManager = CLLocationManager()
    var placemarks: [CLPlacemark]?
    var error: NSError?
    var items: [Ferry] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("get location")
        findMyLocation()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // UITableView
    // Return rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    // UITableView
    // Return cell within tableview
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let dateAsString = self.items[indexPath.row].depart
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.dateFromString(dateAsString)
        
        dateFormatter.dateFormat = "h:mm a"
        let date12 = dateFormatter.stringFromDate(date!)
        
        cell.textLabel?.text = date12
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("viewMap", sender: self)
    }
    
    
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()

        var f = "Larkspur"
        //
        if placemark.locality == "Larkspur" {
            self.fromImage.image = UIImage(named:"marin")
            self.toImage.image = UIImage(named:"sanfrancisco")
        } else {
            f = "San Francisco"
            self.fromImage.image = UIImage(named: "sanfrancisco")
            self.toImage.image = UIImage(named:"marin")
        }
        
        // Get the times for the ferry
        API.sharedInstance.getTimes(f) { (boats) -> Void in
            self.items = boats
            print(boats)
            self.tableView.reloadData()
        }
        
    }
    
    // LocationManager
    // Authentication Status Change
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            // authorized location status when app is in use; update current location
            locationManager.startUpdatingLocation()
            // implement additional logic if needed...
        }
        // implement logic for other status values if needed...
    }
    
    // LocationManager
    // UpdatedLocations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }

        }
    }
    
    // Location Manager
    // Failed with Error
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

