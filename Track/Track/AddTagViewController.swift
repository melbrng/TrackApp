//
//  AddTagViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/26/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import MapKit

protocol AddTagViewControllerDelegate {
    func addTag(sender: AddTagViewController)
}

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class AddTagViewController: UIViewController{
    
    var delegate: AddTagViewControllerDelegate?
    var selectedPin:MKPlacemark? = nil
    let request = MKLocalSearchRequest()
    var searchController: UISearchController!
    let locationManager = CLLocationManager()
    var selectedAnnotation:MKAnnotation? = nil
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tagMapView: MKMapView!
    
    @IBOutlet weak var tagSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        tagMapView.delegate = self
        
        //set up the search results VC
        let tagSearchTableViewController = storyboard!.instantiateViewControllerWithIdentifier("TagSearchTableViewController") as! TagSearchTableViewController
        searchController = UISearchController(searchResultsController: tagSearchTableViewController)
        searchController?.searchResultsUpdater = tagSearchTableViewController
        
        //set up the search bar and embed in the nav bar
        let searchBar = searchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = searchController?.searchBar
        
        //search controller appearance
        //want search bar accessible at all times
        searchController.hidesNavigationBarDuringPresentation = false
        
        //gives modal overlay semi-transparent background
        searchController.dimsBackgroundDuringPresentation = true
        
        //limits overlap area to VC frame instead of entire nav controller
        definesPresentationContext = true
        
        //pass along the handle of the tagMapView onto the tagSearchTVC
        tagSearchTableViewController.mapView = tagMapView
        
        tagSearchTableViewController.handleMapSearchDelegate = self
        
        
        let rightBarButtonImage : UIImage? = UIImage(named:"ic_not_interested.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightBarButtonImage, style: .Plain, target: self, action: #selector(cancelAddTag(_:)))
        
        
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func cancelAddTag(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }


}

    extension AddTagViewController : CLLocationManagerDelegate {
        func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            if status == .AuthorizedWhenInUse {
                locationManager.requestLocation()
            }
        }
        
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                //print(location)
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: location.coordinate,span: span)
                tagMapView.setRegion(region, animated: true)
            }
        }
        
        func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print(error)
        }
    }

    extension AddTagViewController: HandleMapSearch {
        func dropPinZoomIn(placemark:MKPlacemark){
            
            // cache the pin
            selectedPin = placemark
            
            // clear existing pins
            tagMapView.removeAnnotations(tagMapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = String(city + " " + state)
            }
            tagMapView.addAnnotation(annotation)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            tagMapView.setRegion(region, animated: true)
        }
    }


    extension AddTagViewController : MKMapViewDelegate {
        func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{

            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            
            if annotation is MKUserLocation {
                pinView?.pinTintColor = UIColor.blueColor()
            } else {
                pinView?.pinTintColor = UIColor.greenColor()
            }
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true

            return pinView
        }
        
        func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
            print("selected " + ((view.annotation?.title)!)!)
            selectedAnnotation = view.annotation
            delegate?.addTag(self)
            self.navigationController?.popViewControllerAnimated(true)
        }
}