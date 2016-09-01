//
//  TrackLayout.swift
//  Track
//
//  Created by Melissa Boring on 8/31/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit

protocol TrackLayoutDelegate {
    // 1 Photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath,
                        withWidth:CGFloat) -> CGFloat
    // 2 Annotation Height
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat
}

//subclass
class TrackLayoutAttributes: UICollectionViewLayoutAttributes {
    
    
    var photoHeight: CGFloat = 0.0
    
    // 2 mandatory -- attributes object can be copied internally, guarantee property is set when photo is copied
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! TrackLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    // 3 mandatory -- determines if attributes have changed
    //compares custom properties of subclass
    override func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? TrackLayoutAttributes {
            if( attributes.photoHeight == photoHeight  ) {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class TrackLayout: UICollectionViewLayout {
    
    
    // 1 Delegate reference
    var delegate: TrackLayoutDelegate!
    
    // 2 Configure layout
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    // 3 Keep the attributes
    private var cache = [TrackLayoutAttributes]()
    
    // 4 ContentHeight incremented as photos are added,
    private var contentHeight: CGFloat  = 0.0
    
    //width is based on the collection view width and its content inset
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
    }
    
    //use Pinterest layout attirbutes class
    override class func layoutAttributesClass() -> AnyClass {
        return TrackLayoutAttributes.self
    }
    
    /*
     To calculate the horizontal position, you’ll use the starting X coordinate of the column the item belongs to, and then add the cell padding.
     The vertical position is the starting position of the prior item in that column, plus the height of that prior item.
     The overall item height is the sum of the image height, the annotation height and the content padding.
     */
    
    //prepareLayout is called whenever the views layout is invalidated (change orientation, add/remove items)
    override func prepareLayout() {
        // 1 only calculate if cache is empty
        if cache.isEmpty {
            
            // 2 x-coordinate for every column based on column widths
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            // tracks y position for every column , initialize to 0 offset of first item in each column
            var column = 0
            var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: 0)
            
            // 3 loops through items in section (only 1 section)
            for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
                
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                
                // 4 frame calculation
                //previously calculated cellwidth with padding removed
                let width = columnWidth - cellPadding * 2
                
                //ask delegate for image and annotation height and predefined cellpadding for top and bottom
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath,
                                                          withWidth:width)
                let annotationHeight = delegate.collectionView(collectionView!,
                                                               heightForAnnotationAtIndexPath: indexPath, withWidth: width)
                let height = cellPadding +  photoHeight + annotationHeight + cellPadding
                
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                //inset frame used by asset
                let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
                
                // 5 append insetframe to attributes array
                let attributes = TrackLayoutAttributes(forCellWithIndexPath: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                // 6 frame of newly calculate item, advance yoffset for column based on frame
                contentHeight = max(contentHeight, CGRectGetMaxY(frame))
                yOffset[column] = yOffset[column] + height
                
                //advance column to next item will be placed in next column
                if(column >= (numberOfColumns - 1)){
                    column = 0
                }else{
                    column += 1
                }

            }
        }
    }
    
    //height and width of entire collection view content, not just visible content
    //uses to configure scroll view content size
    override func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    //called after prepareLayout to determine which items are visible in the given rect
    //iterate through attributes and check to see if their frames intersect with CV rect
    //if intersect, add attributes to layoutAttributes and return to CV
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}

