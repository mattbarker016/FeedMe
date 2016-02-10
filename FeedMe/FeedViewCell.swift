//
//  FeedViewCell.swift
//  FeedMe
//
//  Created by Matt Barker on 11/30/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit

class FeedViewCell: UITableViewCell {
    
    @IBOutlet weak var feedName: UILabel!
    @IBOutlet weak var websiteURL: UILabel!
    @IBOutlet weak var feedDescrip: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setFeed(feed: RSSFeed!) {
        if feed.customTitle != nil {
            feedName.text = feed.customTitle
        } else {
            feedName.text = feed.title
        }
        websiteURL.text = "tap to visit \(feed.link!)"
        feedDescrip.text = feed.feedDescription
    }

}
