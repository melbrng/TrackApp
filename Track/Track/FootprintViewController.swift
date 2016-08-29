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
    
    override func viewDidLoad() {

        footprintImageView.image = footprint.image
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_arrow_back.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(cancelFootprint(_:)))

    }
    
    @IBAction func cancelFootprint(sender: AnyObject) {
     self.navigationController?.popViewControllerAnimated(true)
    }
}
