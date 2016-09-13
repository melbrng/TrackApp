//
//  FootprintViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/19/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import MapKit


class FootprintViewController: UIViewController {

    @IBOutlet weak var footprintImageView: UIImageView!
    var footprint = Footprint(coordinate: CLLocationCoordinate2D(), image: UIImage())
    var footprintMapView = MKMapView()
    
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    @IBAction func handlePinchGesture(sender: UIPinchGestureRecognizer) {

        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale);
        sender.scale = 1;
    }
    override func viewDidLoad() {

        footprintImageView.image = footprint.image
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_arrow_back.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(cancelFootprint(_:)))
        let rightBarButtonImage : UIImage? = UIImage(named:"ic_place2x.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightBarButtonImage, style: .Plain, target: self, action: #selector(showFootprintMap(_:)))

        footprintImageView.addGestureRecognizer(pinchGesture)
        createFootprintMapViewPicker()
        
    }
    
    @IBAction func cancelFootprint(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func showFootprintMap(sender: AnyObject) {
        footprintMapView.hidden ? openTable() : closeTable()
    }
    
    
    func createFootprintMapViewPicker(){
        
        footprintMapView.frame = CGRect(x: 0, y: 0, width: 286, height: 291)
        footprintMapView.alpha = 0
        footprintMapView.hidden = true
        footprintMapView.userInteractionEnabled = true
        footprintMapView.showsPointsOfInterest = true
        
        let region = MKCoordinateRegionMakeWithDistance(footprint.coordinate, 1500, 1500)
        footprintMapView .setRegion(region, animated: true)
        
        footprintMapView.delegate = self
        
        footprintMapView.addAnnotations([footprint])
        
        self.view.addSubview(footprintMapView)
        
    }
    
    func openTable()
    {
        self.footprintMapView.hidden = false
        
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.footprintMapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
                                    self.footprintMapView.alpha = 1
        })
    }
    
    func closeTable()
    {
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.footprintMapView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
                                    self.footprintMapView.alpha = 0
            },
                                   completion: { finished in
                                    self.footprintMapView.hidden = true
            }
        )
    }
}

extension FootprintViewController:MKMapViewDelegate{
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? Footprint {
            
            let annotationIdentifier = "AnnotationIdentifier"
            
            var annotationView: MKAnnotationView?
            
            if let dequeuedAnnotationView = footprintMapView.dequeueReusableAnnotationViewWithIdentifier(annotationIdentifier) {
                annotationView = dequeuedAnnotationView
                annotationView?.annotation = annotation
            }
            else {
                let av = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
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
    
//    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        
//        selectedFootprint = view.annotation as! Footprint
//        
//    }
    
    
}
