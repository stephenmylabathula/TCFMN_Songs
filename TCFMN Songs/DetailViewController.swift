//
//  DetailViewController.swift
//  TCFMN Songs
//
//  Created by Stephen Mylabathula on 5/28/16.
//  Copyright © 2016 Stephen Mylabathula. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var displayPPT: UIWebView!
    
    var fileLang = "English"
    var fileName = "BlankBackground_NO_USE"
    var fileExt = "pptx"
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
        
        self.displayPPT.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(self.fileName, ofType: self.fileExt, inDirectory: "Songs/" + self.fileLang)!)))
        self.displayPPT.scalesPageToFit = true;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
        //toolbarItems = [add]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addToFavorites))
        //UIBarButtonItem(image: UIImage(named: "Star"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(addTapped))
        
        self.configureView()
    }
    
    func addToFavorites(){
        let currentList = PlistManager.sharedInstance.getMutableDict()
        let keys = currentList?.allKeys
        let numKeys = keys?.count
        let songdata = [fileLang, fileName, fileExt]
        
        for currentValue in (currentList?.allValues)! {
            if currentValue as! Array<String> == songdata {
                let alertController = UIAlertController(title: "Error", message: "This song already exists in favorites!", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
        }
        
        if numKeys <= 0 {
            PlistManager.sharedInstance.addNewItemWithKey("0", value: songdata)
            let alertController = UIAlertController(title: "Song Added to Favorites", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if numKeys < 9 && numKeys > 0 {
            PlistManager.sharedInstance.addNewItemWithKey(String(numKeys!), value: songdata)
            let alertController = UIAlertController(title: "Song Added to Favorites", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Sorry", message: "You can only have 10 songs in favorites list!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        print(PlistManager.sharedInstance.getMutableDict()?.allKeys.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if UIDevice.currentDevice().orientation.isLandscape{
            navigationController?.navigationBarHidden = true
            tabBarController?.tabBar.hidden = true
            //navigationController?.setToolbarHidden(true, animated: true)
        }
        else{
            navigationController?.navigationBarHidden = false
            tabBarController?.tabBar.hidden = false
            //navigationController?.setToolbarHidden(false, animated: true)
        }
    }

}

