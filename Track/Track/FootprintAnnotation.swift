//
//  FootprintAnnotation.swift
//  Track
//
//  Created by Melissa Boring on 8/9/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import MapKit

class FootprintAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var image: UIImage
    var title: String?
    var subtitle: String?
    var trackUID: String?
    var footprintUID: String?


    init(coordinate: CLLocationCoordinate2D, image: UIImage) {
        self.coordinate = coordinate
        self.image = image
    }
    

}
