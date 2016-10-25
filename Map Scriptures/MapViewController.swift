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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        
    }


}

