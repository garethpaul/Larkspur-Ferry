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


    @IBOutlet weak var bottomMapOverlay: UIView!
    @IBOutlet weak var mapView: MKMapView!
    var initialLocation = CLLocation(latitude: 37.79984, longitude: -122.38921)
    let regionRadius: CLLocationDistance = 4200
    var locationRefreshTimer: Timer?
    private var isMapVisible = false
    private var locationRequestRevision = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isMapVisible = true
        startLocationRefreshTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isMapVisible = false
        locationRequestRevision += 1
        locationRefreshTimer?.invalidate()
        locationRefreshTimer = nil
    }

    func startLocationRefreshTimer() {
        locationRefreshTimer?.invalidate()
        locationRefreshTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(MapViewController.getLocation), userInfo: nil, repeats: true)
        locationRefreshTimer?.fire()
    }

    func getLocation() {
        locationRequestRevision += 1
        let requestedLocationRevision = locationRequestRevision
        API.sharedInstance.getLocation(completion: { [weak self] (location) -> Void in
            guard let location = location else {
                return
            }

            DispatchQueue.main.async {
                guard let viewController = self,
                    viewController.isMapVisible,
                    acceptsFerryLocationResponse(
                        requestedRevision: requestedLocationRevision,
                        currentRevision: viewController.locationRequestRevision
                    ) else {
                    return
                }

                viewController.removeExistingFerryAnnotations()
                viewController.initialLocation = location
                viewController.centerMapOnLocation(viewController.initialLocation)
                let info1 = CustomPointAnnotation()
                info1.coordinate = CLLocationCoordinate2DMake(
                    viewController.initialLocation.coordinate.latitude,
                    viewController.initialLocation.coordinate.longitude
                )

                info1.title = "Larkspur Ferry"
                info1.subtitle = ""
                info1.imageName = "boatLogo"
                viewController.mapView.addAnnotation(info1)
            }
        })
    }

    func removeExistingFerryAnnotations() {
        let ferryAnnotations = mapView.annotations.filter { $0 is CustomPointAnnotation }
        mapView.removeAnnotations(ferryAnnotations)
    }

    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func mapView(_ mapView: MKMapView,
        viewFor annotation: MKAnnotation) -> MKAnnotationView? {

            if !(annotation is CustomPointAnnotation) {
                return nil
            }

            let reuseId = "test"

            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView.canShowCallout = true
            annotationView.annotation = annotation

            guard let cpa = annotation as? CustomPointAnnotation else {
                return annotationView
            }
            annotationView.image = UIImage(named:cpa.imageName)

            return annotationView
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
