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
        
        "http://machash.com/feed/",
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
        
        loadFeeds()
        
        // Intialize pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(tableView, action: #selector(UITableView.reloadData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        title = "FeedMe"
        
    }
    
    func refresh(_ sender: UIRefreshControl) {
        itemArray.removeAll()
        feedArray.removeAll()
        loadFeeds()
        sender.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Helper function to load pictures safely if they exist, see above
    func getImageData(from url: URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void)) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
    /// Load feed from URL address
    func loadFeeds() {
        
        for address in addressArray {
            let request: URLRequest = URLRequest(url: URL(string: address)!)
            RSSParser.parseFeedForRequest(request) { (feed, error) in
                if error == nil {
                    self.parse(feed)
                } else {
                    print("[TableViewController] loadFeeds Error:", error!.localizedDescription)
                }
            }
        }
        
    }
    
    /// Parse the RSSFeed to retrieve feed name, articles, images, etc.
    func parse(_ feed: RSSFeed?) {
        
        if feed != nil {
            
            feedArray.append(feed!)
            
            for articles in feed!.items {
                articles.feedName = feed?.title // sets custom/regular title to feedName if exists
                if articles.imagesFromItemDescription != [] {
                    self.getImageData(from: articles.imagesFromItemDescription[0]) { (data, response, error) in
                        if error == nil {
                            articles.picture = UIImage(data: data!)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
                self.itemArray.append(articles)
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
            destination.feedArray = feedArray
        }
    }
    
}


