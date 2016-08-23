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
    
    var annotations = [Footprint]()
    var selectedImage = UIImage()
    var updatedLocation = CLLocation()
    var selectedFootprint = Footprint(coordinate: CLLocationCoordinate2D(),image: UIImage())
    var userPointAnnotation = MKPointAnnotation()
    
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
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        UIToolbar.appearance().tintColor = UIColor.whiteColor()
        navigationController?.toolbar.translucent = false
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_nature_people2.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(self.trackLocation(_:)))
        
        let rightBarButtonImage : UIImage? = UIImage(named:"ic_person_outline.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightBarButtonImage, style: .Plain, target: self, action: #selector(self.profileButtonTouched(_:)))
        
        annotations = firebaseHelper.footprintArray
        mapView.addAnnotations(annotations)

    }
    

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)

    }
    
    @IBAction func profileButtonTouched(sender: AnyObject) {
        
        performSegueWithIdentifier("ShowProfile", sender: sender)
    }
     // MARK: Location Manager
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if(status == .AuthorizedWhenInUse || status == .AuthorizedAlways){
            mapView.showsUserLocation = true
            mapView.showsPointsOfInterest = true
            
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        if let updatedLocation = locations.last {
            
            //set location coordinates for image to current location

            let footprint = Footprint(coordinate: updatedLocation.coordinate, image: selectedImage)
            
            selectedFootprint = footprint
        
        }
        
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.description)
    }
    
    // MARK: Map View
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
        
        if let annotation = annotation as? Footprint {
        
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
        
        return nil
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        selectedFootprint = view.annotation as! Footprint
        
        self.performSegueWithIdentifier("ShowFootprint", sender: nil)
    
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
        

        selectedImage = image
        
        locationManager.requestLocation()


        dismissViewControllerAnimated(true) { () -> Void  in
            
            self.performSegueWithIdentifier("SetTrack", sender: nil)
        }
        

    }
    
    func reloadAnnotations(){
        
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)

    }
    
    // MARK: PhotoViewControllerDelegate
    func addFootprint(sender: PhotoViewController) {
        
        annotations.append(sender.footprint)
        
        reloadAnnotations()

        
    }
    
    
    // MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "SetTrack"){
            
            let photoViewController:PhotoViewController = segue.destinationViewController as! PhotoViewController
            photoViewController.delegate = self
            photoViewController.footprint = selectedFootprint
   
        }
        
        if(segue.identifier == "ShowFootprint"){
            
            let footprintViewController:FootprintViewController = segue.destinationViewController as! FootprintViewController

            footprintViewController.footprint = selectedFootprint
            
        }

    }
}



