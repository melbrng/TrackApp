//
//  ProfileViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/18/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import QuartzCore

class ProfileViewController: UIViewController{
    
    var trackArray = firebaseHelper.trackArray
    var trackFootprints = [Footprint]()
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var trackCollectionView: UICollectionView!
    //@IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        
        //remove "Add New Track" track
        trackArray.removeAtIndex(0)
        let rightBarButtonImage : UIImage? = UIImage(named:"ic_mode_edit.png")!.imageWithRenderingMode(.AlwaysOriginal)
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_arrow_back.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(cancelProfile(_:)))
        
        navigationItem.rightBarButtonItem =
            UIBarButtonItem.init(image: rightBarButtonImage, style: .Plain, target: self, action: #selector(editTracks(_:)))
        
        collectionViewFlowLayout.scrollDirection = .Vertical
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
//        profileImageView.layer.backgroundColor=UIColor.clearColor().CGColor
//        profileImageView.layer.cornerRadius=40
//        profileImageView.layer.borderWidth=1.0
//        profileImageView.layer.masksToBounds = true
//        profileImageView.layer.borderColor = UIColor.grayColor().CGColor

    }
    
    //MARK: UI
    @IBAction func editTracks(sender: AnyObject) {
        trackCollectionView.allowsMultipleSelection = true
    }
    
    
    @IBAction func cancelProfile(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "ShowFootprints"){
            
            let indexPaths = trackCollectionView.indexPathsForSelectedItems()
            
            let indexPath = indexPaths![0]
            
            let trackUID = trackArray[indexPath.item].trackUID
            
            trackFootprints = firebaseHelper.footprintArray.filter{ ($0.trackUID) == trackUID}
            
            let destinationTableViewController = segue.destinationViewController as! FootprintsTableViewController
            
            destinationTableViewController.trackName = trackArray[indexPath.item].trackName
            destinationTableViewController.footprintsArray = trackFootprints
            
            }
        }
    
    }

    //MARK: Collection View Delegate
    extension ProfileViewController:UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return trackArray.count
        }
        
       
        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
        {

            
            let totalwidth = collectionView.bounds.size.width;
            let numberOfCellsPerRow = 3
            let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
            return CGSizeMake(dimensions, dimensions)


        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cellIdentifier = "TrackCell"
            
            let cell = collectionView .dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProfileCollectionViewCell
            
            cell.trackLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            cell.trackLabel.textColor = UIColor.whiteColor()
            cell.trackLabel.text = trackArray[indexPath.item].trackName
     
            cell.trackImageView.image = trackArray[indexPath.item].trackImage
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.blackColor() .CGColor
            cell.backgroundColor = UIColor .whiteColor()
            
            return cell
        }
        
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
            cell.isSelected(true)
            
            //collectionView.deleteItemsAtIndexPaths([indexPath])
            
            //trackArray.removeAtIndex(indexPath.item)
        }
        

        func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
            
            UIView.animateWithDuration(0.1,
                                       delay: 0,
                                       options: .AllowUserInteraction,
                                       animations: {
                                        cell.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)},
                                       completion: nil)
        }
       
    }
