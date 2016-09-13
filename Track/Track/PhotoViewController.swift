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


class PhotoViewController: UIViewController  {
    
    @IBOutlet weak var trackedImageView: UIImageView!
    @IBOutlet weak var trackTextField: UITextField!
    @IBOutlet weak var footprintTagField: UITextField!
    @IBOutlet weak var footprintTextField: UITextField!
    
    var footprint = Footprint(coordinate: CLLocationCoordinate2D(),image: UIImage())
    var delegate: PhotoViewControllerDelegate?
    
    var toSaveTrackUID: String?
    
    //tableview picker for popover
    var tableViewPicker =  UITableView()
    var trackItems = firebaseHelper.trackArray
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_add_circle_outline.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(add(_:)))
        
        let rightBarButtonImage : UIImage? = UIImage(named:"ic_not_interested.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightBarButtonImage, style: .Plain, target: self, action: #selector(cancel(_:)))
        
        trackTextField.delegate = self
        footprintTextField.delegate = self
        trackedImageView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/2)
        trackedImageView.contentMode = .ScaleToFill
        trackedImageView.image = footprint.image
        trackTextField.text = footprint.subtitle
        footprintTextField.text = footprint.title
        
        trackItems = firebaseHelper.trackArray
        
        self.createTableViewPicker()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Add Footprint
    @IBAction func add(sender: AnyObject) {
        
        footprint.title = footprintTextField.text
        footprint.subtitle = trackTextField.text
        footprint.trackUID = toSaveTrackUID
        
        //save and get tag uid FootprintAnnotation
        FirebaseHelper.sharedInstance.createNewFootprint(footprint, completion: { (success) -> Void in
            
            if(success) {
                
                //upon successful save, add new footprint to app array
                firebaseHelper.footprintArray.append(self.footprint)
                
                //call delegate
                self.delegate!.addFootprint(self)
                self.navigationController?.popViewControllerAnimated(true)
            }
        })
        

        
        
        //I see no reason to do this since we are saving images to Firebase but i'm gonna leave this here until I decide how i'm 
        //going to load/reload images. Now i'm doing it the lazy way (memory)
        
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
    

    //MARK: Track TableView Picker
    func createTableViewPicker(){
        
        tableViewPicker.frame = CGRect(x: 0, y: 30, width: 286, height: 291)
        
        //Header View
        let headerView = UIView.init(frame: CGRectMake(0, 0, 286, 50))
        let addNewTrackButton = UIButton.init(frame: CGRectMake(0, 0, 286, 50))
        addNewTrackButton.backgroundColor = UIColor.grayColor()
        addNewTrackButton.setTitle("Add New Track", forState: .Normal)
        addNewTrackButton.addTarget(self, action: #selector(addNewTrack), forControlEvents: .TouchUpInside)
        headerView.addSubview(addNewTrackButton)
        tableViewPicker.tableHeaderView = headerView
        
        tableViewPicker.alpha = 0
        tableViewPicker.hidden = true
        tableViewPicker.userInteractionEnabled = true
        
        tableViewPicker.delegate      =   self
        tableViewPicker.dataSource    =   self
        
        tableViewPicker.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableViewPicker.hidden = true
        
        self.view.addSubview(tableViewPicker)
        
    }

    func openTable(){
        self.tableViewPicker.hidden = false
        
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.tableViewPicker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 0, width: 286, height: 291)
                                    self.tableViewPicker.alpha = 1
        })
    }
    
    func closeTable(){
        UIView.animateWithDuration(0.3,
                                   animations: {
                                    self.tableViewPicker.frame = CGRect(x: ((self.view.frame.width / 2) - 143), y: 0, width: 286, height: 291)
                                    self.tableViewPicker.alpha = 0
            },
                                   completion: { finished in
                                    self.tableViewPicker.hidden = true
            }
        )
    }
    
    func addNewTrack(){
        
        closeTable()
        performSegueWithIdentifier("AddTrack", sender: nil)
    }
    
    //MARK: UI Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func selectTrack(sender: AnyObject) {
        
        tableViewPicker.hidden ? openTable() : closeTable()
    }

    
    @IBAction func trackButtonPressed(sender: AnyObject) {
        tableViewPicker.hidden ? openTable() : closeTable()
    }

    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier == "AddTrack"){
            
            let addTrackViewController:AddTrackViewController = segue.destinationViewController as! AddTrackViewController
            addTrackViewController.trackProfileImage = footprint.image!
            addTrackViewController.delegate = self
            
        } else if(segue.identifier == "AddTag"){
            
            let addTagViewController:AddTagViewController = segue.destinationViewController as! AddTagViewController
            addTagViewController.delegate = self
            
        }
    }
}


    //MARK: Keyboard
    //dismiss keyboard on return key
    extension PhotoViewController: UITextFieldDelegate {
        func textFieldShouldReturn(textField: UITextField) -> Bool {
            
            if(textField == footprintTextField){
                footprintTextField.resignFirstResponder()
            }else{
                trackTextField.resignFirstResponder()
            }
            return true
        }
    }

    //MARK: TableView Delegate
    extension PhotoViewController:UITableViewDelegate, UITableViewDataSource {
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.trackItems.count
        }

        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
            let cell:UITableViewCell = tableViewPicker.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
            
            cell.textLabel?.text = self.trackItems[indexPath.row].trackName
            
            return cell
            
        }

        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            //set the track name
            trackTextField.text = trackItems[indexPath.row].trackName
            toSaveTrackUID = trackItems[indexPath.row].trackUID
            closeTable()

        }

    }

    //MARK: Add Track Delegate
    extension PhotoViewController:AddTrackViewControllerDelegate {
    
        func addTrack(sender: AddTrackViewController) {
            
            let newTrack = sender.newTrack
            trackTextField.text = newTrack.trackName
            
            //query the newly added Track in order to retrieve trackUID
            let reference = firebaseHelper.TRACK_REF.child(firebaseHelper.currentUserUID!)
            reference.queryOrderedByChild("name").queryEqualToValue(newTrack.trackName).observeEventType(.Value, withBlock: {
                snapshot in
                
                if (snapshot.exists()) {

                    //TODO: Need a failsafe for when >1 child is retrieved--THERE CAN BE ONLY ONE!
                     for x in snapshot.children{

                        let track = Track.init(name: x.value?.objectForKey("name") as! String,
                            desc: x.value?.objectForKey("desc") as! String,
                            uid: x.value?.objectForKey("trackUID") as! String,
                            imagePath: x.value?.objectForKey("imagePath") as! String)
                        
                            //use local image
                            track.trackImage = self.footprint.image!
        
                            //set for use when setting footprint's trackUID
                            self.toSaveTrackUID = track.trackUID
        
                            firebaseHelper.trackArray.append(track)
                            self.trackItems = firebaseHelper.trackArray
                            self.tableViewPicker.reloadData()
                        }
                    }
                    else {
                        print("No Snapshot?!")
                    }
            })
        }
    }
    
    //MARK: Add Tag Delegate

    extension PhotoViewController:AddTagViewControllerDelegate {
    
        func addTag(sender: AddTagViewController) {
            let annotation = sender.selectedAnnotation
            footprint.coordinate = (annotation?.coordinate)!
            footprintTagField.text = (annotation?.title)!

        }
  
}
