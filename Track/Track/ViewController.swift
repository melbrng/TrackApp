//
//  ViewController.swift
//  Track
//
//  Created by Melissa Boring on 7/16/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        FIRAuth.auth()?.signInWithEmail("testuser@gmail.com", password: "password") { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                print("Successful login")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

