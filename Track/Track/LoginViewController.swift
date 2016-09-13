//
//  LoginViewController.swift
//  Track
//
//  Created by Melissa Boring on 7/16/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import Firebase

let firebaseHelper = FirebaseHelper.sharedInstance

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
        
        if let user =  FIRAuth.auth()?.currentUser {
            print("User is signed in with uid: " + user.uid + " and email: " + user.email!)
            
                firebaseHelper.queryTracksByUid((FIRAuth.auth()?.currentUser?.uid)!, completion: { (success) -> Void in
                        if success{
                            print("tracks downloaded successfully")
                
                            firebaseHelper.queryFootprintsByUid((FIRAuth.auth()?.currentUser?.uid)!, completion: { (success) -> Void in
                                if success{
                                    print("footprints downloaded successfully")
                                    self.performSegueWithIdentifier("ShowMap", sender: nil)
                                } else {
                                    print("footprints download failed")
                                }
                            })

                        } else {
                            print("track download failed")
                        }
                    })
            
                } else {
                    print("No user is signed in.")
                }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // logout when we unwind back to LoginVC
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        
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
                    
                    self.loginActivityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("ShowMap", sender: nil)

                }
            }
        }
    }


    
    func loginUser(email: String,password: String) {
        
        self.loginActivityIndicator.startAnimating()
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            
            if let error = error {
                
                self.loginErrorMessage("Login Error", message: error.localizedDescription)
                return
                
            } else {
                if user != nil {

                    firebaseHelper.queryTracksByUid((FIRAuth.auth()?.currentUser?.uid)!, completion: { (success) -> Void in
                        if success{
                            print("tracks downloaded successfully")
                            
                            firebaseHelper.queryFootprintsByUid((FIRAuth.auth()?.currentUser?.uid)!, completion: { (success) -> Void in
                                if success{
                                    self.loginActivityIndicator.stopAnimating()
                                    print("footprints downloaded successfully")
                                    self.performSegueWithIdentifier("ShowMap", sender: nil)
                                } else {
                                    print("footprints download failed")
                                }
                            })
                            
                        } else {
                            print("track download failed")
                        }
                    })
                    
                }
            }

        }
        
    }
    
    func loginErrorMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    


}
