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
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Authentication
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        
        loginEmailTextField.text = "testuser@gmail.com"
        loginPasswordTextField.text = "password"
        
        if let email = loginEmailTextField.text, password = loginPasswordTextField.text {
            
            loginUser(email, password: password) { (stringvalue) -> () in
                    self.userUID = stringvalue
            }
            

       }
        
        print("useruid: " + self.userUID)
        
    }
    
    
    @IBAction func signupButtonTouched(sender: AnyObject) {
        
        if let email = loginEmailTextField.text, password = loginPasswordTextField.text {
            
            FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("Successfully created account.")
                }
            }
        }
    }


    

    
    
//    func loginUser(email: String,password: String) {
//        
//        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
//    
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            } else {
//                if let user = user {
//                    print("Successful login")
//                    self.performSegueWithIdentifier("loginToMap", sender: nil)
//                    
//                }
//            }
//
//        }
//        
//    }
    
    func loginUser(email: String,password: String, completionHandler: (userID: String) -> ()) {
        
        FIRAuth.auth()?.signInWithEmail(email, password: password) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                if let user = user {
                    completionHandler(userID: user.uid)
                    print("Successful login")
                    
                }
            }
            
        }
        
    }
    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
