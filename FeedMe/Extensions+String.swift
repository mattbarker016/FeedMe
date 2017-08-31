//
//  String+ImageLinksFromHTML.swift
//  SwiftRSS_Example
//
//  Created by Thibaut LE LEVIER on 22/10/2014.
//  Copyright (c) 2014 Thibaut LE LEVIER. All rights reserved.
//

import UIKit

extension String {
    
    var imageLinksFromHTMLString: [URL]
    {
        var matches = [URL]()
        
        let full_range: NSRange = NSMakeRange(0, self.characters.count)
        
        do {
            let regex = try NSRegularExpression(pattern:"(https?)\\S*(png|jpg|jpeg)", options:.caseInsensitive)
            regex.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: full_range) {
                (result : NSTextCheckingResult?, _, _) in
                
                // didn't find a way to bridge an NSRange to Range<String.Index>
                // bridging String to NSString instead
                let str = (self as NSString).substring(with: result!.range) as String
                
                matches.append(URL(string: str)!)
            }
        } catch _ as NSError {
            
        }
        
        return matches
    }
    
    func htmlParse() -> String {
        
        var string = self
        
        // Remove anything in-between < and >
        while string.contains("<") && string.contains(">") {
            let range = string.range(of: "<")!.lowerBound..<string.range(of: ">")!.upperBound
            string.removeSubrange(range)
        }
        
        // Remove potential space at start of preview
        if string[string.startIndex] == " " {
            string = string.substring(from: string.characters.index(string.startIndex, offsetBy: 1))
        }
        
        // Remove common HTML entities
        string = string.replacingOccurrences(of: "&apos;", with: "'")
        string = string.replacingOccurrences(of: "&quot;", with: "\"")
        string = string.replacingOccurrences(of: "&amp;", with: "&")
        string = string.replacingOccurrences(of: "&ldquo;", with: "\"")
        string = string.replacingOccurrences(of: "&rdquo;", with: "\"")
        string = string.replacingOccurrences(of: "&lsquo;", with: "\'")
        string = string.replacingOccurrences(of: "&rsquo;", with: "\'")
        string = string.replacingOccurrences(of: "&ndash;", with: "-")
        string = string.replacingOccurrences(of: "&mdash;", with: "–")
        string = string.replacingOccurrences(of: "&lt;", with: "<")
        string = string.replacingOccurrences(of: "&gt;", with: ">")
        string = string.replacingOccurrences(of: "&copy;", with: "©")
        string = string.replacingOccurrences(of: "&reg;", with: "®")
        
        return string
        
    }
        
}
