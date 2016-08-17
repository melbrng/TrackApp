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
    var selectedFootprint = Footprint(coordinate: CLLocationCoordinate2D(),image: UIImage())
    
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

    }
    

    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        let reference = firebaseHelper.FOOT_REF.child(firebaseHelper.currentUserUID!)
        
        // Loads and listens for new tracks
        reference.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            //Reset annotation array otherwise will get multiple copies of footprints
            self.annotations = [Footprint]()
            
            if (snapshot.exists()) {
                
                for footprint in snapshot.children {
                    
                    var coordinate = CLLocationCoordinate2D()
                    coordinate.latitude = footprint.value!["latitude"]!!.doubleValue
                    coordinate.longitude = footprint.value!["longitude"]!!.doubleValue
                    
                    let footprint = Footprint(coordinate: coordinate,
                        trackUID: footprint.value!["trackUID"] as! String,
                        footUID: footprint.value!["footUID"] as! String,
                        title: footprint.value!["title"] as! String,
                        subtitle: footprint.value!["subtitle"] as! String,
                        image: UIImage(),
                        imagePath: footprint.value!["imagePath"] as! String)
                    
                    //MARK: Repetitive-I don't want to retrieve AGAIN when adding a new Footprint
                    firebaseHelper.retrieveFootprintImage(footprint, completion: { (success) -> Void in
                        if success{
                            footprint.image = firebaseHelper.retrievedImage
                        }
                    })
                    
                    self.annotations.append(footprint)
                    
                }

            } else {
                print("No Snapshot?!")
            }

            self.mapView.addAnnotations(self.annotations)
        })

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
//    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
//        
//       // let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800)
//      //  mapView .setRegion(region, animated: true)
//        
//        userPointAnnotation.coordinate = userLocation.coordinate
//        userPointAnnotation.title = "Where is Mel?"
//        userPointAnnotation.subtitle = "Mel is here!"
//        
//        mapView.addAnnotation(userPointAnnotation)
//    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Don't want to show a custom image if the annotation is the user's location.
//        guard !annotation.isKindOfClass(MKUserLocation) else {
//            return nil
//        }
        
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
        
        self.performSegueWithIdentifier("SetTrack", sender: nil)
    
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
        
        //set location coordinates for image to current location
        if let location = locationManager.location{
            
            let footprint = Footprint(coordinate: location.coordinate, image: image)
            selectedFootprint = footprint

        }

        dismissViewControllerAnimated(true) { () -> Void  in
            
            self.performSegueWithIdentifier("SetTrack", sender: nil)
        }

    }
    
    // MARK: PhotoViewControllerDelegate
    func addFootprint(sender: PhotoViewController) {

        //prepare for reloading of footprints in ViewDidLoad
        mapView.removeAnnotations(annotations)


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



