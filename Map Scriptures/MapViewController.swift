//
//  MapViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/22/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager?
    var annotationArray = [MKPointAnnotation]()
    var annotation = MKPointAnnotation()
    var currentRegion = CLLocationCoordinate2DMake(40.2506, -111.65247)
    var currentEyeCoordinate = CLLocationCoordinate2DMake(40.2406, -111.65247)
    var currentEyeAltitude = 300.0

    //Mark: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func setMapRegion(_ sender: AnyObject) {
        if (mapView.annotations.count > 1){
            var annotations = [MKAnnotation]()
            for annotation in mapView.annotations {
                if annotation is MKUserLocation {
                    
                } else {
                    annotations.append(annotation)
                }
            }
            mapView.showAnnotations(annotations, animated: true)
        }
        else {
            let region = MKCoordinateRegionMake(currentRegion, MKCoordinateSpanMake(2.0, 2.0))
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    // Mark: - View Controller lifecycel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        

        mapView.mapType = MKMapType.hybridFlyover

        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager!.startUpdatingLocation()
        } else {
            locationManager!.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView.removeFromSuperview()
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }


    
    //Mark: - Map view delgate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation){
            return nil
        }
        
        let reuseIdentifier = "Pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        

        if view == nil {
            
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            pinView.pinTintColor = UIColor.red
            
            view = pinView
            
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
    
    
    //Mark: - Location manager helpers
    // Adapted from http://stackoverflow.com/questions/35685006/how-i-can-center-the-map-on-users-location-in-swift
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
            //print("NotDetermined")
        case .restricted: break
            //print("Restricted")
        case .denied: break
            //print("Denied")
        case .authorizedAlways: break
            //print("AuthorizedAlways")
        case .authorizedWhenInUse:
            //print("AuthorizedWhenInUse")
            locationManager!.startUpdatingLocation()
        }
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if AppDelegate.firstLoad {
            let location = locations.first!
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.showsUserLocation = true
            locationManager?.stopUpdatingLocation()
            locationManager = nil
        }
        else{
            locationManager?.stopUpdatingLocation()
            locationManager = nil
        }
        AppDelegate.firstLoad = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to initialize GPS: ", error.localizedDescription)
    }

}

