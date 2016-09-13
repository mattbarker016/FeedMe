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
        
        //set headline and preview
        DispatchQueue.main.async(execute: {
            self.headline.text = self.stringParser(article.title!)
            self.preview.text = self.stringParser(article.itemDescription!)
        })
        
        //load article image; if it exists, display it (stored in RSSFeed class)
        DispatchQueue.main.async(execute: {
            if article.picture == nil {
                self.picView.image = article.picture
            }
        })
        
        //load picture if there is one, otherwise "delete" picture view
        DispatchQueue.main.async(execute: {
            if article.picture != nil {
                self.leadingSpace.constant = 8
                self.width.constant = 115
                self.picView.contentMode = .scaleAspectFit
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
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE h:mm a"
        time.text = formatter.string(from: article.pubDate! as Date)
    }
    
    func stringParser(_ input: String) -> String {
        
        var string = input
        
        //remove anything in-between < and >
        while string.contains("<") && string.contains(">") {
            let range = string.range(of: "<")!.lowerBound..<string.range(of: ">")!.upperBound
            string.removeSubrange(range)
        }
        //remove potential space at start of preview
        if string[string.startIndex] == " " {
            string = string.substring(from: string.characters.index(string.startIndex, offsetBy: 1))
        }
        
        //remove occasional codes in strings that aren't parsed by RSSParser
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
