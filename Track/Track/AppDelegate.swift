//
//  AppDelegate.swift
//  Track
//
//  Created by Melissa Boring on 7/16/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    //FirebaseHelper.sharedInstance executes before the application didFinishLaunchingWithOptions function is executed
    override init() {
        super.init()
        FIRApp.configure()
        // not really needed unless you really need it FIRDatabase.database().persistenceEnabled = true
    }


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //configure a FIRApp shared instance
        //FIRApp.configure()
        
        return true
    }




}

