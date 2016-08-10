//
//  PhotoViewController.swift
//  TrackAppPrototype
//
//  Created by Melissa Boring on 7/9/16.
//  Copyright © 2016 melbo. All rights reserved.
//
import UIKit
import MapKit

protocol PhotoViewControllerDelegate {
    func addFootprint(sender: PhotoViewController)
}

class PhotoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var footprintTextField: UITextField!
    
    var footprintAnnotation = FootprintAnnotation(coordinate: CLLocationCoordinate2D(),image: UIImage())
    var delegate: PhotoViewControllerDelegate?
    
    //picker for popover
    let picker = UIImageView(image: UIImage(named: "picker"))
    
    struct tracks {
        static let moods = [
            ["title" : "the best", "color" : "#8647b7"],
            ["title" : "really good", "color": "#4870b7"],
            ["title" : "okay", "color" : "#45a85a"],
            ["title" : "meh", "color" : "#a8a23f"],
            ["title" : "not so great", "color" : "#c6802e"],
            ["title" : "the worst", "color" : "#b05050"]
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTextField.delegate = self
        footprintTextField.delegate = self
        
        trackedImageView.image = footprintAnnotation.image
        trackTextField.text = footprintAnnotation.title
        footprintTextField.text = footprintAnnotation.subtitle
        
        createPicker()
        
    }

    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func add(sender: AnyObject) {
        
        footprintAnnotation.title = footprintTextField.text
        footprintAnnotation.subtitle = trackTextField.text
        
        //save the selected photo to the photolibrary
        UIImageWriteToSavedPhotosAlbum(footprintAnnotation.image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    

    @IBAction func selectTrack(sender: AnyObject) {
        
        picker.hidden ? openPicker() : closePicker()
    }
    
    //MARK: Popover
    func createPicker()
    {
        picker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 200, width: 286, height: 291)
        picker.alpha = 0
        picker.hidden = true
        picker.userInteractionEnabled = true
        
        var offset = 21
        
        for (index, feeling) in tracks.moods.enumerate()
        {
            let button = UIButton()
            button.frame = CGRect(x: 13, y: offset, width: 260, height: 43)

            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.setTitle(feeling["title"], forState: .Normal)
           
            button.tag = index
            button.addTarget(self, action: #selector(buttonTouchDown), forControlEvents: .TouchDown)
            
            picker.addSubview(button)
            
            offset += 44
        }
        
        view.addSubview(picker)
    }
    
    
    //This function will allow one selection and falsify previously selected buttons
    func buttonTouchDown(sender: UIButton!){
        
        for view in picker.subviews {
            
            if let button = view as? UIButton{
                if button.selected == true {
                    button.selected = false
                    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                }
            }
            
            
        }
        
        sender.selected = true
        sender.setTitleColor(UIColor.blueColor(), forState: .Normal)
        trackTextField.text = sender.titleLabel?.text
        closePicker()
        
    }
    
    func openPicker()
    {
        self.picker.hidden = false
        
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.picker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 230, width: 286, height: 291)
                                    self.picker.alpha = 1
        })
    }
    
    func closePicker()
    {
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.picker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 200, width: 286, height: 291)
                                    self.picker.alpha = 0
            },
                                   completion: { finished in
                                    self.picker.hidden = true
            }
        )
    }
    
    
    
    //MARK: Image Save
    func imageSaved(image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
        if (error != nil) {
            // error - add a alertview
        } else {
            
            //save and get tag uid FootprintAnnotation
            FirebaseHelper.sharedInstance.createNewFootprint(footprintAnnotation)
            
            //upon successful save, call delegate
            delegate!.addFootprint(self)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    //dismiss keyboard on return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == footprintTextField){
            footprintTextField.resignFirstResponder()
        }else{
            trackTextField.resignFirstResponder()
        }
        return true
    }
}
