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

    
    func setArticle(_ article: RSSItem) {
        
        headline.text = article.title!.htmlParse()
        preview.text = article.itemDescription!.htmlParse()


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
