//
//  MapViewController.swift
//  Track
//
//  Created by Melissa Boring on 7/17/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import MapKit
import Firebase




class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoViewControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let cameraPicker = UIImagePickerController()
    let photoPicker = UIImagePickerController()
    
    let userPointAnnotation = MKPointAnnotation()
    var footprintArray = [Footprint]()
    var annotations = [MKPointAnnotation]()
    var selectedFootprint = Footprint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //must ask for permission to use location services
        //below combined with setting the NSLocationWhenInUseUsageDescription and NSLocationAlwaysUsageDescription keys in info.plist
        locationManager.delegate = self
        locationManager .requestWhenInUseAuthorization()
        locationManager .requestAlwaysAuthorization()
        
        mapView.delegate = self
        cameraPicker.delegate = self
        photoPicker.delegate = self
        
//        FirebaseHelper.sharedInstance.queryTracksByUid((FIRAuth.auth()?.currentUser?.uid)!)
//        
//        FirebaseHelper.sharedInstance.queryFootprintsByUid((FIRAuth.auth()?.currentUser?.uid)!)
        
        let newAnnotation = MKPointAnnotation()
    
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = 37.390749
        coordinate.longitude = -122.081651
        newAnnotation.coordinate = coordinate
        newAnnotation.title = "Acc Headquarters"
        newAnnotation.subtitle = "Mel is here!"
 
        annotations.append(newAnnotation)
        
    }
    
     // MARK: Location Manager
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status == .AuthorizedWhenInUse || status == .AuthorizedAlways){
            manager.startUpdatingLocation()
           mapView.showsUserLocation = true
            mapView.showsPointsOfInterest = true
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: Map View
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
       // let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800)
      //  mapView .setRegion(region, animated: true)
        
        
//        userPointAnnotation.coordinate = userLocation.coordinate
//        userPointAnnotation.title = "Where is Mel?"
//        userPointAnnotation.subtitle = "Mel is here!"
//        
//        mapView.addAnnotation(userPointAnnotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Don't want to show a custom image if the annotation is the user's location.
        guard !annotation.isKindOfClass(MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        
        let photoViewController = PhotoViewController()
        photoViewController.delegate = self
        photoViewController.footprint = selectedFootprint
        presentViewController(photoViewController, animated: true, completion: nil)
        
        
    }
    
    
    
    // MARK: Track 
    @IBAction func trackLocation(sender: UIBarButtonItem) {
        
        //alert controller with image picker , camera , cancel actions
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        
        //photo action
        let photoAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            action in
            
            self.photoPicker.sourceType = .PhotoLibrary
            self.presentViewController(self.photoPicker, animated: true, completion: nil)
        })
        
        //camera action
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            action in
            
            //check to see if camera is available (not available on simulator) and set the sourceType
            let isCameraAvailable = UIImagePickerController .isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
            
            self.cameraPicker.sourceType = (isCameraAvailable) ? .Camera : .PhotoLibrary
            self.presentViewController(self.cameraPicker, animated: true, completion: nil)
        })
        
        //cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: ImagePicker Delegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //set location coordinates for image
        if let location = locationManager.location{

            selectedFootprint.footprintImage = image
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            selectedFootprint.userPointAnnotation = annotation

            
        }
        

        dismissViewControllerAnimated(true) { () -> Void  in
            
            self.performSegueWithIdentifier("SetTrack", sender: nil)
        }

    }
    
    // MARK: PhotoViewControllerDelegate
    func addFootprint(sender: PhotoViewController) {
        //footprintArray.append(sender.footprint)
        annotations.append(sender.footprint.userPointAnnotation)
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)
    }
    
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "SetTrack"){
            
            let photoViewController:PhotoViewController = segue.destinationViewController as! PhotoViewController
            photoViewController.delegate = self
            photoViewController.footprint = selectedFootprint
            
            
        }

    }
}



