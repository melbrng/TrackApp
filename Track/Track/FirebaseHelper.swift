//
//  FirebaseHelper.swift
//  Track
//
//  Created by Melissa Boring on 7/18/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import Foundation
import Firebase


let BASE_URL = "https://track-8f48d.firebaseio.com"
let STORAGE_URL = "gs://track-8f48d.appspot.com"

class FirebaseHelper{
    
    //singleton
    static let sharedInstance = FirebaseHelper()
    
    //override init so noone else can
    private init() {}
    
    var trackKey = String()
    
    var trackHandle: FIRDatabaseHandle?
    
    //MARK: Database References
    
    private var _BASE_REF = FIRDatabase.database().referenceFromURL(BASE_URL)
    private var _USER_REF = FIRDatabase.database().referenceFromURL("\(BASE_URL)/users")
    private var _TRACK_REF = FIRDatabase.database().referenceFromURL("\(BASE_URL)/tracks")
    private var _FOOT_REF = FIRDatabase.database().referenceFromURL("\(BASE_URL)/footprints")
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    
    var TRACK_REF: FIRDatabaseReference {
        return _TRACK_REF
    }
    
    var FOOT_REF: FIRDatabaseReference {
        return _FOOT_REF
    }
    
    var CURRENT_USER_REF: FIRDatabaseReference {
        
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        let currentUser = BASE_REF.child("users").child(userID)
        
        return currentUser
    }
    
    //MARK: Storage References
    

    
    
    //MARK: Queries
    
    //query user by uid
    func queryUserByUid(uid: String){
        
        let reference = USER_REF.child("\(uid)/")
        
        reference.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
                print("snapshot : " + String(snapshot.value))
                
                
            }else{
                print("No Snapshot?!")
            }
        })
        
    }
    
    //query tracks by uid
    func queryTracksByUid(uid: String){
        
        let reference = TRACK_REF.child("\(uid)/")
        
        reference.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
                print("snapshot : " + String(snapshot.value))
                
                
            }else{
                print("No Snapshot?!")
            }
        })
        
    }
    
    func listenForNewTracks() {
        
        // Listen for new tracks
        trackHandle = TRACK_REF.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
 //           self.comments.append(snapshot)
//            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.comments.count-1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
        
    }
    
    func queryForRemovedTracks(){
        
    // Listen for deleted tracks
        TRACK_REF.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
//            let index = self.indexOfMessage(snapshot)
//            self.comments.removeAtIndex(index)
//            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
    }
    
    //query footprints by uid
    func queryFootprintsByUid(uid: String){
        
        let reference = FOOT_REF.child("\(uid)/")
        
        reference.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
                print("snapshot : " + String(snapshot.value))
                
                
            }else{
                print("No Snapshot?!")
            }
        })
        
    }
    
    //MARK: Create
    
    //create a new user in the firebase database instance
    func createNewUser(uid: String, user: Dictionary<String, String>) {

        USER_REF.child(uid).setValue(user)
        
    }
    
    func createNewTrack(uid: String){
        
        trackKey = TRACK_REF.childByAutoId().key
        let track = ["uid": trackKey,
                     "name": "name",
                     "desc": "desc"]
        
        TRACK_REF.child(uid).setValue(track)
        
    }
    
    func createNewFootprint(footprintAnnotation: FootprintAnnotation){
        
        let footKey = FOOT_REF.child("tracks").childByAutoId().key
        
        let footprint : [String : AnyObject] = ["uid": footKey,
                         "latitude": String(footprintAnnotation.coordinate.latitude),
                         "longitude": String(footprintAnnotation.coordinate.longitude),
                         "title": footprintAnnotation.title!,
                         "subtitle": footprintAnnotation.subtitle!]
        
        if(trackKey.isEmpty){
            trackKey = TRACK_REF.childByAutoId().key
        }
        let footUpdates = ["/\(footKey)/\(trackKey)/": footprint]
        
        FOOT_REF.updateChildValues(footUpdates)

        
    }
    
    //MARK: Update
    
    //MARK: Delete
    
    
    
    
}

