//
//  UIImage+Resize.swift
//  Track
//
//  Created by Melissa Boring on 8/31/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit

extension UIImage {
    
    var decompressedImage: UIImage {

        UIGraphicsBeginImageContextWithOptions(size, true, 0)

        drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return decompressedImage
    }
    
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}
