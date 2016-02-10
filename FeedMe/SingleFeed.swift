//
//  File.swift
//  FeedMe
//
//  Created by Matthew Barker on 2/6/16.
//  Copyright © 2016 Matt Barker. All rights reserved.
//

import UIKit
import Foundation

class SingleFeed: UITableViewController {
    
    var array = [RSSItem]()

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(array.count)")
        return array.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("making cell")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        cell.setArticle(array[indexPath.row])
        return cell
    }
    
}