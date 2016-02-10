# FeedMe README 
by Matt "hey that rhymes" Barker

## In case of issues...
While extending the functionality of this project beyond CU4999, strange bugs and console errors and crashes occur, with more popping up after I fix them. Concisely, shit happens. If while running / building in the simulator, the app crashes, please try rebuilding and running again. Inexplicably, after doing this once (sometimes twice), the app should remain stable. 

## Features
- open articles (if available) in Reader view
	- advanced browser functionality (iOS 9 SVC) with seamless sharing capabilities
	- swipe back from edge of screen
- add feeds via URL (three default websites provided)
	- rejects duplicates, non-URLS, and URLs that aren't valid feeds
- rename feeds (a necessity for ugly feed names!)
- open main website page of feeds
- delete feeds
- articles marked as read via faded cell (see Known Issues)
- automatically refreshes whenever significant changes are made
	- pull to refresh included

## Little Touches
- ImageView is hidden if parser doesn't find a usable picture
- 6 different feed status messages
- landscape mode
- hitting return on the keyboard will save / add feed
- concise custom date / time template parsed from NSDate
- labels truncate / shorten if too long in the article info under preview
- custom stringParser to clean up parsed text (html, urls, tags, char. codes)
- LaunchScreen included

## Known Issues
- refreshing will make all articles unread
- layout complaints because of UIAlertController / autolayout
- depreciated function in Swift RSS Parser

## Roadmap (if pursued)
- fixing known issues
- color-coding feeds
- swipe to mark as read/unread & mark all as read
- save user's feeds to NSUserDefaults
- hide feeds / view select feeds
- settings / about page
- load more articles / limit number of articles loaded
- anticipating / handling more feed types

## Credits
######Code/Design: Matt Barker

###### SwiftRSS Parser: pristap forked from AlexChesters (w/ some small personal mods)

###### Icon: Matt Barker

###### Outside Help: 
- Lucas Derraugh (layouts, delegates)
- Austin Astorga (background threads)
- StackOverflow (so many things, so many)
