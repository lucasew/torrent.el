# torrent.el
Find torrents using Google or DuckDuckGo without leaving emacs. ([Video](https://github.com/lucasew/torrent.el/releases/download/0.1/screencast.mp4))

## What is this?
- It's an emacs plugin, so its a extension for the emacs editor.
- A shortcut to search for magnet files (torrent links) from 
the sites on the first page of Google or DuckDuckGo.
- It doesn't download torrents or host illegal things, just
exploits the fact that all useful torrent sites embed the magnet 
link on the static HTML, the crap comes with the embedded JavaScript
in the page. The crap is just ignored and you get just the raw gold.

## What is still missing?
- [ ] Fetch pages asynchronously: it freezes the editor while the
plugin is working
- [ ] Cancellable queries
- [ ] Second page and beyond for search results
- [ ] Add to some plugin repo like ELPA/MELPA for easier installation
- [ ] More search engines?

## How to use it?

After installed and loaded it will setup a few functions and commands
being these the main ones that can be accessed using the M-x shortcut.

- `torrent-search-google`
  - Search Google for the given query as you would do on browser
  - Fetch the result links
  - Fetch each link outputting on a new buffer all the magnet links 
  found, if no magnet link found just ignore it
  
- `torrent-search-duckduckgo`
  - Search DuckDuckGo for the given query as you would do on browser
  - Fetch the result links
  - Fetch each link outputting on a new buffer all the magnet links 
  found, if no magnet link found just ignore it
  
## NOTE
- This thing doesn't do magic. If you don't know what to type on a 
search engine to find exactly what you are looking for this thing 
will not save you. It just do the search for you and find magnet
links on the sites found in the first page.

## Disclaimer
- Use at your own risk. If the FBI raids your house after 
torrenting Ubuntu or The Big Buck Bunny it will be definitely 
your problem.
