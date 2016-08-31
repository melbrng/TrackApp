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
            print(size)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        //UIGraphicsBeginImageContextWithOptions(CGSizeMake(480,320), true, 0)
        drawAtPoint(CGPointZero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("decompressedImage")
        print(decompressedImage.size)
        return decompressedImage
    }
    

}
