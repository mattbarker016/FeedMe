//
//  TableViewController.swift
//  FeedMe
//
//  Created by Matt Barker on 11/24/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit
import SafariServices

protocol NewFeedDelegate {
    func didChange(to newFeedArray: [RSSFeed])
}

class TableViewController: UITableViewController, SFSafariViewControllerDelegate, NewFeedDelegate {
    
    var itemArray = [RSSItem]()
    
    var feedArray = [RSSFeed]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Starter sites
    var addressArray = [
        
        "http://rss.news.yahoo.com/rss/entertainment",
    
    ]
    
    // NewFeedDelegate Function
    func didChange(to newFeedArray: [RSSFeed]) {

        // TODO: Implement didChange
        // Hint: You need to update something on this file somehow...
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FeedMe"
        
        // Intialize pull to refresh
        let spinner = UIRefreshControl()
        spinner.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl = spinner
        
        // Begin initial loading
        loadFeeds()
        
    }
    
    
    //
    // MARK: RSS Functions
    //
    
    
    /// Handle the refresh action
    func refresh(_ sender: UIRefreshControl) {
        loadFeeds()
    }
    
    /// Helper function that returns UIImage if image exists. Returns nil if none
    func getImageData(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        
        guard let imageURL = url
        else {
            print("[TableViewController] getImageData URL Doesn't Exist!")
            completion(nil); return
        }
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if data != nil && error == nil {
                completion(UIImage(data: data!))
            } else {
                print("[TableViewController] getImageData error:", error!.localizedDescription)
                completion(nil)
            }
        }.resume()
        
    }
    
    /// Load feed from URL address
    func loadFeeds() {

        // TODO: Implement loadFeeds!
        
        // 1. Clear any existing data
        
        // 2. Make a URLRequest FOR all addresses and use a `RSSParser` function to parseFeedForRequest
        
        // 3. Store the address of the feed within the feed.rawLink variable
        
        // 4. SAFELY parse the new feed, and stop refreshControl from refreshing
        
    }
    
    /// Parse the RSSFeed to retrieve feed name, articles, images, etc.
    func parse(_ feed: RSSFeed?) {
        
        if feed != nil {
            
            feedArray.append(feed!)
            
            for article in feed!.items {
                
                article.feedName = feed?.title
                
                // If there is an image associated with the article, load and add it to article
                if !article.imagesFromItemDescription.isEmpty {
                    self.getImageData(from: article.imagesFromItemDescription.first) { (image) in
                        article.picture = image
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
                self.itemArray.append(article)
                
            }
            
            // Sort articles recent-first, and reload
            itemArray.sort { $0.pubDate!.compare($1.pubDate!) == .orderedDescending }
            tableView.reloadData()
            
        }
        
        else {
            print("[TableViewController] parse: Feed doesn't exist!")
        }
        
    }
    
    
    
    //
    // MARK: Table View Functions
    //
    
    
    
    // TODO: Implement Table View Functions!
    // Hint: Xcode autocomplete is a glorious thing... try looking for `tableView` functions
    
    // 1. How many ROWS in a section?
    
    // 2. What should the CELL at a ROW look like?
    
    // 3. What should happen when you SELECT a CELL?
    
    
    
    //
    // MARK: Storyboard Functions
    //
    
    
    
    /// Transfer feed data to feeds page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // TODO: Implement prepare!
        // Hint: Set the important variables on the segue.destination view controller
        
    }
    
    
    
}


