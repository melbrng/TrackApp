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

class FirebaseHelper{
    
    //singleton
    static let sharedInstance = FirebaseHelper()
    
    //override init so noone else can
    private init() {}
    
    //MARK: References
    
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
    
    //MARK: Actions
    
    //query by uid
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
    
    //create a new user in the firebase database instance
    func createNewUser(uid: String, user: Dictionary<String, String>) {

        USER_REF.child(uid).setValue(user)
    }
    
    
}

