//
//  TestData.swift
//  Track
//
//  Created by Melissa Boring on 8/12/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import MapKit
import UIKit
import Foundation


class TestData {
    
    //test annotations
    var coordinate = CLLocationCoordinate2D()
    var coordinateA = CLLocationCoordinate2D()
    var coordinateB = CLLocationCoordinate2D()
    
    
    func loadData() {
        
        let track = Track(name: "Test Track", desc: "Test track for loading test data")
        firebaseHelper.createNewTrack(track)
        
        coordinate.latitude = 37.390749
        coordinate.longitude = -122.081651

        //test annotations
        let newAnnotation = FootprintAnnotation(coordinate: coordinate, image: UIImage())
        newAnnotation.title = "Acc Headquarters"
        newAnnotation.subtitle = "stuff is here!"
        newAnnotation.image = UIImage.init(imageLiteral: "blue.png")
        firebaseHelper.createNewFootprint(newAnnotation)
        
        
        coordinateA.latitude = 47.390749
        coordinateA.longitude = -102.081651
        let newAnnotationA = FootprintAnnotation(coordinate: coordinateA, image: UIImage())
        newAnnotationA.title = "A Headquarters"
        newAnnotationA.subtitle = "chocolate"
        newAnnotationA.image = UIImage.init(imageLiteral: "red.png")
        firebaseHelper.createNewFootprint(newAnnotationA)
        

        coordinateB.latitude = 45.390749
        coordinateB.longitude = -103.081651
        let newAnnotationB = FootprintAnnotation(coordinate: coordinateB, image: UIImage())
        newAnnotationB.title = "Purple Pie"
        newAnnotationB.subtitle = "tequila"
        newAnnotationB.image = UIImage.init(imageLiteral: "purple.png")
        firebaseHelper.createNewFootprint(newAnnotationB)
    
    }

}
