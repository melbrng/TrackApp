//
//  LoginViewController.swift
//  Track
//
//  Created by Melissa Boring on 7/16/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var userUID = String()
    var isSet = false
    
    //The handler for the auth state listener, to allow cancelling later.
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginPasswordTextField.secureTextEntry = true
        
        //monitor the user authentication state and present mapview is user is already logged in
        handle = FIRAuth.auth()!.addAuthStateDidChangeListener() { (auth, user) in
            if let user = user {
                print("User is signed in with uid: " + user.uid + " and email: " + user.email!)
                
                //temporary fix to prevent two mapVC's from being presented because the listener is calling twice
                if(self.isSet == false){
                    self.isSet = true
                } else {
                    self.isSet = false
                }
                
                //move onto mapview
                if(self.isSet == true){
                    self.performSegueWithIdentifier("loginToMap", sender: nil)
                }
                
            } else {
                print("No user is signed in.")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        // logout when we unwind back to LoginVC
        
        try! FIRAuth.auth()!.signOut()
    }
    
    // MARK: Authentication
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        
        if let email = loginEmailTextField.text, password = loginPasswordTextField.text {
            
            loginUser(email, password: password)
       }
        
    }
    
    
    @IBAction func signupButtonTouched(sender: AnyObject) {
        
        //start activityIndicator on the main thread (UI stuff!)
        self.loginActivityIndicator.startAnimating()
        
        if let email = loginEmailTextField.text, password = loginPasswordTextField.text {
            
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                
                if let error = error {
                    self.loginErrorMessage("Sign Up Error", message: error.localizedDescription)
                    
                    return
                } else {
                    
                    //create database user entry
                    let trackUser = ["provider": user!.providerID, "email": email, "username": "name"]
                    FirebaseHelper.sharedInstance.createNewUser((user?.uid)!, user: trackUser)
                    
                    // Store the uid
                    //NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: "uid")
                    
                    self.loginActivityIndicator.stopAnimating()
                    
                    //move onto mapview
                    //temporary fix to prevent two mapVC's from being presented because the listener is calling twice
                    if(self.isSet == false){
                        self.isSet = true
                    } else {
                        self.isSet = false
                    }
                    
                    //move onto mapview
                    if(self.isSet == true){
                        self.performSegueWithIdentifier("loginToMap", sender: nil)
                    }
                }
            }
        }
    }


    
    func loginUser(email: String,password: String) {
        
        //start activityIndicator on the main thread (UI stuff!)
        self.loginActivityIndicator.startAnimating()
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            
            if let error = error {
                
                self.loginErrorMessage("Login Error", message: error.localizedDescription)
                return
                
            } else {
                if user != nil {

                    //create database user entry
                    let trackUser = ["provider": user!.providerID, "email": email, "username": "name"]
                    FirebaseHelper.sharedInstance.createNewUser((user?.uid)!, user: trackUser)
                    
                    self.loginActivityIndicator.stopAnimating()
                    
                    //move onto mapview
                    self.performSegueWithIdentifier("loginToMap", sender: nil)
                    
                }
            }

        }
        
    }
    
    
    // MARK: ## I've added this method (and a breakpoint here) to mark when I'm segueing away from this view.
    // This should only happen once, of course...
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        FIRAuth.auth()?.removeAuthStateDidChangeListener(handle!)
    }
    
    
    func loginErrorMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}
