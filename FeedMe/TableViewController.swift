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
    var feedArray = [RSSFeed]()
    
    // Starter sites
    var addressArray = [
        
        "http://rss.news.yahoo.com/rss/entertainment",
        "http://feeds.nytimes.com/nyt/rss/Technology",
    
    ]
    
    //NewFeedDelegate Function
    func didChange(to newFeedArray: [RSSFeed]) {
        feedArray = newFeedArray
        addressArray = feedArray.flatMap { $0.rawLink!.absoluteString }
        loadFeeds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up view
        title = "FeedMe"
        
        // Intialize pull to refresh
        let spinner = UIRefreshControl()
        spinner.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl = spinner
        
        // Begin initial loading
        loadFeeds()
        
    }
    
    func refresh(_ sender: UIRefreshControl) {
        loadFeeds()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

        itemArray.removeAll()
        feedArray.removeAll()
        
        var index = 0
        for address in addressArray {
            
            let request: URLRequest = URLRequest(url: URL(string: address)!)
            
            RSSParser.parseFeedForRequest(request) { (feed, error) in
                
                if error == nil {
                    feed?.rawLink = URL(string: address)
                    self.parse(feed)
                } else {
                    print("[TableViewController] loadFeeds Error:", error!.localizedDescription)
                }
                
                index += 1
                
                // End refresh on last task completion
                if index == self.addressArray.count - 1 {
                    self.refreshControl?.endRefreshing()
                }
                
            }
            
        }
        
    }
    
    /// Parse the RSSFeed to retrieve feed name, articles, images, etc.
    func parse(_ feed: RSSFeed?) {
        
        if feed != nil {
            
            feedArray.append(feed!)
            
            for article in feed!.items {
                
                article.feedName = feed?.title
                
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
            
            itemArray.sort { $0.pubDate!.compare($1.pubDate!) == .orderedDescending }
            tableView.reloadData()
            
        }
        
        else {
            print("[TableViewController] parse: Feed doesn't exist!")
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article") as! TableViewCell
        cell.setArticle(itemArray[indexPath.row])
        return cell
    }
    
    /// Open link in SVC, fade article
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = itemArray[indexPath.row].link
        let safariViewController = SFSafariViewController(url: link!, entersReaderIfAvailable: true)
        present(safariViewController, animated: true, completion: nil)
        tableView.cellForRow(at: indexPath)?.alpha = 0.4
    }
    
    /// Transfer feed data to feeds page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedList" {
            let destination = segue.destination as! FeedViewController
            destination.delegate = self
            destination.feedArray = feedArray
        }
    }
    
}


