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

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var footprintTextField: UITextField!
    
    var footprint = Footprint()
    var delegate: PhotoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackedImageView.image = footprint.footprintImage
        
    }

    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func add(sender: AnyObject) {
        
//        footprint.userPointAnnotation.title = footprintTextField.text
//        footprint.userPointAnnotation.subtitle = trackTextField.text
        
        footprint.userPointAnnotation.title = "Title"
        footprint.userPointAnnotation.subtitle = "subtitle"
        
        delegate!.addFootprint(self)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
