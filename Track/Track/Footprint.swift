//
//  Footprint.swift
//  Track
//
//  Created by Melissa Boring on 8/9/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import MapKit

class Footprint: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var image: UIImage?
    var title: String?
    var subtitle: String?
    var trackUID: String?
    var footprintUID: String?
    var imagePath: String?


    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.coordinate = coordinate
        self.image = image
    }
    
    init(coordinate: CLLocationCoordinate2D, trackUID: String, footUID: String, title: String, subtitle: String, image: UIImage, imagePath: String) {
        self.coordinate = coordinate
        self.trackUID  = trackUID
        self.footprintUID = footUID
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.imagePath = imagePath
    
    }
    

}
