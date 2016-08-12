//
//  FirebaseHelper.swift
//  Track
//
//  Created by Melissa Boring on 7/18/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import Foundation
import Firebase
import MapKit


let BASE_URL = "https://track-8f48d.firebaseio.com"
let STORAGE_URL = "gs://track-8f48d.appspot.com"

class FirebaseHelper{
    
    //singleton
    static let sharedInstance = FirebaseHelper()
    
    //completion handler
    typealias CompletionHandler = (success:Bool) -> Void
    
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
    

    
    //MARK: Data Arrays
    
    var trackArray = [Track]()
    let defaultTrack = Track(name: "Add New Track", desc: "Default track")
    var footprintArray = [FootprintAnnotation]()
    
    //MARK: Query Users
    
    //query user by uid
    func queryUserByUid(uid: String){
        
        let reference = USER_REF.child("\(uid)/")
        
        reference.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
    
                print(snapshot.value?.objectForKey("email"))
                print(snapshot.value?.objectForKey("provider"))
                print(snapshot.value?.objectForKey("username"))
                
            }else{
                print("No Snapshot?!")
            }
        })
        
    }
    
    //MARK: Query Tracks
    func queryTracksByUid(uid: String, completion: CompletionHandler){
        
        let reference = TRACK_REF.child("\(uid)/")
        
        self.trackArray = [Track]()
        //add the "Add New Track" track
        self.trackArray.append(self.defaultTrack)
        
        reference.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
            
                for x in snapshot.children{
                    let track = Track.init(name: x.value?.objectForKey("name") as! String, desc: x.value?.objectForKey("desc") as! String, uid: x.value?.objectForKey("trackUID") as! String)
                    
                    self.trackArray.append(track)
                    
                }
                
            }else{
                print("No Snapshot?!")
            }
        })
        
        
        let flag = true
        completion(success: flag)
        
    }
    
   
    
    //query tracks by uid
    func queryTracksByUidAndListen(uid: String, completion: CompletionHandler){
        
        let reference = TRACK_REF.child("\(uid)/")
    
        reference.observeEventType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
                
                //recreate array for every load
                self.trackArray = [Track]()
                
                //add the "Add New Track" track
                self.trackArray.append(self.defaultTrack)
                
                for x in snapshot.children{
                    let track = Track.init(name: x.value?.objectForKey("name") as! String, desc: x.value?.objectForKey("desc") as! String, uid: x.value?.objectForKey("trackUID") as! String)
                    
                    self.trackArray.append(track)
                    
                }

            }else{
                print("No Snapshot?!")
            }
        })
        
        let flag = true
        completion(success: flag)
        
    }
    
    func listenForNewTracks() {
        
        // Listen for new tracks
        trackHandle = TRACK_REF.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.exists()) {
                
                for x in snapshot.children{
                    let track = Track.init(name: x.value?.objectForKey("name") as! String, desc: x.value?.objectForKey("desc") as! String, uid: x.value?.objectForKey("trackUID") as! String)
                    
                    self.trackArray.append(track)
                    
                }

            }else{
                print("No Snapshot?!")
            }
        })
        
    }
    
    //not sure if need this
    func queryForRemovedTracks(){
        
        // Listen for deleted tracks
        TRACK_REF.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            //            let index = self.indexOfMessage(snapshot)
            //            self.comments.removeAtIndex(index)
            //            self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Automatic)
        })
    }
    
    //MARK: Query Footprints
    func queryFootprintsByUid(uid: String, completion: CompletionHandler){
        
        let reference = FOOT_REF.child("\(uid)/")
        
        reference.observeSingleEventOfType (.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
                
                self.footprintArray = [FootprintAnnotation]()
                for track in snapshot.children {
                    
                    for footprint in track.children {
                        
                        var coordinate = CLLocationCoordinate2D()
                        coordinate.latitude = (footprint.value?.objectForKey("latitude")!.doubleValue)!
                        coordinate.longitude = (footprint.value?.objectForKey("longitude")!.doubleValue)!
                            
                        let footprintAnnotation = FootprintAnnotation(coordinate: coordinate, trackUID: footprint.value?.objectForKey("trackUID") as! String,
                            footUID: footprint.value?.objectForKey("footUID") as! String,
                            title: footprint.value?.objectForKey("title") as! String,
                            subtitle: footprint.value?.objectForKey("subtitle") as! String)
                        
                        self.footprintArray.append(footprintAnnotation)
                    }
                   
                }
                
              print(self.footprintArray.count)
                let flag = true
                completion(success: flag)
                
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
        let track = ["trackUID": trackKey,
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
        
        let footprint : [String : AnyObject] = ["footUID": footKey,
                         "latitude": String(footprintAnnotation.coordinate.latitude),
                         "longitude": String(footprintAnnotation.coordinate.longitude),
                         "title": footprintAnnotation.title!,
                         "subtitle": footprintAnnotation.subtitle!,
                         "trackUID": footprintAnnotation.trackUID!]
        
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

