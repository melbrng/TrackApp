//
//  Track.swift
//  TrackAppPrototype
//
//  Created by Melissa Boring on 7/10/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Track {
    
    var trackImage = UIImage()
    var trackName: String
    var trackDescription: String
    var trackUID: String?
    var trackImagePath: String?
    
    init(name: String, desc: String) {
        self.trackName = name
        self.trackDescription = desc
    }

    init(name: String, desc: String, image: UIImage, imagePath: String) {
        self.trackName = name
        self.trackDescription = desc
        self.trackImage = image
        self.trackImagePath = imagePath
    }
    
    init(name: String, desc: String, uid: String, imagePath: String) {
        self.trackName = name
        self.trackDescription = desc
        self.trackUID = uid
        self.trackImagePath = imagePath
    }
    
}
