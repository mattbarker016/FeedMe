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
        
        "http://machash.com/feed/",
        "http://rss.news.yahoo.com/rss/entertainment",
        "http://feeds.nytimes.com/nyt/rss/Technology",
    
    ]
    
    // NewFeedDelegate Function
    func didChange(to newFeedArray: [RSSFeed]) {

        // TODO: Implement didChange
        
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
    
    
    
    //
    // MARK: Storyboard Functions
    //
    
    
    
    /// Transfer feed data to feeds page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // TODO: Implement prepare!
        
    }
    
    
    
}


