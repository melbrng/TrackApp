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
    
    func isSelected(selected: Bool){
        if(selected){
            backgroundColor = UIColor .whiteColor().colorWithAlphaComponent(0.5)
            
        }else{
            backgroundColor = UIColor .whiteColor()
        }
    }
}
