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
}
