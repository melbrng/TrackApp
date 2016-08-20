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
        title = trackName
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return footprintsArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FootprintCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! FootprintTableViewCell
        
        cell.footprintNameLabel.text = footprintsArray[indexPath.row].title
        cell.footprintImageView.image = footprintsArray[indexPath.row].image
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "ShowFootprint"){
            
            let indexPath = tableView.indexPathForSelectedRow
            selectedFootprint = footprintsArray[indexPath!.item]
            
            let footprintViewController = segue.destinationViewController as! FootprintViewController
            footprintViewController.footprint = selectedFootprint

        }
    }

}
