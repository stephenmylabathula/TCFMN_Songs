//
//  FavoritesDetailViewController.swift
//  TCFMN Songs
//
//  Created by Stephen Mylabathula on 6/7/16.
//  Copyright © 2016 Stephen Mylabathula. All rights reserved.
//

import UIKit

class FavoritesDetailViewController: UIViewController {
    
    
    @IBOutlet weak var displayPPT_Fav: UIWebView!
    
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
            self.navigationController?.title = detail.description
        }
        
        self.displayPPT_Fav.loadRequest(NSURLRequest(URL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(self.fileName, ofType: self.fileExt, inDirectory: "Songs/" + self.fileLang)!)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayPPT_Fav.scalesPageToFit = true;
        self.configureView()
        // Do any additional setup after loading the view.
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
        }
        else{
            navigationController?.navigationBarHidden = false
            tabBarController?.tabBar.hidden = true
        }
    }

}
