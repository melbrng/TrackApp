//
//  ProfileViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/18/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UICollectionViewController{
    
    var trackArray = firebaseHelper.trackArray
    var trackFootprints = [Footprint]()
    var editModeOn = false
    
    @IBOutlet weak var trackCollectionView: UICollectionView!

    override func viewDidLoad() {
        
        //TODO: Add Cell Editing Management
        
        if let layout = trackCollectionView?.collectionViewLayout as? TrackLayout {
            layout.delegate = self
        }
        
        
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_arrow_back.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(cancelProfile(_:)))
        
        updateRighBarButton(editModeOn)

    }
    
    //MARK: Nav Buttons
    func updateRighBarButton(isEditModeOn : Bool){
        let editModeButton = UIButton(frame: CGRectMake(0,0,30,30))
        editModeButton.addTarget(self, action: #selector(editTracks(_:)), forControlEvents: .TouchUpInside)
        
        
        if isEditModeOn {
            editModeButton.setImage(UIImage(named: "ic_mode_edit_on.png"), forState: .Normal)
        } else {
            editModeButton.setImage(UIImage(named: "ic_mode_edit.png"), forState: .Normal)
        }
        
        let rightButton = UIBarButtonItem(customView: editModeButton)
        self.navigationItem.setRightBarButtonItems([rightButton], animated: true)
    }
    
    @IBAction func editTracks(sender: AnyObject) {
        
        editModeOn = !editModeOn
        
        print("editMode: \(editModeOn)")
        
        if editModeOn {
            editTracksEnabled()
        } else {
            editTracksDisabled()
        }
        
        updateRighBarButton(editModeOn)
        
    }
    
    func editTracksEnabled()
    {
        
        print("editing")
        
        trackCollectionView.allowsMultipleSelection = true
    }
    
    func editTracksDisabled(){
        
          print("notEditing")
        
        trackCollectionView.allowsMultipleSelection = false
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
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        return !editModeOn

    }

    //MARK: Collection View Delegate
        
        override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return trackArray.count
        }
        
       
        override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            let cellIdentifier = "TrackCell"
            
            let cell = collectionView .dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ProfileCollectionViewCell
            
            cell.trackLabel.text = trackArray[indexPath.item].trackName
            cell.trackImageView.image = trackArray[indexPath.item].trackImage
            
            return cell
        }
        
        override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

            print("cell selected")
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
            cell.isSelected(true)
            
            //collectionView.deleteItemsAtIndexPaths([indexPath])
            
            //trackArray.removeAtIndex(indexPath.item)
        }
    

        override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
            
            print("cell highlighted")
            
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
            
            UIView.animateWithDuration(0.1,
                                       delay: 0,
                                       options: .AllowUserInteraction,
                                       animations: {
                                        cell.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(1.0)},
                                       completion: nil)
        }
       
    }

    //MARK: Track Layout protocol
    extension ProfileViewController : TrackLayoutDelegate {
        
        // 1 AVFoundation to calculate a height that retains the photo’s aspect ratio, restricted to the cell’s width.
        func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath,
                            withWidth width: CGFloat) -> CGFloat {
            let photo = trackArray[indexPath.item].trackImage
            let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            
            //Makes your image view fill the real estate you have available on your phones screen
            let rect  = AVMakeRectWithAspectRatioInsideRect(photo.size, boundingRect)
            
            return rect.size.height
        }
        
        // 2 calculates the height of the photo’s comment based on the given font and the cell’s width
        func collectionView(collectionView: UICollectionView,
                            heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
            let annotationPadding = CGFloat(4)
            let annotationHeaderHeight = CGFloat(17)
     
            let comment = trackArray[indexPath.item].trackName
            let font = UIFont(name: "HelveticaNeue-Thin", size: 10)!
            
            let rect = NSString(string: comment).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
            
            let commentHeight = ceil(rect.height)
            let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
            
            return height
        }
    }
