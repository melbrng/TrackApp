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
    

}
