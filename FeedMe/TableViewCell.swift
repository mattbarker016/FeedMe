//
//  TableViewCell.swift
//  FeedMe
//
//  Created by Matt Barker on 11/24/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var picView: UIImageView!
    @IBOutlet weak var headline: UILabel!
    @IBOutlet weak var preview: UITextView!
    @IBOutlet weak var feedName: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var leadingSpace: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setArticle(article: RSSItem!){
        
        dispatch_async(dispatch_get_main_queue(), {
            self.headline.text = self.stringParser(article.title!)
            self.preview.text = self.stringParser(article.itemDescription!)
        })
        
        //load article image; if it exists, display it (stored in RSSFeed class)
        dispatch_async(dispatch_get_main_queue(), {
            if article.picture == nil {
                self.picView.image = article.picture
            }
        })
        
        //load picture if there is one, otherwise "delete" picture view
        dispatch_async(dispatch_get_main_queue(), {
            if article.picture != nil {
                self.leadingSpace.constant = 8
                self.width.constant = 115
                self.picView.contentMode = .ScaleAspectFit
                self.picView.image = article.picture
            
            }
            else {
                self.leadingSpace.constant = 0
                self.width.constant = 0
            }
        })
        
        feedName.text = article.feedName
        
        //load author if it exists
        author.text = ""
        if article.author != nil {
            author.text = "by "+article.author!
        }
        
        //create date of article based on pubDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE h:mm a"
        time.text = formatter.stringFromDate(article.pubDate!)
    }
    
    func stringParser(input: String) -> String {
        
        var string = input
        
        //remove anything in-between < and >
        while string.containsString("<") && string.containsString(">") {
            let range = string.rangeOfString("<")!.maxElement()!..<string.rangeOfString(">")!.minElement()!.advancedBy(1)
            //let range = Range<String.Index>(start: string.rangeOfString("<")!.maxElement()!, end: string.rangeOfString(">")!.minElement()!.advancedBy(1))
            string.removeRange(range)
        }
        //remove potential space at start of preview
        if string[string.startIndex] == " " {
            string = string.substringFromIndex(string.startIndex.advancedBy(1))
        }
        
        //remove occasional codes in strings that aren't parsed by RSSParser
        string = string.stringByReplacingOccurrencesOfString("&#039;", withString: "'")
        string = string.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        string = string.stringByReplacingOccurrencesOfString("&ldquo;", withString: "\"")
        string = string.stringByReplacingOccurrencesOfString("&rdquo;", withString: "\"")
        string = string.stringByReplacingOccurrencesOfString("&lsquo;", withString: "\'")
        string = string.stringByReplacingOccurrencesOfString("&rsquo;", withString: "\'")
        string = string.stringByReplacingOccurrencesOfString("&ndash;", withString: "-")
        string = string.stringByReplacingOccurrencesOfString("&mdash;", withString: "–")
        
        return string
    }
    
    
}
