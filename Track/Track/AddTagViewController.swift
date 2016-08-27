//
//  AddTagViewController.swift
//  Track
//
//  Created by Melissa Boring on 8/26/16.
//  Copyright © 2016 melbo. All rights reserved.
//

import UIKit
import MapKit

protocol AddTagViewControllerDelegate {
    func addTag(sender: AddTagViewController)
}

class AddTagViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate {
    
    var delegate: AddTagViewControllerDelegate?
    let request = MKLocalSearchRequest()

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tagMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarButtonImage : UIImage? = UIImage(named:"ic_add_circle_outline.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: leftBarButtonImage, style: .Plain, target: self, action: #selector(addTag(_:)))
        
        let rightBarButtonImage : UIImage? = UIImage(named:"ic_not_interested.png")!.imageWithRenderingMode(.AlwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: rightBarButtonImage, style: .Plain, target: self, action: #selector(cancelAddTag(_:)))

        // Do any additional setup after loading the view.
        
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addTag(sender: AnyObject) {
    }
    
    @IBAction func cancelAddTag(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func searchForTag(sender: AnyObject) {
        
        request.naturalLanguageQuery = searchTextField.text
        
        request.region = tagMapView.region
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
