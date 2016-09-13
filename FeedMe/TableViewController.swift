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
    func didChangeFeedArray(_ newFeedArray: [RSSFeed])
}

class TableViewController: UITableViewController, SFSafariViewControllerDelegate, NewFeedDelegate {
    
    var feedArray = [RSSFeed]()
    var itemArray = [RSSItem]()
    var customTitle: String?
    
    //starter sites
    var addressArray = [URL(string: "http://machash.com/feed/")!,
                        URL(string: "http://rss.news.yahoo.com/rss/entertainment")!,
                        URL(string: "http://feeds.nytimes.com/nyt/rss/Technology")!]
    
    //NewFeedDelegate Function
    func didChangeFeedArray(_ newFeedArray: [RSSFeed]) {
        feedArray = newFeedArray
        getStuff()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var x = 0
        for feed in feedArray {
            print("feed #\(x): \(feed.title!)")
            x += 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initGetStuff()
        
        //intialize pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        }
    
    func refresh(_ sender: UIRefreshControl) {
        getStuff()
        self.tableView.reloadData()
        sender.endRefreshing()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //special initial getStuff() function to transfer addressArray starter sites to feedArray
    func initGetStuff() {
        
        //get articles from each feed, place in general array, sort by date, load images if possible
        for address in self.addressArray {
            let request: URLRequest = URLRequest(url: address)
            RSSParser.parseFeedForRequest(request, callback: { (feed, error) in
                if feed != nil {
                    feed!.rawLink = address
                    self.feedArray.append(feed!)
                for articles in feed!.items {
                    articles.feedName = feed!.title
                    if articles.imagesFromItemDescription != [] {
                        self.getDataFromUrl(articles.imagesFromItemDescription[0], completion: { (data, response, error) -> Void in
                            if error == nil {
                                articles.picture = UIImage(data: data!)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.tableView.reloadData()
                                })
                            }
                        })
                    }
                    self.itemArray.append(articles)
                    self.tableView.reloadData()
                }
                self.itemArray.sort { $0.pubDate!.compare($1.pubDate!) == .orderedDescending }
                }
            })
        }
    }
    
    //helper function to load pictures safely if they exist, see above
    func getDataFromUrl(_ url: URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
            }) .resume()
    }
    
    //parse all feeds in feedArray, and add them to itemArray for display
    func getStuff() {
        itemArray.removeAll() //remove exisitng items so there are no duplicates
        for eachFeed in self.feedArray {
            RSSParser.parseFeedForRequest(URLRequest(url: eachFeed.rawLink!), callback: { (feed, error) in
            if feed != nil {
                self.customTitle = eachFeed.customTitle ?? eachFeed.title!
                for articles in feed!.items {
                    articles.feedName = self.customTitle //sets custom/regular title to feedName if exists
                    if articles.imagesFromItemDescription != [] {
                        self.getDataFromUrl(articles.imagesFromItemDescription[0], completion: { (data, response, error) -> Void in
                            if error == nil {
                                articles.picture = UIImage(data: data!)
                                DispatchQueue.main.async(execute: { () -> Void in
                                    self.tableView.reloadData()
                                })
                            }
                        })
                    }
                    self.itemArray.append(articles)
                        }
                    }
                    self.itemArray.sort { $0.pubDate!.compare($1.pubDate!) == .orderedDescending }
                    self.tableView.reloadData()
                })
            }
    }
    
    //initalize table with data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Article") as! TableViewCell
        cell.setArticle(itemArray[(indexPath as NSIndexPath).row])
        return cell
    }
    
    //open link in SVC, fade article
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = itemArray[(indexPath as NSIndexPath).row].link
        let svc = SFSafariViewController(url: link! as URL, entersReaderIfAvailable: true)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
        tableView.cellForRow(at: indexPath)?.alpha = 0.4
    }
    
    //dismiss SVC
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) { controller.dismiss(animated: true, completion: nil) }
    
    //transfer feed data to feeds page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedList" {
            let destination = segue.destination as! FeedViewController
            destination.feedArrayInFeedView = feedArray
            }
        }
    
    func reload() {
        self.tableView.reloadData()
    }
    
    //CODE IN PROGRESS
    
    //initalize slideover options / mark as read, incomplete
    
    /*
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool { return true }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) { }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    var markAsReadOrNot = "Mark As Read"
    if tableView.cellForRowAtIndexPath(indexPath)!.alpha == 0.4 {
    markAsReadOrNot = "Mark As Unread"
    }
    if tableView.cellForRowAtIndexPath(indexPath)!.alpha == 1.0 {
    markAsReadOrNot = "Mark As Read"
    }
    
    let markAs = UITableViewRowAction(style: .Normal, title: markAsReadOrNot) { action, index in
    if markAsReadOrNot == "Mark As Read" {
    tableView.cellForRowAtIndexPath(indexPath)!.alpha = 0.4
    }
    if markAsReadOrNot == "Mark As Unread" {
    tableView.cellForRowAtIndexPath(indexPath)!.alpha = 1.0
    }
    self.tableView.setEditing(false, animated: true)
    }
    markAs.backgroundColor = UIColor.blueColor()
    return [markAs]
    }
    */
    
}


