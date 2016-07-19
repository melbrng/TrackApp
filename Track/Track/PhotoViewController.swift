//
//  PhotoViewController.swift
//  TrackAppPrototype
//
//  Created by Melissa Boring on 7/9/16.
//  Copyright © 2016 melbo. All rights reserved.
//
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    var trackedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackedImageView.image = trackedImage

    }

}
