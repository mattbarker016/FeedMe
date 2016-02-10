# FeedMe README 
by Matt Barker

## Features
- open articles with iOS 9's Safari View Controller, in Reader mode if available
- advanced browser functionality
	- seamless sharing capabilities
- add feeds via URL (three default websites provided)
	- rejects duplicates, non-URLS, and URLs that aren't valid feeds
- rename feeds (a necessity for ugly feed names!)
- open main website page of feeds
- delete feeds
- articles marked as read via faded cell*
- automatically refreshes whenever significant changes are made
	- pull to refresh included

## Little Touches
- ImageView is hidden if parser doesn't find a usable picture
- 6 different feed status messages
- landscape mode works with no issues
- hitting return on the keyboard will save / add feed
- concise custom date / time template parsed from NSDate
- labels truncate / shorten if too long in the article info under preview
- custom stringParser to clean up parsed text (html, urls, tags, char. codes)

## Known Issues
- refreshing will make all articles unread
- layout complaints because of UIAlertController
- depreciated function in Swift RSS Parser

## Roadmap (if pursued)
- fixing known issues
- color-coding feeds
- swipe to mark as read/unread
		- figure out how to change option based on if read or not
- save user's feeds to NSUserDefaults
- hide feeds / view select feeds
- settings / about page
- load more articles / limit number of articles loaded
- anticipating / handling more feed types

## Credits
### Code/Design: Matt Barker
### SwiftRSS Parser: pristap forked from AlexChesters (w/ some small personal mods)
### Icon: Matt Barker
### Outside Help: 
- Lucas Derraugh (layouts, delegates)
- Austin Astorga (background threads)
- StackOverflow (so many things, so many)
