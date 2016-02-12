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
    func didChangeFeedArray(newFeedArray: [RSSFeed])
}

class TableViewController: UITableViewController, SFSafariViewControllerDelegate, NewFeedDelegate {
    
    var feedArray = [RSSFeed]()
    var itemArray = [RSSItem]()
    var customTitle: String?
    
    //starter sites
    var addressArray = [NSURL(string: "http://machash.com/feed/")!,
                        NSURL(string: "http://rss.news.yahoo.com/rss/entertainment")!,
                        NSURL(string: "http://feeds.nytimes.com/nyt/rss/Technology")!]
    
    //NewFeedDelegate Function
    func didChangeFeedArray(newFeedArray: [RSSFeed]) {
        feedArray = newFeedArray
        getStuff()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initGetStuff()
        
        //intialize refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        }
    
    func refresh(sender: UIRefreshControl) {
        getStuff()
        self.tableView.reloadData()
        sender.endRefreshing()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //special initial getStuff() function to transder addressArray starter sites to feedArray
    func initGetStuff() {
        
        //get articles from each feed, place in general array, sort by date
        for address in self.addressArray {
            let request: NSURLRequest = NSURLRequest(URL: address)
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
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.tableView.reloadData()
                                })
                            }
                        })
                    }
                    self.itemArray.append(articles)
                }
                self.itemArray.sortInPlace { $0.pubDate!.compare($1.pubDate!) == .OrderedDescending }
                self.tableView.reloadData()
                }
            })
        }
    }
    
    //helper function to load pictures safely if they exist, see above
    func getDataFromUrl(url: NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    //parse all feeds in feedArray, and add them to itemArray for display
    func getStuff() {
        
        itemArray.removeAll() //remove exisitng items so there are no duplicates
        for eachFeed in self.feedArray {
            RSSParser.parseFeedForRequest(NSURLRequest(URL: eachFeed.rawLink!), callback: { (feed, error) in
            if feed != nil {
                self.customTitle = eachFeed.customTitle ?? eachFeed.title!
                for articles in feed!.items {
                    articles.feedName = self.customTitle //sets custom/regular title to feedName if exists
                    if articles.imagesFromItemDescription != [] {
                        self.getDataFromUrl(articles.imagesFromItemDescription[0], completion: { (data, response, error) -> Void in
                            if error == nil {
                                articles.picture = UIImage(data: data!)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.tableView.reloadData()
                                })
                            }
                        })
                    }
                    self.itemArray.append(articles)
                        }
                    }
                    self.itemArray.sortInPlace { $0.pubDate!.compare($1.pubDate!) == .OrderedDescending }
                    self.tableView.reloadData()
                })
            }
    }
    
    //initalize table with data
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Article") as! TableViewCell
        cell.setArticle(itemArray[indexPath.row])
        return cell
    }
    
    
    
    //open link in SVC, fade article
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let link = itemArray[indexPath.row].link
        let svc = SFSafariViewController(URL: link!, entersReaderIfAvailable: true)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
        tableView.cellForRowAtIndexPath(indexPath)?.alpha = 0.4
    }
    
    //dismiss SVC
    func safariViewControllerDidFinish(controller: SFSafariViewController) { controller.dismissViewControllerAnimated(true, completion: nil) }
    
    //transfer feed data to feeds page
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "feedList" {
            let destination = segue.destinationViewController as! FeedViewController
            destination.feedArrayInFeedView = feedArray
            }
        }
    
    func reload() {
        self.tableView.reloadData()
    }
    
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


