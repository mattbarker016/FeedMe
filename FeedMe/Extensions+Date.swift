//
//  NSDateExtension.swift
//  SwiftRSS_Example
//
//  Created by Thibaut LE LEVIER on 01/10/2014.
//  Copyright (c) 2014 Thibaut LE LEVIER. All rights reserved.
//

// This extension handle date from string in the following formats:
// - RFC822 (See http://www.faqs.org/rfcs/rfc822.html )
// - RFC3339 (See http://www.faqs.org/rfcs/rfc3339.html )
// The following code take a lot of inspiration from Michael Waterfall date category in MWFeedParser
// Thanks to him!


import UIKit

extension Date {
    
    static var internetDateFormatter : DateFormatter {
    struct Static {
        static let instance: DateFormatter = {
            let dateFormatter = DateFormatter()
            let locale: Locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.locale = locale
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter
            }()
        }
        return Static.instance
    }
    
    static func dateFromInternetDateTimeString(_ dateString: String!) -> Date?
    {
        var date: Date? = nil
        
        date = Date.dateFromRFC822String(dateString)
        
        if date == nil
        {
            date = Date.dateFromRFC3339String(dateString)
        }
        
        return date
    }
    
    static func dateFromRFC822String(_ dateString: String!) -> Date?
    {
        var date: Date? = nil
        
        let rfc822_string: NSString = dateString.uppercased() as NSString
        
        if rfc822_string.range(of: ",").location != NSNotFound
        {
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
                
                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
            
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm zzz"
                
                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
            
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss"

                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
            
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm"
                
                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
        }
        else
        {
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm:ss zzz"
                
                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
            
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm zzz"
                                
                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
            
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm:ss"
                
                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
            
            if date == nil
            {
                Date.internetDateFormatter.dateFormat = "d MMM yyyy HH:mm"
                
                date = Date.internetDateFormatter.date(from: rfc822_string as String)
            }
        }
        
        if date == nil
        {
            NSLog("unable to parse RFC822 date \(dateString)")
        }
        
        return date
    }
    
    static func dateFromRFC3339String(_ dateString: String!) -> Date?
    {
        var date: Date? = nil
        
        var rfc3339_string: NSString = dateString.uppercased() as NSString
        
        if rfc3339_string.length > 20
        {
            rfc3339_string = rfc3339_string.replacingOccurrences(of: ":", with: "", options: .caseInsensitive, range: NSMakeRange(20, rfc3339_string.length-20)) as NSString
        }
        
        if date == nil
        {
            Date.internetDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
            
            date = Date.internetDateFormatter.date(from: rfc3339_string as String)
        }
        
        if date == nil // this case may need more work
        {
            Date.internetDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"
            
            date = Date.internetDateFormatter.date(from: rfc3339_string as String)
        }
        
        if date == nil
        {
            Date.internetDateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
            
            date = Date.internetDateFormatter.date(from: rfc3339_string as String)
        }
        
        if date == nil
        {
            NSLog("unable to parse RFC3339 date \(dateString)")
        }
        
        return date
    }
   
}
