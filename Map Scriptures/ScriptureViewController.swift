//
//  ScriptureViewController.swift
//  Map Scriptures
//
//  Created by Peter West on 10/24/16.
//  Copyright © 2016 Peter West. All rights reserved.
//

import UIKit
import WebKit
import MapKit

class ScriptureViewController : UIViewController, WKNavigationDelegate {
    
    //Mark: - Properties
    var book: Book!
    var chapter = 0
    
    private weak var mapViewController: MapViewController?
    private var webView: WKWebView!
    private var currentPath = ""
    
    // Mark: - View controller lifecycle
    
    override func loadView() {
        let webViewConfiguration = WKWebViewConfiguration()
        
        webViewConfiguration.preferences.javaScriptEnabled = false
        
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureDetailViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let html = ScriptureRenderer.sharedRenderer.htmlForBookId(book.id, chapter: chapter)
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    
    //Mark: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Map" {
            let navVC = segue.destination as? UINavigationController
            if let mapVC = navVC?.topViewController as? MapViewController {
                //NEEDSWORk: configure map view controller appropriately 

                let path = currentPath
                let index = path.index(path.startIndex, offsetBy: ScriptureRenderer.Constant.baseUrl.characters.count)
                let geoPlace = GeoDatabase.sharedGeoDatabase.geoPlaceForId(Int(path.substring(from: index))!)
                mapVC.title = book.fullName
                let currentAnnotation = MKPointAnnotation()
                
                currentAnnotation.coordinate = CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!)
                currentAnnotation.title = geoPlace?.placename
                currentAnnotation.subtitle = nil
                
                mapVC.currentRegion = CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!)
                
                
                
                /*
                
                mapVC.mapView.addAnnotation(currentAnnotation)
                
                let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!), fromEyeCoordinate: CLLocationCoordinate2DMake((geoPlace?.viewLatitude)!, (geoPlace?.viewLongitude)!), eyeAltitude: (geoPlace?.viewAltitude)!)
                mapVC.mapView.setCamera(camera, animated: true)
                */
            }
            
        }
    }
    
    
    
    //Mark: - Web kit navicgation delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let path = navigationAction.request.url?.absoluteString {
            if path.hasPrefix(ScriptureRenderer.Constant.baseUrl) {
                print("Request: \(path), mapViewController: \(mapViewController)")
                
                if let mapVC = mapViewController {
                    //Needswork: zoom in on tapped geoplace
                    print("setting mapVC to MapviewController")
                    let index = path.index(path.startIndex, offsetBy: ScriptureRenderer.Constant.baseUrl.characters.count)
                    let geoPlace = GeoDatabase.sharedGeoDatabase.geoPlaceForId(Int(path.substring(from: index))!)
                    mapVC.title = book.fullName
                    let currentAnnotation = MKPointAnnotation()
                    
                    currentAnnotation.coordinate = CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!)
                    currentAnnotation.title = geoPlace?.placename
                    currentAnnotation.subtitle = nil
                    
                    mapVC.currentRegion = CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!)
                    
                    mapVC.mapView.addAnnotation(currentAnnotation)
                    
                    let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!), fromEyeCoordinate: CLLocationCoordinate2DMake((geoPlace?.viewLatitude)!, (geoPlace?.viewLongitude)!), eyeAltitude: (geoPlace?.viewAltitude)!)
                    mapVC.mapView.setCamera(camera, animated: true)
                }
                else{
                    print("mapVC not set")
                    currentPath = path
                    performSegue(withIdentifier: "Show Map", sender: self)
                }
                
                decisionHandler(.cancel)
            }
        }
        
        decisionHandler(.allow)
        
    }
    
    
    // Mark: - helpers
    
    func configureDetailViewController() {
        
        if let splitVC = splitViewController {
            if let navVC = splitVC.viewControllers.last as? UINavigationController {
                mapViewController = navVC.topViewController as? MapViewController
                print("nav vc top")
            }
            else {
                mapViewController = splitVC.viewControllers.last as? MapViewController
                print("split vc last")
            }
        }
        else{
            mapViewController = nil
        }
        
        
    }
    
    
    
    
    
    
}


