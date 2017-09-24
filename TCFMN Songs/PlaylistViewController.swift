//
//  PlaylistViewController.swift
//  TCFMN Songs
//
//  Created by Stephen Mylabathula on 6/6/16.
//  Copyright © 2016 Stephen Mylabathula. All rights reserved.
//

import UIKit
import MessageUI

class PlaylistViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var detailViewController: DetailViewController? = nil
    
    func email(){
        
        if self.tableView.visibleCells.count <= 0 {
            let alertController = UIAlertController(title: "Favorites is Empty", message: "You need to have at least one song in favorites before you can email it.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        let optionMenu = UIAlertController(title: "Email Options", message: nil, preferredStyle: .ActionSheet)

        let attachAction = UIAlertAction(title: "Include Song Slides", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sendEmail(true)
        })
        
        let noAttachAction = UIAlertAction(title: "Don't Include Slides", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.sendEmail(false)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })

        optionMenu.addAction(attachAction)
        optionMenu.addAction(noAttachAction)
        optionMenu.addAction(cancelAction)

        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func sendEmail(attachFiles: Bool) {
        let mailComposeViewController = self.configuredMailComposeViewController(attachFiles)
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(email))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.hidden = false
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // SECTION: Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (PlistManager.sharedInstance.getMutableDict()?.allKeys.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favCell", forIndexPath: indexPath)
        let valueAsRow = PlistManager.sharedInstance.getValueForKey(String(indexPath.row)) as! [String]
        cell.textLabel?.text = valueAsRow[1]
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // Return false if you do not want the specified item to be editable.
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if PlistManager.sharedInstance.getMutableDict()?.allKeys.count > 1 {
                PlistManager.sharedInstance.removeItemForKey(String(indexPath.row))
                let updatedDict = PlistManager.sharedInstance.getMutableDict()
                let values = updatedDict?.allValues
                PlistManager.sharedInstance.removeAllItemsFromPlist()
                for i in 0...(updatedDict?.count)!-1 {
                    PlistManager.sharedInstance.addNewItemWithKey(String(i), value: values![i])
                }
            } else {
                PlistManager.sharedInstance.removeAllItemsFromPlist()
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // SECTION: Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailFav" {
            let selectedRow = PlistManager.sharedInstance.getMutableDict()?.valueForKey(String(self.tableView.indexPathForSelectedRow!.row)) as! [String]
            let controller = segue.destinationViewController as! UINavigationController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            let detail = controller.topViewController as! FavoritesDetailViewController
            detail.title = selectedRow[1]
            detail.fileName = selectedRow[1]
            detail.fileExt = selectedRow[2]
            detail.fileLang = selectedRow[0]
        }
    }
    
    // SECTION: Mail Configuration
    func configuredMailComposeViewController(attachFiles: Bool) -> MFMailComposeViewController {
        
        let songdata = PlistManager.sharedInstance.getMutableDict()?.allValues as! [[String]]
        
        var message = "Favorite Songs <br> <ul>"
        for csd in songdata {
            message += "\n <li>" + csd[1] + "</li>"
        }
        message += "\n </ul>"
        
        print(message)
        if (attachFiles) {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setMessageBody(message, isHTML: true)
            
            for csd in songdata { //Lang, Name, Ext
                if let path = NSBundle.mainBundle().pathForResource(csd[1], ofType: csd[2], inDirectory: "Songs/" + csd[0]) {
                    if let filedata = NSData(contentsOfFile: path){
                        if csd[2] == "ppt" {
                            mailComposerVC.addAttachmentData(filedata, mimeType: "application/vnd.ms-powerpoint", fileName: csd[1])
                        } else {
                            mailComposerVC.addAttachmentData(filedata, mimeType: "application/vnd.openxmlformats-officedocument.presentationml.presentation", fileName: csd[1])
                        }
                    }
                }
            }
            
            return mailComposerVC
        } else {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setMessageBody(message, isHTML: true)
            return mailComposerVC
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Please check you email settings.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
