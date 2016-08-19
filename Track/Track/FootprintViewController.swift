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
    }
}
