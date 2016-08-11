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

class PhotoViewController: UIViewController, UITextFieldDelegate, AddTrackViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var footprintTextField: UITextField!
    
    let firebaseHelper = FirebaseHelper.sharedInstance
    
    var footprintAnnotation = FootprintAnnotation(coordinate: CLLocationCoordinate2D(),image: UIImage())
    var delegate: PhotoViewControllerDelegate?
    
    var toSaveTrackKey: String?
    
    //tableview picker for popover
    var tableViewPicker =  UITableView()
    var items: [String] = ["New Track","Viper", "X", "Games"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackTextField.delegate = self
        footprintTextField.delegate = self
        
        
        trackedImageView.image = footprintAnnotation.image
        trackTextField.text = footprintAnnotation.title
        footprintTextField.text = footprintAnnotation.subtitle
        
        createTableViewPicker()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Add Image & Save
    @IBAction func add(sender: AnyObject) {
        
        footprintAnnotation.title = footprintTextField.text
        footprintAnnotation.subtitle = trackTextField.text
        footprintAnnotation.trackGUID = toSaveTrackKey
        
        
        //save the selected photo to the photolibrary
        UIImageWriteToSavedPhotosAlbum(footprintAnnotation.image, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
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
    
    //MARK: Keyboard
    //dismiss keyboard on return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField == footprintTextField){
            footprintTextField.resignFirstResponder()
        }else{
            trackTextField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: TableView Delegates and stuff
    func createTableViewPicker(){
        
        tableViewPicker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 200, width: 286, height: 291)
        tableViewPicker.alpha = 0
        tableViewPicker.hidden = true
        tableViewPicker.userInteractionEnabled = true
        
        tableViewPicker.delegate      =   self
        tableViewPicker.dataSource    =   self
        
        tableViewPicker.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewPicker.hidden = true
        
        self.view.addSubview(tableViewPicker)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableViewPicker.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        if(indexPath.row == 0){
            closeTable()
            performSegueWithIdentifier("CreateNewTrack", sender: nil)
        }
    }
    
    func openTable()
    {
        self.tableViewPicker.hidden = false
        
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.tableViewPicker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 230, width: 286, height: 291)
                                    self.tableViewPicker.alpha = 1
        })
    }
    
    func closeTable()
    {
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.tableViewPicker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 200, width: 286, height: 291)
                                    self.tableViewPicker.alpha = 0
            },
                                   completion: { finished in
                                    self.tableViewPicker.hidden = true
            }
        )
    }
    
    //MARK: UI Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectTrack(sender: AnyObject) {
        
        tableViewPicker.hidden ? openTable() : closeTable()
    }


    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "CreateNewTrack"){
            
            let addTrackViewController:AddTrackViewController = segue.destinationViewController as! AddTrackViewController
            addTrackViewController.delegate = self
            
        }
    }
    
    //MARK: Add Track Delegate
    
    func addTrack(sender: AddTrackViewController) {
        let x = sender.newTrack
        items.append(x.trackName)
        
        
        
        trackTextField.text = x.trackName
        toSaveTrackKey = firebaseHelper.trackKey
        
        tableViewPicker.reloadData()
        
       
        
    }
    
 
  
}
