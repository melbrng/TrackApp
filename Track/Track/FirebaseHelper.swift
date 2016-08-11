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
    
    let currentUserUID = FIRAuth.auth()!.currentUser?.uid
    
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
    

    
    //MARK: Data
    
    var trackArray = [Track]()
    
    //MARK: Queries
    
    //query user by uid
    func queryUserByUid(uid: String){
        
        let reference = USER_REF.child("\(uid)/")
        
        reference.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
                //print("snapshot : " + String(snapshot.value))
                print(snapshot.value?.objectForKey("email"))
                print(snapshot.value?.objectForKey("provider"))
                print(snapshot.value?.objectForKey("username"))
                
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
                
                for x in snapshot.children{
                    let track = Track.init(name: x.value?.objectForKey("name") as! String, desc: x.value?.objectForKey("desc") as! String, uid: x.value?.objectForKey("uid") as! String)
//                print(x.value?.objectForKey("desc"))
//                print(x.value?.objectForKey("name"))
//                print(x.value?.objectForKey("uid"))
                    
                    self.trackArray.append(track)
                    
                }
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
    
    func createNewTrack(track: Track){
        
        trackKey = TRACK_REF.childByAutoId().key
        let track = ["uid": trackKey,
                     "name": track.trackName,
                     "desc": track.trackDescription]
        
        let trackPath = "/" + currentUserUID! + "/" + trackKey + "/"
        
        TRACK_REF.child(trackPath).setValue(track)
        
        //TRACK_REF.child(trackKey).setValue(track)
        
        //TRACK_REF.childByAutoId().setValue(track)
        
    }
    
    func createNewFootprint(footprintAnnotation: FootprintAnnotation){
        
        let trackKey = footprintAnnotation.trackUID
        
        let footKey = FOOT_REF.child("tracks").childByAutoId().key
        
        let footprint : [String : AnyObject] = ["uid": footKey,
                         "latitude": String(footprintAnnotation.coordinate.latitude),
                         "longitude": String(footprintAnnotation.coordinate.longitude),
                         "footprint": footprintAnnotation.title!,
                         "track": footprintAnnotation.subtitle!]
        
        //this is for updating  not insertion
        //let footUpdates = ["/\(trackKey)/\(footKey)/": footprint]
        //FOOT_REF.updateChildValues(footUpdates)
        
        //inserting
        let trackPath = "/" + currentUserUID! + "/" + trackKey! + "/"
        let footprintPath = trackPath + footKey + "/"
        FOOT_REF.child(footprintPath).setValue(footprint)

        
    }
    
    //MARK: Update
    
    //MARK: Delete
    
    
    
    
}

