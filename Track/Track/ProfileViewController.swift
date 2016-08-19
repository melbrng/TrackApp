//
//  ProfileViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/18/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let trackArray = firebaseHelper.trackArray
    var trackFootprints = [Footprint]()
    
    @IBOutlet weak var trackCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
//        trackCollectionView.delegate = self
//        trackCollectionView.dataSource = self
        
        print(trackArray.count)
    }
    
    
    
    //MARK: Collection View Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width/3.2, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = "TrackCell"
        
        let cell = collectionView .dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) 

        let trackImageView = cell.viewWithTag(100) as! UIImageView
        trackImageView.image = trackArray[indexPath.item].trackImage

        cell.backgroundColor = UIColor .grayColor()
        
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        
//        let trackUID = trackArray[indexPath.item].trackUID
// 
//        trackFootprints = firebaseHelper.footprintArray.filter{ ($0.trackUID) == trackUID}
//        
//        for x in trackFootprints{
//            
//            let fp = x 
//            print(fp.title)
//            
//        }
//
//        
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "ShowFootprints"){
            
            let indexPaths = trackCollectionView.indexPathsForSelectedItems()
            
            let indexPath = indexPaths![0]
           // print("selected: " + String(indexPath.item))
            
            let trackUID = trackArray[indexPath.item].trackUID
            
            trackFootprints = firebaseHelper.footprintArray.filter{ ($0.trackUID) == trackUID}
            
            let destinationTableViewController = segue.destinationViewController as! FootprintsTableViewController
            
            destinationTableViewController.footprintsArray = trackFootprints
            
        }
    }

}
