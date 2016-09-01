//
//  ProfileCollectionViewCell.swift
//  Track
//
//  Created by Melissa Boring on 8/19/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var trackImageViewLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var footprintCountLabel: UILabel!
    
    func isSelected(selected: Bool){
        if(selected){
            backgroundColor = UIColor .whiteColor().colorWithAlphaComponent(0.5)
            
        }else{
            backgroundColor = UIColor .whiteColor()
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        //call super to make sure standard attributes are applied
        super.applyLayoutAttributes(layoutAttributes)
        
        //cast to pinterest and change image view height
        if let attributes = layoutAttributes as? TrackLayoutAttributes {
            trackImageViewLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
