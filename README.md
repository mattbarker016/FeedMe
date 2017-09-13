# FeedMe (Demo)

A Simple Swift RSS Feed Reader

Big Red Hacks iOS Workshop App Example

## Features
- open articles in optimized Reader view, if available
	- advanced browser functionality with seamless sharing capabilities
	- swipe back from edge of screen
- add feeds via URL (three default websites provided)
	- rejects duplicates, non-URLS, and URLs that aren't valid feeds
- open main website page of feeds
- delete feeds
- articles marked as read via faded cell (see Known Issues)
- automatically refreshes whenever significant changes are made
	- pull to refresh included

## Little Touches
- ImageView is hidden if parser doesn't find a usable picture
- landscape mode
- hitting return on the keyboard will save / add feed
- concise custom date / time template parsed from Date
- labels truncate / shorten if too long in the article info under preview
- custom stringParser to clean up parsed text (html, urls, tags, char. codes)
- LaunchScreen included

## Known Issues
- unwanted graphics during refreshing
- delete feed is buggy
- refreshing will make all articles unread
- layout complaints because of UIAlertController
- depreciated function in Swift RSS Parser

## Beyond

Please feel free to continue working with this example and submiting pull requests to add to this project!

## Credits

Code / Design: Matt Barker

SwiftRSS Parser: @pristap forked from @AlexChesters (w/ some small personal mods)

Icon: Matt Barker

Outside Help: 
- Lucas Derraugh (layouts, delegates)
- Austin Astorga (background threads)
- StackOverflow (so many things, so many)


