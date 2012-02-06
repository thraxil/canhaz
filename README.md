# CANHAZ is a simple scraping tool #

Give it a URL and an XPath expression and it will fetch the URL, parse
it, and return a JSON structure of the results of the XPath
selection. 

## Parameters ##

* url: the URL to fetch
* xpath: the xpath expression

## Example ##

    curl 'http://localhost:8080/?url=http://example.com/&xpath=//img/@src'

## Results ##

A successful request will return something like:

    {"results" : {"text": "foo.jpg"}}

A bad xpath expression will return:

    {"error" : "bad xpath"}

And HTTP errors will get passed along as well. 
