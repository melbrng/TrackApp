//
//  AddTrackViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/10/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit

protocol AddTrackViewControllerDelegate {
    func addTrack(sender: AddTrackViewController)
}


class AddTrackViewController: UIViewController {
    
    var delegate: AddTrackViewControllerDelegate?
    var newTrack = Track(name: String(), desc: String())

    @IBOutlet weak var trackNameTextField: UITextField!
    @IBOutlet weak var trackDescriptionTextField: UITextField!
    
    @IBAction func saveTrack(sender: AnyObject) {
        
        newTrack = Track.init(name: trackNameTextField.text!, desc: trackDescriptionTextField.text!)

        FirebaseHelper.sharedInstance.createNewTrack(newTrack)
        
        //upon successful save, call delegate
        delegate?.addTrack(self)
    
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func cancelSaveTrack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)

    }
}
