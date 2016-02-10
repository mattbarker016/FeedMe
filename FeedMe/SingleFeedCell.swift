//
//  SingleFeedCell.swift
//  FeedMe
//
//  Created by Matt Barker on 11/24/15.
//  Copyright © 2015 Matt Barker. All rights reserved.
//

import UIKit

class SingleFeedCell: UITableViewCell {
    
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
        
        headline.text = article.title
        
        //parse preview
        var snippet = article.itemDescription!
        //remove anything inbetween < and >
        while snippet.containsString("<") && snippet.containsString(">") {
            let range = Range<String.Index>(start: snippet.rangeOfString("<")!.maxElement()!, end: snippet.rangeOfString(">")!.minElement()!.advancedBy(1))
            snippet.removeRange(range)
        }
        //remove potential space at start of preview
        if snippet[snippet.startIndex] == " " {
            snippet = snippet.substringFromIndex(snippet.startIndex.advancedBy(1))
        }
        
        preview.text = snippet
        
        //load article image; if it exists, display it (stored in RSSFeed class)
        if article.imagesFromItemDescription != [] && article.picture == nil {
            if let pic = UIImage(data: NSData(contentsOfURL: article.imagesFromItemDescription[0])!) {
                article.picture = pic
                picView.image = pic
            }
        }
        
        //load picture if there is one, otherwise "delete" picture view
        if article.picture != nil {
            self.leadingSpace.constant = 8
            self.width.constant = 115
            picView.contentMode = .ScaleAspectFit
            picView.image = article.picture
        }
        else {
            self.leadingSpace.constant = 0
            self.width.constant = 0
        }
        
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
}
