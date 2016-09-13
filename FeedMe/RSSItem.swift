//
//  RSSItem.swift
//  SwiftRSS_Example
//
//  Created by Thibaut LE LEVIER on 28/09/2014.
//  Modified by Matt Barker
//  Copyright (c) 2014 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

class RSSItem: NSObject, NSCoding {
    
    var picture: UIImage? = nil
    var feedName: String? = "Feed Name"
    
    var title: String?
    var link: URL?
    
    func setLink1(_ linkString: String!)
    {
        link = URL(string: linkString)
    }
    
    var guid: String?
    var pubDate: Date?
    
    func setPubDate1(_ dateString: String!)
    {
        pubDate = Date.dateFromInternetDateTimeString(dateString)
    }
    
    var itemDescription: String?
    var content: String?
    
    // Wordpress specifics
    var commentsLink: URL?
    
    func setCommentsLink1(_ linkString: String!)
    {
        commentsLink = URL(string: linkString)
    }
    
    var commentsCount: Int?
    
    var commentRSSLink: URL?
    
    func setCommentRSSLink1(_ linkString: String!)
    {
        commentRSSLink = URL(string: linkString)
    }
    
    var author: String?
    
    var categories: [String]! = [String]()
    
    var imagesFromItemDescription: [URL]! {
        if let itemDescription = self.itemDescription
        {
            return itemDescription.imageLinksFromHTMLString as [URL]!
        }
        
        return [URL]()
    }
    
    var imagesFromContent: [URL]! {
        if let content = self.content
        {
            return content.imageLinksFromHTMLString as [URL]!
        }
        
        return [URL]()
    }
    
    override init()
    {
        super.init()
    }
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder)
    {
        super.init()
        
        picture = aDecoder.decodeObject(forKey: "picture") as? UIImage //raw pic of first link if it exists
        feedName = aDecoder.decodeObject(forKey: "feedName") as? String //hopefully, feed name
        title = aDecoder.decodeObject(forKey: "title") as? String //headline
        link = aDecoder.decodeObject(forKey: "link") as? URL  //link of post itself, macstories is funny like this
        guid = aDecoder.decodeObject(forKey: "guid") as? String //url of post as a string
        pubDate = aDecoder.decodeObject(forKey: "pubDate") as? Date //time it was posted
        itemDescription = aDecoder.decodeObject(forKey: "description") as? String //parsed content
        content = aDecoder.decodeObject(forKey: "content") as? String //raw html content
        commentsLink = aDecoder.decodeObject(forKey: "commentsLink") as? URL //link to comments
        commentsCount = aDecoder.decodeObject(forKey: "commentsCount") as? Int //number of comments
        commentRSSLink = aDecoder.decodeObject(forKey: "commentRSSLink") as? URL //?
        author = aDecoder.decodeObject(forKey: "author") as? String //author of post
        categories = aDecoder.decodeObject(forKey: "categories") as? [String] //catergories feed represents
    }
    
    func encode(with aCoder: NSCoder)
    {
        if let picture = self.picture
        {
            aCoder.encode(picture, forKey: "picture")
        }
        if let feedName = self.feedName
        {
            aCoder.encode(feedName, forKey: "feedName")
        }
        
        if let title = self.title
        {
            aCoder.encode(title, forKey: "title")
        }
        
        if let link = self.link
        {
            aCoder.encode(link, forKey: "link")
        }
        
        if let guid = self.guid
        {
            aCoder.encode(guid, forKey: "guid")
        }
        
        if let pubDate = self.pubDate
        {
            aCoder.encode(pubDate, forKey: "pubDate")
        }
        
        if let itemDescription = self.itemDescription
        {
            aCoder.encode(itemDescription, forKey: "description")
        }
        
        if let content = self.content
        {
            aCoder.encode(content, forKey: "content")
        }
        
        if let commentsLink = self.commentsLink
        {
            aCoder.encode(commentsLink, forKey: "commentsLink")
        }
        
        if let commentsCount = self.commentsCount
        {
            aCoder.encode(commentsCount, forKey: "commentsCount")
        }
        
        if let commentRSSLink = self.commentRSSLink
        {
            aCoder.encode(commentRSSLink, forKey: "commentRSSLink")
        }
        
        if let author = self.author
        {
            aCoder.encode(author, forKey: "author")
        }
        
        aCoder.encode(categories, forKey: "categories")
    }
}
