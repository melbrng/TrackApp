//
//  PhotoViewController.swift
//  TrackAppPrototype
//
//  Created by Melissa Boring on 7/9/16.
//  Copyright © 2016 melbo. All rights reserved.
//
import UIKit
import MapKit
import FirebaseDatabase


protocol PhotoViewControllerDelegate {
    func addFootprint(sender: PhotoViewController)
}




class PhotoViewController: UIViewController, UITextFieldDelegate, AddTrackViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var footprintTextField: UITextField!
    
    var footprintAnnotation = FootprintAnnotation(coordinate: CLLocationCoordinate2D(),image: UIImage())
    var delegate: PhotoViewControllerDelegate?
    
    var toSaveTrackUID: String?
    
    //tableview picker for popover
    var tableViewPicker =  UITableView()
    var trackItems = firebaseHelper.trackArray
    
    let defaultTrack = Track(name: "Add New Track", desc: "Default track")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trackTextField.delegate = self
        footprintTextField.delegate = self
        
        trackedImageView.image = footprintAnnotation.image
        trackTextField.text = footprintAnnotation.subtitle
        footprintTextField.text = footprintAnnotation.title
        
        self.createTableViewPicker()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let reference = firebaseHelper.TRACK_REF.child(firebaseHelper.currentUserUID!)
        self.trackItems = [Track]()
        self.trackItems.append(self.defaultTrack)
        
        // Listen for new tracks
        reference.observeEventType(.ChildAdded, withBlock: { snapshot in

            if (snapshot.exists()) {

                let track = Track.init(name: snapshot.value!["name"] as! String, desc: snapshot.value!["desc"] as! String, uid: snapshot.value!["trackUID"] as! String,imagePath: snapshot.value!["imagePath"] as! String)
                
                //MARK: Repetitive-I don't want to retrieve AGAIN when adding a new Track
                firebaseHelper.retrieveTrackImage(track, completion: { (success) -> Void in
                    if success{
                        track.trackImage = firebaseHelper.retrievedImage
                        print("query image retrieved")
                    }
                })
                
                self.trackItems.append(track)
                
                
            } else {
                print("No Snapshot?!")
            }
            
            self.tableViewPicker.reloadData()
        })
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Add Image & Save
    @IBAction func add(sender: AnyObject) {
        
        footprintAnnotation.title = footprintTextField.text
        footprintAnnotation.subtitle = trackTextField.text
        footprintAnnotation.trackUID = toSaveTrackUID
        
        //MARK: This should be a completion block
        //save and get tag uid FootprintAnnotation
        FirebaseHelper.sharedInstance.createNewFootprint(footprintAnnotation)
        
        //upon successful save, call delegate
        delegate!.addFootprint(self)
        self.navigationController?.popViewControllerAnimated(true)
        
        //MARK: Local Image Save
        //I see no reason to do this since we are saving images to Firebase
        //save the selected photo to the photolibrary
        //UIImageWriteToSavedPhotosAlbum(footprintAnnotation.image!, self, #selector(self.imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
//    func imageSaved(image: UIImage!, didFinishSavingWithError error: NSError?, contextInfo: AnyObject?) {
//        if (error != nil) {
//            // error - add a alertview
//        } else {
//            
//            //save and get tag uid FootprintAnnotation
//            FirebaseHelper.sharedInstance.createNewFootprint(footprintAnnotation)
//            
//            //upon successful save, call delegate
//            delegate!.addFootprint(self)
//            self.navigationController?.popViewControllerAnimated(true)
//        }
//    }
    
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
        return self.trackItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableViewPicker.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = self.trackItems[indexPath.row].trackName
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.row == 0){
            closeTable()
            performSegueWithIdentifier("CreateNewTrack", sender: nil)
        } else {
            //set the footprint name and
            trackTextField.text = trackItems[indexPath.row].trackName
            toSaveTrackUID = trackItems[indexPath.row].trackUID
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
            addTrackViewController.trackProfileImage = footprintAnnotation.image!
            addTrackViewController.delegate = self
            
        }
    }
    
    //MARK: Add Track Delegate
    
    func addTrack(sender: AddTrackViewController) {
        
        let newTrack = sender.newTrack
        trackTextField.text = newTrack.trackName
        
        //set for use when setting footprint's trackUID
        toSaveTrackUID = newTrack.trackUID
        
    }
    
 
  
}
