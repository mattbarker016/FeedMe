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
    
    @IBOutlet weak var leadingSpace: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setArticle(_ article: RSSItem) {
        
        headline.text = article.title!.htmlParse()
        preview.text = article.itemDescription!.htmlParse()
                
        // Load article image; if it exists, display it (stored in RSSFeed class)
//        if article.picture == nil {
//            picView.image = article.picture
//        }

        // If image exists, set picture; otherwise, hide imageView
        if let picture = article.picture {
            leadingSpace.constant = 8
            width.constant = 116
            picView.contentMode = .scaleAspectFit
            picView.image = picture
        } else {
            leadingSpace.constant = 0
            width.constant = 0
        }
        
    }
    
}
