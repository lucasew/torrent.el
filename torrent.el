(require 'url)
(require 's)

(defun torrent-fetchurl (url)
  "Utility function used for HTTP requests"
  (progn
    (message "Request '%s'" url)
    (url-retrieve-synchronously url t t 0.5)))

(defun torrent-search-google-firstpage-links (query)
  "Search query on Google and return a list of links of the first page"
  (ignore-errors (let* (
	(search (torrent-fetchurl (concat "http://www.google.com/search?q=" (url-hexify-string query))))
	(search-content (with-current-buffer search (buffer-string)))
	(regexp "/url\\?q=.[^\"]*")
	(links-unnormalized (s-match-strings-all regexp search-content))
	(links (mapcar (lambda (link) (url-parse-query-string (car link) "q")) links-unnormalized))
    ) links)))

(defun torrent-search-duckduckgo-firstpage-links (query)
  "Search query on DuckDuckGo and return a list of links of the first page"
  (ignore-errors (let* (
	(search (torrent-fetchurl (concat "https://duckduckgo.com/html?q=" (url-hexify-string query))))
	(search-content (with-current-buffer search (buffer-string)))
	(regexp "href=\"\\([^\"]*\\)")
	(links-unnormalized (s-match-strings-all regexp search-content))
	(links (--filter it (mapcar (lambda (link) (url-parse-query-string (cadr link) "uddg")) links-unnormalized)))
    ) links)))

(defun torrent-crawl-links (links)
  "Crawl torrent links in a new buffer from a list of site links"
    (let* (
	    (buf (get-buffer-create (concat "*torrent* " query)))
	) (with-current-buffer buf (progn
	    (erase-buffer)
	    (switch-to-buffer buf)
	    (insert "RESULTS FOUND\n")
	    (mapcar (lambda (link)
		      (when link
			(message "Searching for magnets in '%s'\n" link)
			(let (
				(torrents (ignore-errors (torrent-find-magnets-in-page link)))
				) (when torrents (progn
				    (insert (concat "\n\nSource: " link "\n"))
				    (mapcar #'torrent-handle-found torrents)
			    ))))) links)
	    (message "Done. If there is no results kill this buffer and rerun with another query or if your internet is bad just redo the same query")))))

(defun torrent-search-google (query)
  "Search Google for a query and output the torrent links in a new buffer"
  (interactive "sQuery to search for: ")
  (torrent-crawl-links (torrent-search-google-firstpage-links query)))

(defun torrent-search-duckduckgo (query)
  "Search DuckDuckGo for a query and output the torrent links in a new buffer"
  (interactive "sQuery to search for: ")
  (torrent-crawl-links (torrent-search-duckduckgo-firstpage-links query)))
  
(defun torrent-handle-found (magnet)
    (when magnet (insert (concat "\n\n\t"
	(s-replace-regexp "+" " " (or (url-parse-query-string magnet "dn") "* no name *"))
	"\n"
	magnet))))

(defun torrent-find-magnets-in-page (url)
  (let* (
	 (page (torrent-fetchurl url))
	 (page-content (with-current-buffer page (buffer-string)))
	 (regexp "\\(magnet:\\?[^\"' ]*\\)")
	 (links-unnormalized (s-match-strings-all regexp page-content))
  ) (mapcar #'car links-unnormalized)))

(defun url-parse-query-string (url key)
  (let (
	(parsed (url-unhex-string (cadar (s-match-strings-all (concat key "=\\([^&]*\\)") url)))))
    (if (= (length parsed) 0) nil parsed)))

