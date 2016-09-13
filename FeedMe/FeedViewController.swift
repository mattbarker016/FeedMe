//
//  FeedViewController.swift
//  FeedMe
//
//  Created by Matt Barker on 11/30/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit
import SafariServices

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,
                            SFSafariViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newFeedTextField: UITextField!
    @IBOutlet weak var feedStatus: UILabel!
    @IBOutlet weak var addNewFeed: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NewFeedDelegate?
    var feedArrayInFeedView = [RSSFeed]()
    var singleFeedArray = [RSSItem]()
    var newLink: URL?
    var alertController: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newFeedTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        feedStatus.textColor = UIColor.darkText
        feedStatus.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feedStatus.textColor = UIColor.darkText
        feedStatus.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArrayInFeedView.count
    }
    
    //set each RSSFeed info to appear in table for list of feeds
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Feed") as! FeedViewCell
        cell.setFeed(feedArrayInFeedView[(indexPath as NSIndexPath).row])
        return cell
    }
    
    //allows table cells to be edited
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //remove feed from feedList
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            self.feedArrayInFeedView.remove(at: (indexPath as NSIndexPath).row)
            //prepareForSegue transfer more stable?
            self.delegate?.didChangeFeedArray(self.feedArrayInFeedView)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            self.feedStatus.isHidden = false
            self.feedStatus.text = "Feed Removed!"
            self.feedStatus.textColor = UIColor.green
        }
        delete.backgroundColor = UIColor.red
        
        let rename = UITableViewRowAction(style: .normal, title: "Rename") { action, index in
            
            //create rename dialog box
            self.alertController = UIAlertController(title: "Change Feed Name", message: nil, preferredStyle: .alert)
            self.alertController!.addTextField( configurationHandler: {(textField: UITextField!) in
                    textField.text = self.feedArrayInFeedView[(indexPath as NSIndexPath).row].customTitle ?? self.feedArrayInFeedView[(indexPath as NSIndexPath).row].title })
            
            let action = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {[weak self] (paramAction:UIAlertAction!) in
                    if let textFields = self!.alertController?.textFields {
                        let theTextFields = textFields as [UITextField]
                        if theTextFields[0].text != "" {
                            self!.feedArrayInFeedView[(indexPath as NSIndexPath).row].customTitle = theTextFields[0].text
                            self!.delegate?.didChangeFeedArray(self!.feedArrayInFeedView)
                            tableView.reloadData()
                        }
                        self!.tableView.setEditing(false, animated: true)
                        self!.feedStatus.isHidden = false
                        self!.feedStatus.text = "Feed Renamed!"
                        self!.feedStatus.textColor = UIColor.green
                    }
                })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {[weak self] (paramAction:UIAlertAction!) in self!.tableView.setEditing(false, animated: true)})
            self.alertController?.addAction(action)
            self.alertController?.addAction(cancel)
            self.automaticallyAdjustsScrollViewInsets = false
            self.present(self.alertController!, animated: true, completion: nil)
            
        }
        rename.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        return [delete, rename]
    }

    //checks if feed already exists in list
    func checkDup(_ feed: RSSFeed, url: URL) -> Bool {
        for everyHomePage in self.feedArrayInFeedView {
            if everyHomePage.link == feed.link {
                self.feedStatus.text = "Feed Already In List!"
                self.feedStatus.textColor = UIColor.red
                return false
                    }
        }
        return true
    }
    
    //parse and save new url feed
    @IBAction func saveFeed() {
        if let validURL = URL(string: newFeedTextField.text!) {
            let request: URLRequest = URLRequest(url: validURL)
            RSSParser.parseFeedForRequest(request, callback: { (feed, error) in
                if feed != nil && self.checkDup(feed!, url: validURL) {
                    feed!.rawLink = validURL
                    self.feedArrayInFeedView.append(feed!)
                    self.tableView.reloadData()
                    self.delegate?.didChangeFeedArray(self.feedArrayInFeedView)
                    self.feedStatus.text = "Feed Successfully Added!"
                    self.feedStatus.textColor = UIColor.green
                        }
                //nothing in textfield
                if self.newFeedTextField.text == "" {
                    self.feedStatus.text = "Enter Something First!"
                    self.feedStatus.textColor = UIColor.red
                        }
                //not a valid url
                if feed == nil {
                    self.feedStatus.text = "Invalid Feed"
                    self.feedStatus.textColor = UIColor.red
                        }
                self.feedStatus.isHidden = false
                self.newFeedTextField.text = ""
                self.tableView.reloadData()
            })
        }
        view.endEditing(true)
    }
    
    //keyboard: return key fires saveFeed, dismisses keyboard (as well as through any other touch)
    func textFieldShouldReturn(_ newFeedTextField: UITextField) -> Bool {
        newFeedTextField.resignFirstResponder()
        saveFeed()
        return true
    }
    
    //open feed homepage if tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = feedArrayInFeedView[(indexPath as NSIndexPath).row].link
        let svc = SFSafariViewController(url: link! as URL)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //dismiss SVC
    func safariViewControllerDidFinish(_ controller: SFSafariViewController)
    { controller.dismiss(animated: true, completion: nil) }
    
    @IBAction func unwindToFeedView(_ sender: UIStoryboardSegue) { }
    
}

