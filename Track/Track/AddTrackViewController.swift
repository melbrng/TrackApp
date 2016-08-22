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
    var trackProfileImage = UIImage()

    @IBOutlet weak var trackNameTextField: UITextField!
    @IBOutlet weak var trackDescriptionTextField: UITextField!
    @IBOutlet weak var trackImageView: UIImageView!
    
    
    override func viewDidLoad() {
        
        trackImageView.image = trackProfileImage
    }
    
    @IBAction func saveTrack(sender: AnyObject) {
        
        newTrack = Track.init(name: trackNameTextField.text!, desc: trackDescriptionTextField.text!, image: trackProfileImage, imagePath: String())

        FirebaseHelper.sharedInstance.createNewTrack(newTrack, completion: {(success) -> Void in
            if(success){

                
                //upon successful save, call delegate
                self.delegate?.addTrack(self)
                self.navigationController?.popViewControllerAnimated(true)
                
            }
        })

    }
    
    @IBAction func cancelSaveTrack(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)

    }
}
