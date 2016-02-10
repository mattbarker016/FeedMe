//
//  FeedViewController.swift
//  FeedMe
//
//  Created by Matt Barker on 11/30/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit
import SafariServices

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, SFSafariViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newFeedTextField: UITextField!
    @IBOutlet weak var feedStatus: UILabel!
    @IBOutlet weak var addNewFeed: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NewFeedDelegate?
    var feedArrayInFeedView = [RSSFeed]()
    var singleFeedArray = [RSSItem]()
    var newLink: NSURL?
    var alertController: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newFeedTextField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        feedStatus.textColor = UIColor.darkTextColor()
        feedStatus.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        feedStatus.textColor = UIColor.darkTextColor()
        feedStatus.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArrayInFeedView.count
    }
    
    //set each RSSFeed info to appear in table for list of feeds
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Feed") as! FeedViewCell
        cell.setFeed(feedArrayInFeedView[indexPath.row])
        return cell
    }
    
    //allows table cells to be edited
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool { return true }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) { }
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //remove feed from feedList
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.feedArrayInFeedView.removeAtIndex(indexPath.row)
            self.delegate?.didChangeFeedArray(self.feedArrayInFeedView)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.feedStatus.hidden = false
            self.feedStatus.text = "Feed Removed!"
            self.feedStatus.textColor = UIColor.greenColor()
        }
        delete.backgroundColor = UIColor.redColor()
        
        let rename = UITableViewRowAction(style: .Normal, title: "Rename") { action, index in
            
            //create rename dialog box
            self.alertController = UIAlertController(title: "Change Feed Name", message: nil, preferredStyle: .Alert)
            self.alertController!.addTextFieldWithConfigurationHandler( {(textField: UITextField!) in
                    textField.text = self.feedArrayInFeedView[indexPath.row].customTitle ?? self.feedArrayInFeedView[indexPath.row].title })
            
            let action = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {[weak self] (paramAction:UIAlertAction!) in
                    if let textFields = self!.alertController?.textFields {
                        let theTextFields = textFields as [UITextField]
                        if theTextFields[0].text != "" {
                            self!.feedArrayInFeedView[indexPath.row].customTitle = theTextFields[0].text
                            self!.delegate?.didChangeFeedArray(self!.feedArrayInFeedView)
                            tableView.reloadData()
                        }
                        self!.tableView.setEditing(false, animated: true)
                        self!.feedStatus.hidden = false
                        self!.feedStatus.text = "Feed Renamed!"
                        self!.feedStatus.textColor = UIColor.greenColor()
                    }
                })
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {[weak self] (paramAction:UIAlertAction!) in self!.tableView.setEditing(false, animated: true)})
            self.alertController?.addAction(action)
            self.alertController?.addAction(cancel)
            self.automaticallyAdjustsScrollViewInsets = false
            self.presentViewController(self.alertController!, animated: true, completion: nil)
            
        }
        rename.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        return [delete, rename]
    }

    //checks if feed already exists in list
    func checkDup(feed: RSSFeed, url: NSURL) -> Bool {
        for everyHomePage in self.feedArrayInFeedView {
            if everyHomePage.link == feed.link {
                self.feedStatus.text = "Feed Already In List!"
                self.feedStatus.textColor = UIColor.redColor()
                return false
                    }
        }
        return true
    }
    
    //parse and save new url feed
    @IBAction func saveFeed() {
        if let validURL = NSURL(string: newFeedTextField.text!) {
            let request: NSURLRequest = NSURLRequest(URL: validURL)
            RSSParser.parseFeedForRequest(request, callback: { (feed, error) in
                if feed != nil && self.checkDup(feed!, url: validURL) {
                    feed!.rawLink = validURL
                    self.feedArrayInFeedView.append(feed!)
                    self.tableView.reloadData()
                    self.delegate?.didChangeFeedArray(self.feedArrayInFeedView)
                    self.feedStatus.text = "Feed Successfully Added!"
                    self.feedStatus.textColor = UIColor.greenColor()
                        }
                //nothing in textfield
                if self.newFeedTextField.text == "" {
                    self.feedStatus.text = "Enter Something First!"
                    self.feedStatus.textColor = UIColor.redColor()
                        }
                //not a valid url
                if feed == nil {
                    self.feedStatus.text = "Invalid Feed"
                    self.feedStatus.textColor = UIColor.redColor()
                        }
                self.feedStatus.hidden = false
                self.newFeedTextField.text = ""
                self.tableView.reloadData()
            })
        }
        view.endEditing(true)
    }
    
    //keyboard: return key fires saveFeed, dismisses keyboard (as well as through any other touch)
    func textFieldShouldReturn(newFeedTextField: UITextField) -> Bool {
        newFeedTextField.resignFirstResponder()
        saveFeed()
        return true
    }
    
    //open feed homepage if tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let link = feedArrayInFeedView[indexPath.row].link
        let svc = SFSafariViewController(URL: link!)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //dismiss SVC
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    { controller.dismissViewControllerAnimated(true, completion: nil) }
    
    @IBAction func unwindToFeedView(sender: UIStoryboardSegue) { }
    
}

