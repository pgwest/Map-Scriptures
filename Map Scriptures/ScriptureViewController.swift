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
    var chapter = 1
    private weak var mapViewController: MapViewController?
    private var webView: WKWebView!
    private var currentPath = ""
    private var annotationArray = [MKPointAnnotation]()
    static private var mapView = MKMapView()
    
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

        annotationArray = [MKPointAnnotation]()
        for geoPlace in ScriptureRenderer.sharedRenderer.collectedGeocodedPlaces {
            let currentAnnotation = MKPointAnnotation()
            currentAnnotation.coordinate = CLLocationCoordinate2DMake((geoPlace.latitude), (geoPlace.longitude))
            currentAnnotation.title = geoPlace.placename
            currentAnnotation.subtitle = nil
            annotationArray.append(currentAnnotation)
           // mapVC.mapView.addAnnotation(currentAnnotation)
        }
        webView.loadHTMLString(html, baseURL: nil)
        
    }
    
    
    //Mark: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Map" {
            let navVC = segue.destination as? UINavigationController
            if let mapVC = navVC?.topViewController as? MapViewController {

                //NEEDSWORk: pins not showing up :(

                let path = currentPath
                let index = path.index(path.startIndex, offsetBy: ScriptureRenderer.Constant.baseUrl.characters.count)
                let geoPlace = GeoDatabase.sharedGeoDatabase.geoPlaceForId(Int(path.substring(from: index))!)
                mapVC.title = book.fullName

                mapVC.currentRegion = CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!)
                mapVC.currentEyeCoordinate = CLLocationCoordinate2DMake((geoPlace?.viewLatitude)!, (geoPlace?.viewLongitude)!)
                mapVC.currentEyeAltitude = (geoPlace?.viewAltitude)!
                
                //load view so mapview isn't nil
                let view = mapVC.view
                if (view != nil){
                    //view = nil
                }

                configureDetailViewController()
                
                for annotation in annotationArray {
                    mapVC.mapView.addAnnotation(annotation)
                }
                mapVC.mapView.showAnnotations(annotationArray, animated: true)


                let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!), fromEyeCoordinate: CLLocationCoordinate2DMake((geoPlace?.viewLatitude)!, (geoPlace?.viewLongitude)!), eyeAltitude: (geoPlace?.viewAltitude)!)
                mapVC.mapView.setCamera(camera, animated: true)
 
            }
            
        }
    }
    
    
    
    //Mark: - Web kit navigation delegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let path = navigationAction.request.url?.absoluteString {
            if path.hasPrefix(ScriptureRenderer.Constant.baseUrl) {
                print("Request: \(path), mapViewController: \(mapViewController)")
                
                if let mapVC = mapViewController {
                    
                    let index = path.index(path.startIndex, offsetBy: ScriptureRenderer.Constant.baseUrl.characters.count)
                    let geoPlace = GeoDatabase.sharedGeoDatabase.geoPlaceForId(Int(path.substring(from: index))!)
                    mapVC.title = book.fullName
                   
                    mapVC.currentRegion = CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!)
                    mapVC.currentEyeCoordinate = CLLocationCoordinate2DMake((geoPlace?.viewLatitude)!, (geoPlace?.viewLongitude)!)
                    mapVC.currentEyeAltitude = (geoPlace?.viewAltitude)!
                    
                    let camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2DMake((geoPlace?.latitude)!, (geoPlace?.longitude)!), fromEyeCoordinate: CLLocationCoordinate2DMake((geoPlace?.viewLatitude)!, (geoPlace?.viewLongitude)!), eyeAltitude: (geoPlace?.viewAltitude)!)
                    mapVC.mapView.setCamera(camera, animated: true)
                }
                else{
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
                if mapViewController?.mapView != nil {
                    let allAnnotations = mapViewController?.mapView.annotations
                    mapViewController?.mapView.removeAnnotations(allAnnotations!)
                    for annotation in annotationArray {
                          mapViewController?.mapView.addAnnotation(annotation)
                        
                            mapViewController?.mapView.showAnnotations(annotationArray, animated: true)
                    }
                }

            }
            else {
                mapViewController = splitVC.viewControllers.last as? MapViewController
                print("else")
            }
        }
        else{
            mapViewController = nil
            print("mapview controller")
        }
        
        
    }

    
    
    
    
}


