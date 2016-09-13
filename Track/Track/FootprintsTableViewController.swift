//
//  FootprintsTableViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/19/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import MapKit

class FootprintsTableViewController: UITableViewController {
    
    var footprintsArray = [Footprint]()
    var trackName = ""
    var selectedFootprint = Footprint(coordinate: CLLocationCoordinate2D(), image: UIImage())
    
    override func viewDidLoad() {
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_arrow_back.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(cancelFootprints(_:)))

        title = trackName
        
        
    }

    @IBAction func cancelFootprints(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return footprintsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FootprintCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FootprintTableViewCell
        
        cell.footprintNameLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        cell.footprintNameLabel.textColor = UIColor.whiteColor()
        cell.footprintNameLabel.text = footprintsArray[indexPath.row].title
        
        cell.footprintImageView.image = footprintsArray[indexPath.row].image
        cell.footprintImageView.contentMode = .ScaleAspectFill
        cell.footprintImageView.frame = CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height)
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            
            print("deleting")
            footprintsArray.removeAtIndex(indexPath.item)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

            //will need to delete from Firebase
        }
        
    }
    
    //MARK: Segue 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "ShowFootprint"){
            
            let indexPath = tableView.indexPathForSelectedRow
            selectedFootprint = footprintsArray[indexPath!.item]
            
            let footprintViewController = segue.destinationViewController as! FootprintViewController
            footprintViewController.footprint = selectedFootprint

        }
    }

}


