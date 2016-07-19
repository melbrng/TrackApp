//
//  MapViewController.swift
//  Track
//
//  Created by Melissa Boring on 7/17/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager = CLLocationManager()
    let cameraPicker = UIImagePickerController()
    let photoPicker = UIImagePickerController()
    
    let userPointAnnotation = MKPointAnnotation()
    var selectedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //must ask for permission to use location services
        //below combined with setting the NSLocationWhenInUseUsageDescription and NSLocationAlwaysUsageDescription keys in info.plist
        locationManager.delegate = self
        locationManager .requestWhenInUseAuthorization()
        locationManager .requestAlwaysAuthorization()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsPointsOfInterest = true
        
        cameraPicker.delegate = self
        photoPicker.delegate = self
        
    }
    
    // MARK : Map User location
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800)
        mapView .setRegion(region, animated: true)
        
        
        userPointAnnotation.coordinate = userLocation.coordinate
        userPointAnnotation.title = "Where is Mel?"
        userPointAnnotation.subtitle = "Mel is here!"
        
        mapView.addAnnotation(userPointAnnotation)
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
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView {
            // Configure your annotation view here
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "")
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        
        let photoViewController = PhotoViewController()
        presentViewController(photoViewController, animated: true, completion: nil)
        
    }
    
    
    
    // MARK : Track by Photo
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
    
    // MARK : ImagePicker Delegates
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        selectedImage = image

        dismissViewControllerAnimated(true) { () -> Void  in
            
            self.performSegueWithIdentifier("ShowTrack", sender: nil)
        }
        
            

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "ShowTrack"){
            
            let photoViewController:PhotoViewController = segue.destinationViewController as! PhotoViewController
            photoViewController.trackedImage = selectedImage
            
            
        }
    }
}



