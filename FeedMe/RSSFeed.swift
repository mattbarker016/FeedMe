//
//  RSSFeedMeta.swift
//  SwiftRSS_Example
//
//  Created by Thibaut LE LEVIER on 05/10/2014.
//  Modified by Matt Barker
//  Copyright (c) 2014 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

class RSSFeed: NSObject, NSCoding {
    
    var items: [RSSItem]! = [RSSItem]()
    
    var title: String?
    var customTitle: String?
    var link: URL?
    var rawLink: URL?
    
    func setLink1(_ linkString: String!)
    {
        link = URL(string: linkString)
    }
    
    var feedDescription: String?
    var language: String?
    var lastBuildDate: Date?
    
    func setlastBuildDate(_ dateString: String!)
    {
        lastBuildDate = Date.dateFromInternetDateTimeString(dateString)
    }
    
    var generator: String?
    var copyright: String?
    
    
    override init()
    {
        super.init()
    }
    
    // MARK: NSCoding
    required init?(coder aDecoder: NSCoder)
    {
        super.init()
        
        customTitle = aDecoder.decodeObject(forKey: "customTitle") as? String
        rawLink = aDecoder.decodeObject(forKey: "rawLink") as? URL
        title = aDecoder.decodeObject(forKey: "title") as? String
        link = aDecoder.decodeObject(forKey: "link") as? URL
        feedDescription = aDecoder.decodeObject(forKey: "description") as? String
        language = aDecoder.decodeObject(forKey: "language") as? String
        lastBuildDate = aDecoder.decodeObject(forKey: "lastBuildDate") as? Date
        generator = aDecoder.decodeObject(forKey: "generator") as? String
        copyright = aDecoder.decodeObject(forKey: "copyright") as? String
        
        items = aDecoder.decodeObject(forKey: "items") as! [RSSItem]
    }
    
    func encode(with aCoder: NSCoder)
    {
        if let customTitle = self.customTitle
        {
            aCoder.encode(customTitle, forKey: "customTitle")
        }
        if let rawLink = self.rawLink
        {
            aCoder.encode(rawLink, forKey: "rawLink")
        }
        if let title = self.title
        {
            aCoder.encode(title, forKey: "title")
        }
        
        if let link = self.link
        {
            aCoder.encode(link, forKey: "link")
        }
        
        if let feedDescription = self.feedDescription
        {
            aCoder.encode(feedDescription, forKey: "description")
        }
        
        if let language = self.language
        {
            aCoder.encode(language, forKey: "language")
        }
        
        if let lastBuildDate = self.lastBuildDate
        {
            aCoder.encode(lastBuildDate, forKey: "lastBuildDate")
        }
        
        if let generator = self.generator
        {
            aCoder.encode(generator, forKey: "generator")
        }
        
        
        if let copyright = self.copyright
        {
            aCoder.encode(copyright, forKey: "copyright")
        }
        
        aCoder.encode(self.items, forKey: "items")
    }
    
}
