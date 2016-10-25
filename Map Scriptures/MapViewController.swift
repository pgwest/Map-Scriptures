//
//  MapViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/22/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    //Mark: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // Mark: - View Controller lifecycel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        

        mapView.mapType = MKMapType.hybridFlyover

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2DMake(40.2506, -111.65247)
        annotation.title = "Tanner Building"
        annotation.subtitle = "BYU Campus"
        
        mapView.addAnnotation(annotation)
        
        
        let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake(40.2506, -111.65247), fromEyeCoordinate: CLLocationCoordinate2DMake(40.2406, -111.65247), eyeAltitude: 300)
        mapView.setCamera(camera, animated: true)
    }

    @IBAction func setMapRegion(_ sender: AnyObject) {
        let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(40.2506, -111.65247), MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    //Mark: - Map view delgate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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

}

