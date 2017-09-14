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
    
    // TODO: Add delegate variable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Set dataSource and delegate
        // Hint: Look at the classes after `FeedViewController`.
        
    }
    
    
    
    //
    // MARK: Table View Functions
    //
    
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
        present(safariViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    //
    // MARK: Storyboard Functions
    //
    
    
    // TODO: Implement unwindToFeedViewController!
    
    
    
    //
    // MARK: NewFeedDelegate Functions
    //
    
    
    
    /// Parse and save new URL as a RSS Feed
    @IBAction func saveFeed() {
        
        // TODO: Implement saveFeed!
        
        // 1. Get the new URL from the `newFeedTextField`
        
        // 2. Get the RSSFeed object (like in loadFeeds() in TableViewController.swift)
        
        // 3. Reload / Reset the proper variables on-screen to load the new information
        
        // Challenge: What should you do the URL isn't valid or the feed object doesn't exist?
        
        view.endEditing(true)
        
    }
    
    
    
    //
    // MARK: Other Functions
    //

    
    /// Fires when the `Return` key of the keyboard is pressed.
    func textFieldShouldReturn(_ newFeedTextField: UITextField) -> Bool {
        newFeedTextField.resignFirstResponder()
        saveFeed()
        return true
    }
    
}

