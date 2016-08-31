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
    
    var trackUID = String()
    var trackHandle: FIRDatabaseHandle?
    let currentUserUID = FIRAuth.auth()!.currentUser?.uid
    var testDataLoad = false
    var retrievedImage: UIImage!
    let defaultTrack = Track(name: "Add New Track", desc: "Default track")
    
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
    
    // Points to the root reference
    let trackImagesRef = FIRStorage.storage().referenceForURL("gs://track-8f48d.appspot.com/images")
    
    //MARK: Data Arrays
    
    var trackArray = [Track]()
    var footprintArray = [Footprint]()
    
    //MARK: Image Storage & Retrieval
    
    func loadDefaultUserImage(){
        
        // Default image set when a user signs up
        let userFolderName = currentUserUID
        let fileData = UIImageJPEGRepresentation((UIImage.init(named: "default.jpg"))!, 0.7)
        
        trackImagesRef.child("/"+userFolderName!+"/default.jpg").putData(fileData!)
        
    }
    
    func loadImage(imagePath: String, image: UIImage, completion: CompletionHandler){
        
//        print(imagePath)
//        print(image.size.width)
//        print(image.size.height)
        
        // Default image set when a user signs up
        let fileData = UIImageJPEGRepresentation(image, 0.7)
        
        trackImagesRef.child(imagePath).putData(fileData!)
        
        let flag = true
        completion(success: flag)
        
    }
    
    func retrieveFootprintImage(footprint: Footprint, completion: CompletionHandler){
        
        let footprintRef = trackImagesRef.child(footprint.imagePath!)
        
        //MARK: Lazy method, downloading images into memory.

        footprintRef.dataWithMaxSize(5 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                self.retrievedImage = UIImage(data: data!)
                let flag = true
                completion(success: flag)
            }
        }

    }

    func retrieveTrackImage(track: Track, completion: CompletionHandler){
        
        
        let trackRef = trackImagesRef.child(track.trackImagePath!)
        
        trackRef.dataWithMaxSize(5 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print(error.debugDescription)
            } else {
                let image = UIImage(data: data!)
                self.retrievedImage = image?.decompressedImage
                let flag = true
                completion(success: flag)

            }
        }
        
    }

    
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
        
        //add the "Add New Track" track
        trackArray.append(defaultTrack)

        
        reference.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
            
                for x in snapshot.children{
                    let track = Track.init(name: x.value?.objectForKey("name") as! String,
                        desc: x.value?.objectForKey("desc") as! String,
                        uid: x.value?.objectForKey("trackUID") as! String,
                        imagePath: x.value?.objectForKey("imagePath") as! String)
                    
                    self.retrieveTrackImage(track, completion: { (success) -> Void in
                        if success{
                            track.trackImage = firebaseHelper.retrievedImage
                            print("query track image retrieved")
                        }
                    })
                    
                    self.trackArray.append(track)
                    
                }
                let flag = true
                completion(success: flag)
                
            }else{
                print("No Snapshot?!")
            }
        })
    
    }
    
   
    
    func listenForNewTracks(uid: String) {
        
        let reference = TRACK_REF.child("\(uid)/")
        
        // Listen for new tracks
        reference.queryLimitedToLast(1)
        trackHandle = reference.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.exists()) {
                self.trackArray = [Track]()
                
                //add the "Add New Track" track
                self.trackArray.append(self.defaultTrack)
                
                let track = Track.init(name: snapshot.value!["name"] as! String,
                    desc: snapshot.value!["desc"] as! String,
                    uid: snapshot.value!["trackUID"] as! String,
                    imagePath: snapshot.value!["imagePath"] as! String)

                self.trackArray.append(track)
                
            } else {
                print("No Snapshot?!")
            }

        })
        
    }
    

    
    //MARK: Query Footprints
    func queryFootprintsByUid(uid: String, completion: CompletionHandler){
        
        let reference = FOOT_REF.child("\(uid)/")
        
        reference.observeSingleEventOfType (.Value, withBlock: { snapshot in
            if (snapshot.exists()) {
                
                self.footprintArray = [Footprint]()
                for track in snapshot.children {
                    
                    for footprint in track.children {
                        
                        var coordinate = CLLocationCoordinate2D()
                        coordinate.latitude = (footprint.value?.objectForKey("latitude")!.doubleValue)!
                        coordinate.longitude = (footprint.value?.objectForKey("longitude")!.doubleValue)!
                            
                        let footprint = Footprint(coordinate: coordinate, trackUID: footprint.value?.objectForKey("trackUID") as! String,
                            footUID: footprint.value?.objectForKey("footUID") as! String,
                            title: footprint.value?.objectForKey("title") as! String,
                            subtitle: footprint.value?.objectForKey("subtitle") as! String,
                            image: UIImage(),
                            imagePath: footprint.value?.objectForKey("imagePath") as! String)
                        
                        self.retrieveFootprintImage(footprint, completion: { (success) -> Void in
                            if success{
                                footprint.image = firebaseHelper.retrievedImage
                                print("query footprint image retrieved")
                            }
                        })
                        
                        self.footprintArray.append(footprint)
                    }
                   
                }
                
                
                let flag = true
                completion(success: flag)
                
            }else{
                print("No Snapshot?!")
            }
        })
    
        
    }
    

    func listenForNewFootprints(uid: String, completion: CompletionHandler) {
        
        let reference = FOOT_REF.child("\(uid)/")
        
        // Listen for new tracks
        trackHandle = reference.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.exists()) {

                    for track in snapshot.children {
                        
                        for footprint in track.children {
                            
                            var coordinate = CLLocationCoordinate2D()
                            coordinate.latitude = (footprint.value?.objectForKey("latitude")!.doubleValue)!
                            coordinate.longitude = (footprint.value?.objectForKey("longitude")!.doubleValue)!
                            
                            let footprintAnnotation = Footprint(coordinate: coordinate, trackUID: footprint.value?.objectForKey("trackUID") as! String,
                                footUID: footprint.value?.objectForKey("footUID") as! String,
                                title: footprint.value?.objectForKey("title") as! String,
                                subtitle: footprint.value?.objectForKey("subtitle") as! String,
                                image: UIImage(),
                                imagePath: footprint.value?.objectForKey("imagePath") as! String)
                            
                            self.footprintArray.append(footprintAnnotation)
                        }
                }
                    
                let flag = true
                completion(success: flag)
                
            } else {
                print("No Snapshot?!")
            }
        })
        
    }

    
    //MARK: Create
    
    //create a new user in the firebase database instance
    func createNewUser(uid: String, user: Dictionary<String, String>) {

        USER_REF.child(uid).setValue(user)
        
    }
    
    func createNewTrack(track: Track, completion: CompletionHandler){
        
        trackUID = TRACK_REF.childByAutoId().key
        
        let userFolderName = currentUserUID!
        let fileName = track.trackName.stringByAppendingString(".jpg")
        let encodedHost = fileName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let imagePath = "/"+userFolderName+"/"+encodedHost!+""
        
        let trackD = ["trackUID": trackUID,
                      "name": track.trackName,
                      "desc": track.trackDescription,
                      "imagePath": imagePath]
        
        let trackPath = "/" + currentUserUID! + "/" + trackUID + "/"
        
        loadImage(imagePath, image: track.trackImage, completion: { (success) -> Void in
            
            if(success){
                
                self.TRACK_REF.child(trackPath).setValue(trackD)
                let flag = true
                completion(success: flag)
                
            } else {
                
                print("unable to create track")
                
            }
            
        })
        
    }
    
    func createNewFootprint(footprint: Footprint, completion: CompletionHandler){
        
        //trackUID
        let footprintTrackUID = footprint.trackUID!
        //footprintUID
        let footUID = FOOT_REF.child("tracks").childByAutoId().key
        var footprintD : [String : AnyObject]
    
        let userFolderName = currentUserUID!
        let fileName = footprint.title!.stringByAppendingString(".jpg")
        let encodedHost = fileName.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let imagePath = "/"+userFolderName+"/"+encodedHost!+""

        footprintD = ["footUID": footUID,
                    "latitude": String(footprint.coordinate.latitude),
                    "longitude": String(footprint.coordinate.longitude),
                    "title": footprint.title!,
                    "subtitle": footprint.subtitle!,
                    "trackUID": footprintTrackUID,
                    "imagePath": imagePath]

        
        //inserting
        let trackPath = "/" + currentUserUID! + "/" + footprintTrackUID + "/"
        let footprintPath = trackPath + footUID + "/"
        
        loadImage(imagePath, image: footprint.image!, completion: { (success) -> Void in
            
            if(success){
                
                self.FOOT_REF.child(footprintPath).setValue(footprintD)
                let flag = true
                completion(success: flag)
                print("created footprint")
                
            } else {
                
                print("unable to create footprint")
                
            }
            
        })

    }
    
    
}

