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
    
    @IBOutlet weak var addNewFeed: UILabel!
    @IBOutlet weak var newFeedTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var feedArray = [RSSFeed]()
    
    var delegate: NewFeedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        newFeedTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UITableView Data Source and Delegate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Feed")!
        cell.textLabel?.text = feedArray[indexPath.row].title
        cell.detailTextLabel?.text = feedArray[indexPath.row].link?.absoluteString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feed = feedArray[indexPath.row]
        let safariViewController = SFSafariViewController(url: feed.link!)
        present(safariViewController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Cell Editing Functions
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Create Delete option for UITableViewCell swipe
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.feedArray.remove(at: indexPath.row)
            self.delegate?.didChange(to: self.feedArray)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        delete.backgroundColor = .red
        
        return [delete]
        
    }
    
    // MARK: Other Functions
    
    /// Parse and save new URL as RSS Feed
    @IBAction func saveFeed() {
        
        if let validURL = URL(string: newFeedTextField.text ?? "") {
            
            let request: URLRequest = URLRequest(url: validURL)
            
            RSSParser.parseFeedForRequest(request) { (feed, error) in
                
                // Save feed
                if feed != nil {
                    feed!.rawLink = validURL
                    self.feedArray.append(feed!)
                    self.delegate?.didChange(to: self.feedArray)
                }
                
                // Show error message
                else {
                    let title = "Invalid Feed"
                    let message = "Please enter a valid RSS feed URL!"
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                }
                
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
    
    @IBAction func unwindToFeedView(_ sender: UIStoryboardSegue) { }
    
}

