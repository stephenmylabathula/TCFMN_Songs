//
//  SongsTableViewController.swift
//  TCFMN Songs
//
//  Created by Stephen Mylabathula on 5/28/16.
//  Copyright © 2016 Stephen Mylabathula. All rights reserved.
//

import UIKit

class SongsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var songObjects = [[String]]()
    var filteredSongObjects = [[String]]()
    var songDictionary = NSDictionary()
    @IBOutlet weak var searchBar: UISearchBar!
    
    //var alphabets = "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
    //var indexOfAlpha = [String]()
    
    var searchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        //indexOfAlpha = alphabets.componentsSeparatedByString(" ")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if searchBar.text == "" {
            //do nothing
        } else {
            print("began edit")
            searchActive = true;
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        //searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print("Canceled")
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("Search Clicked")
        //searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredSongObjects = songObjects.filter({ (row) -> Bool in
            let tmp = row[1]
            let conSub = tmp.lowercaseString.containsString(searchText.lowercaseString)//tmp.rangeOfString(searchText)
            return conSub
        })
        if(searchText == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //SECTION: Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filteredSongObjects.count
        }
        return songObjects.count
        /*return songObjects.count*/
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath)
        
        if(searchActive){
            cell.textLabel?.text = filteredSongObjects[indexPath.row][1];
        } else {
            cell.textLabel?.text = songObjects[indexPath.row][1];
        }
        
        //cell.textLabel?.text = songObjects[indexPath.row][1]
        return cell
    }
    

    //SECTION: Segue

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var selectedRow = [String]()
            if searchActive {
                selectedRow = filteredSongObjects[(self.tableView.indexPathForSelectedRow?.row)!]
            } else {
                selectedRow = songObjects[(self.tableView.indexPathForSelectedRow?.row)!]
            }
            let controller = segue.destinationViewController as! UINavigationController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            let detail = controller.topViewController as! DetailViewController
            detail.title = selectedRow[1]
            detail.fileName = selectedRow[1]
            detail.fileExt = selectedRow[2]
            detail.fileLang = selectedRow[0]
        }
    }
    
}
