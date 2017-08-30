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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setArticle(_ article: RSSItem!){
        
        headline.text = stringParser(article.title!)
        preview.text = stringParser(article.itemDescription!)
                
        // load article image; if it exists, display it (stored in RSSFeed class)
        if article.picture == nil {
            picView.image = article.picture
        }
        
        // If image exists, set picture; otherwise, hide imageView
        if let picture = article.picture {
            leadingSpace.constant = 8
            width.constant = 115
            picView.contentMode = .scaleAspectFit
            picView.image = picture
        } else {
            leadingSpace.constant = 0
            width.constant = 0
        }
        
        // Set feed name
        feedName.text = article.feedName
        
        // Set author name
        author.text = article.author != nil ? "by \(article.author!)" : ""
        
        // Set date of publication
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE h:mm a"
        time.text = formatter.string(from: article.pubDate! as Date)
        
    }
    
    func stringParser(_ input: String) -> String {
        
        var string = input
        
        // Remove anything in-between < and >
        while string.contains("<") && string.contains(">") {
            let range = string.range(of: "<")!.lowerBound..<string.range(of: ">")!.upperBound
            string.removeSubrange(range)
        }
        
        // Remove potential space at start of preview
        if string[string.startIndex] == " " {
            string = string.substring(from: string.characters.index(string.startIndex, offsetBy: 1))
        }
        
        // Remove occasional codes in strings that aren't parsed by RSSParser
        string = string.replacingOccurrences(of: "&#039;", with: "'")
        string = string.replacingOccurrences(of: "&quot;", with: "\"")
        string = string.replacingOccurrences(of: "&amp;", with: "&")
        string = string.replacingOccurrences(of: "&ldquo;", with: "\"")
        string = string.replacingOccurrences(of: "&rdquo;", with: "\"")
        string = string.replacingOccurrences(of: "&lsquo;", with: "\'")
        string = string.replacingOccurrences(of: "&rsquo;", with: "\'")
        string = string.replacingOccurrences(of: "&ndash;", with: "-")
        string = string.replacingOccurrences(of: "&mdash;", with: "–")
        
        return string
        
    }
    
    
}
