//
//  MapViewController.swift
//  Larkspur Ferry
//
//  Created by Gareth Jones on 11/28/15.
//  Copyright © 2015 gpj. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var initialLocation = CLLocation(latitude: 37.79984, longitude: -122.38921)
    let regionRadius: CLLocationDistance = 4200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        getLocation()
        let timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: Selector("getLocation"), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    func getLocation() {
        print("getting location")
        // remove locations if they exist
        if self.mapView.annotations.count == 1 {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
        
        API.sharedInstance.getLocation({ (location) -> Void in
                self.initialLocation = location
                self.centerMapOnLocation(self.initialLocation)
                let info1 = CustomPointAnnotation()
                info1.coordinate = CLLocationCoordinate2DMake(self.initialLocation.coordinate.latitude, self.initialLocation.coordinate.longitude)

                info1.title = "Larkspur Ferry"
                info1.subtitle = ""
                info1.imageName = "boatLogo"
                self.mapView.addAnnotation(info1)
        })
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView,
        viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            
            print("delegate called")
            
            if !(annotation is CustomPointAnnotation) {
                return nil
            }
            
            let reuseId = "test"
            
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                anView!.canShowCallout = true
            }
            else {
                anView!.annotation = annotation
            }
            
            //Set annotation-specific properties **AFTER**
            //the view is dequeued or created...
            
            let cpa = annotation as! CustomPointAnnotation
            anView!.image = UIImage(named:cpa.imageName)
            
            return anView
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
