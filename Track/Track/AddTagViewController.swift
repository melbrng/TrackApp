//
//  AddTagViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/26/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit

protocol AddTagViewControllerDelegate {
    func addTag(sender: AddTagViewController)
}

class AddTagViewController: UIViewController {
    
    var delegate: AddTagViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
