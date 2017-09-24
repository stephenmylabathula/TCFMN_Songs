//
//  MasterViewController.swift
//  TCFMN Songs
//
//  Created by Stephen Mylabathula on 5/28/16.
//  Copyright © 2016 Stephen Mylabathula. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [[String]]()
    
    func updateObjects(){
        
        //Get the URL string to songs_list CSV
        let pathToSongList = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("songs_list", ofType: "csv")!).path
        
        do {
            let fileContents_NSString = try NSString(contentsOfFile: pathToSongList!, encoding: NSUTF8StringEncoding)
            let individualSongData = fileContents_NSString.componentsSeparatedByString("\n")
            var songDataArray = [[String]]()
            
            for i in 1...individualSongData.count-1 {
                songDataArray.append(individualSongData[i].componentsSeparatedByString(", "))
            }
            self.objects = songDataArray
 
        } catch {
            //do nothing
        }
    }
    
    func getLanguages() -> [String] {
        var songLanguages = [String]()
        
        for i in 0...objects.count-1 {
            if !songLanguages.contains(objects[i][0]){
                songLanguages.append(objects[i][0])
            }
        }
        return songLanguages
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateObjects()
    
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    //SECTION: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let language = getLanguages()[(self.tableView.indexPathForSelectedRow?.row)!]
        var songsForLanguage = [[String]]()
        
        for song in objects {
            if song[0] == language {
                songsForLanguage.append(song)
            }
        }
        
        if segue.identifier == "showSongs" {
            let controller = (segue.destinationViewController as! UITableViewController) as! SongsTableViewController;
            controller.songObjects = songsForLanguage;
            controller.title = language;
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem();
            controller.navigationItem.leftItemsSupplementBackButton = true;
        }
    }

    //SECTION: Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getLanguages().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let languages = getLanguages();
        let object = languages[indexPath.row]
        cell.textLabel!.text = object;
        return cell;
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }


}

