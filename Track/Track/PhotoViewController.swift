//
//  PhotoViewController.swift
//  TrackAppPrototype
//
//  Created by Melissa Boring on 7/9/16.
//  Copyright © 2016 melbo. All rights reserved.
//
import UIKit
import MapKit

protocol PhotoViewControllerDelegate {
    func addFootprint(sender: PhotoViewController)
}

class PhotoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var footprintTextField: UITextField!
    
    //var footprint = Footprint()
    var footprintAnnotation = FootprintAnnotation(coordinate: CLLocationCoordinate2D(),image: UIImage())
    
    var delegate: PhotoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTextField.delegate = self
        footprintTextField.delegate = self
        
        trackedImageView.image = footprintAnnotation.image
        trackTextField.text = footprintAnnotation.title
        footprintTextField.text = footprintAnnotation.subtitle
        
    }

    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func add(sender: AnyObject) {
        
        footprintAnnotation.title = footprintTextField.text
        footprintAnnotation.subtitle = trackTextField.text
        
        //save the selected photo to the photolibrary
        UIImageWriteToSavedPhotosAlbum(footprintAnnotation.image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
        

    }
    

    
    func imageSaved(image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        if (error != nil) {
            // error - add a alertview
        } else {
            
            //save and get tag uid FootprintAnnotation
            FirebaseHelper.sharedInstance.createNewFootprint(footprintAnnotation)
            
            //upon successful save, call delegate
            delegate!.addFootprint(self)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    //dismiss keyboard on return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == footprintTextField){
            footprintTextField.resignFirstResponder()
        }else{
            trackTextField.resignFirstResponder()
        }
        return true
    }
}
