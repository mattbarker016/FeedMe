//
//  FeedViewController.swift
//  FeedMe
//
//  Created by Matt Barker on 11/30/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit
import SafariServices

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var newFeedTextField: UITextField!
    @IBOutlet weak var feedStatus: UILabel!
    @IBOutlet weak var addNewFeed: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NewFeedDelegate?
    var feedArray = [RSSFeed]()

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
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Feed")!
        cell.textLabel?.text = feedArray[indexPath.row].title
        cell.detailTextLabel?.text = feedArray[indexPath.row].link?.absoluteString
        return cell
    }
    
    // MARK: Cell Editing Functions
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.feedArray.remove(at: indexPath.row)
            self.delegate?.didChange(to: self.feedArray)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.feedStatus.isHidden = false
            self.feedStatus.text = "Feed Removed!"
            self.feedStatus.textColor = .green
        }
        
        delete.backgroundColor = .red
        
        return [delete]
        
    }

    // Check if feed already exists in list
    func checkDup(_ existingFeed: RSSFeed, url: URL) -> Bool {
        for feed in feedArray {
            if feed.link == existingFeed.link {
                self.feedStatus.text = "Feed Already In List!"
                self.feedStatus.textColor = .red
                return false
            }
        }
        return true
    }
    
    //parse and save new url feed
    @IBAction func saveFeed() {
        
        if let validURL = URL(string: newFeedTextField.text!) {
            
            let request: URLRequest = URLRequest(url: validURL)
            
            RSSParser.parseFeedForRequest(request) { (feed, error) in
                
                if feed != nil && self.checkDup(feed!, url: validURL) {
                    feed!.rawLink = validURL
                    self.feedArray.append(feed!)
                    self.tableView.reloadData()
                    self.delegate?.didChange(to: self.feedArray)
                    self.feedStatus.text = "Feed Successfully Added!"
                    self.feedStatus.textColor = UIColor.green
                }
                
                // nothing in textfield
                if self.newFeedTextField.text == "" {
                    self.feedStatus.text = "Enter Something First!"
                    self.feedStatus.textColor = UIColor.red
                }
                
                // not a valid url
                if feed == nil {
                    self.feedStatus.text = "Invalid Feed"
                    self.feedStatus.textColor = UIColor.red
                }
                
                self.feedStatus.isHidden = false
                self.newFeedTextField.text = ""
                self.tableView.reloadData()
                
            }
        }
        
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ newFeedTextField: UITextField) -> Bool {
        newFeedTextField.resignFirstResponder()
        saveFeed()
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = feedArray[indexPath.row]
        let safariViewController = SFSafariViewController(url: feed.link!)
        present(safariViewController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindToFeedView(_ sender: UIStoryboardSegue) { }
    
}

