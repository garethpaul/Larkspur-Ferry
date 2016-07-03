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
import UberRides

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var bottomMapOverlay: UIView!
    @IBOutlet weak var mapView: MKMapView!
    var initialLocation = CLLocation(latitude: 37.79984, longitude: -122.38921)
    let regionRadius: CLLocationDistance = 4200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        getLocation()
        let timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(MapViewController.getLocation), userInfo: nil, repeats: true)
        timer.fire()
        
        // Do any additional setup after loading the view.
    }
    
    func getLocation() {
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
            
            let cpa = annotation as! CustomPointAnnotation
            anView!.image = UIImage(named:cpa.imageName)
            
            return anView
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
