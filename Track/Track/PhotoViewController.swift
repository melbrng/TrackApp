//
//  PhotoViewController.swift
//  TrackAppPrototype
//
//  Created by Melissa Boring on 7/9/16.
//  Copyright © 2016 melbo. All rights reserved.
//
import UIKit

protocol PhotoViewControllerDelegate {
    func addFootprint(sender: PhotoViewController)
}

class PhotoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var footprintTextField: UITextField!
    
    var footprint = Footprint()
    var delegate: PhotoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTextField.delegate = self
        footprintTextField.delegate = self
        
        trackedImageView.image = footprint.footprintImage
        
    }

    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func add(sender: AnyObject) {
        
        footprint.footprintPointAnnotation.title = footprintTextField.text
        footprint.footprintPointAnnotation.subtitle = trackTextField.text
        
        delegate!.addFootprint(self)
        self.navigationController?.popViewControllerAnimated(true)
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
