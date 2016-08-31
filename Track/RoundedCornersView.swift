//
//  RoundedCornersView.swift
//  Track
//  How cool is this! @IBDesignable allows me to modify the layout at design time
//  Created by Melissa Boring on 8/31/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedCornersView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

}
