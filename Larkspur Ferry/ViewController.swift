//
//  file: ViewController.swift
//  Larkspur Ferry
//
//  Created by Gareth Jones on 11/23/15.
//  Copyright © 2015 gpj. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fromImage: UIImageView!
    @IBOutlet weak var toImage: UIImageView!
    @IBOutlet weak var fromText: UILabel!
    @IBOutlet weak var toText: UILabel!
    var f = "Larkspur"
    
    var locationUpdated = false
    
    let locationManager = CLLocationManager()
    var placemarks: [CLPlacemark]?
    var error: NSError?
    var items: [Ferry] = []
    @IBOutlet weak var tableViewCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("get location")
        findMyLocation()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        toImage.isUserInteractionEnabled = true
        toImage.addGestureRecognizer(tapGestureRecognizer)
        
        let fromtapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

        fromImage.isUserInteractionEnabled = true
        fromImage.addGestureRecognizer(fromtapGestureRecognizer)

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if self.f == "Larkspur" {
            self.f = "San Francisco"
            self.fromImage.image = UIImage(named:"sanfrancisco")
            self.toImage.image = UIImage(named:"marin")
        } else {
            self.f = "Larkspur"
            self.fromImage.image = UIImage(named:"marin")
            self.toImage.image = UIImage(named:"sanfrancisco")
        }
         getBoats()
    }
    
    // UITableView
    // Return rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    // UITableView
    // Return cell within tableview
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ferryCell") as! FerryCell

        let dateAsString = self.items[indexPath.row].depart
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        
        dateFormatter.dateFormat = "h:mm a"
        let date12 = dateFormatter.string(from: date!)
        
        cell.startTime?.text = date12
        cell.toLocation?.text = self.items[indexPath.row].from + " to " + self.items[indexPath.row].to
        cell.arrivalLabel?.text = "Arrival: " + self.items[indexPath.row].arrive
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "viewMap", sender: self)
    }
    
    // Start finding location
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // Display the location with placemark
    func displayLocationInfo(_ placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        if placemark.locality == "Larkspur" {
            self.fromImage.image = UIImage(named:"marin")
            self.toImage.image = UIImage(named:"sanfrancisco")
        } else {
            self.f = "San Francisco"
            self.fromImage.image = UIImage(named: "sanfrancisco")
            self.toImage.image = UIImage(named:"marin")
        }

        getBoats()
        
    }
    
    // Get the Boats from the API and then reload the table
    func getBoats() {
        // Get the times for the ferry
        API.sharedInstance.getTimes(from: f) { (boats) -> Void in
            self.items = boats
            //print(boats)
            self.tableView.reloadData()
        }
    }
    
    // LocationManager
    // Authentication Status Change
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            // authorized location status when app is in use; update current location
            locationManager.startUpdatingLocation()
            // implement additional logic if needed...
        }
        // implement logic for other status values if needed...
    }
    
    // LocationManager
    // UpdatedLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getBoats()
        print("Error while updating location " + error.localizedDescription)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

