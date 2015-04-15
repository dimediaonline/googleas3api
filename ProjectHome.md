# Google Web APIs - Actionscript 3 library (v2.1) #

**When you find bugs or errors, please fill in an issue (under 'Issues'-tab)**

## About ##
The library is a simple collection of Google's API features, there is a class per feature, like Google Web search, Images Search, Google Suggest etc. Each library throws it’s own event with an Array or Value Object of matching datatype(s), for example GoogleWebItem,  so it’s easy to keep track on wich data is recieved and what this data contains, giving the developer transparency using Intellisense.

## Contains ##
This api contains:
  * Google Ajax API:
    * Google Search
      * Google Web Search
      * Google Images Search
      * Google Book Search
      * Google Video Search (Google Video & YouTube)
      * Google Blog Search
      * Google Local Search
      * Google Patent Search
      * Google News Search
    * Google Translation
    * Google Feeds

  * Google Weather
  * Google Suggest

## Compatibility ##
This API is Flash & Flex compatible using Actionscript 3 (FP9 & 10).

## Documentation ##
You can find the documentation under downloads > documentation. It's also archived in the downloadable source-zip (under the docs directory) and can also be found under the docs folder in the trunk of the SVN.

### Little example code ###
```
var googleWebSearch:GoogleWebSearch=new GoogleWebSearch();
googleWebSearch.search(txtInput.text,0,"nl");
googleWebSearch.addEventListener(GoogleApiEvent.WEB_SEARCH_RESULT,onWebResults) ;

//If you want to catch the API errors yourself:
googleWebSearch.addEventListener(GoogleAPIErrorEvent.API_ERROR,onAPIError)

private function onWebResults(e:GoogleApiEvent):void{
	var resultObject:GoogleSearchResult=e.data as GoogleSearchResult
	trace("Estimated Number of Results: "+resultObject.estimatedNumResults)
	trace("Current page index: "+resultObject.currentPageIndex)
	trace("Number of pages: "+resultObject.numPages)

	for each (var result:GoogleWebItem in resultObject.results){
		trace(result.title, result.url)
	}
}

private function onAPIError(evt:GoogleAPIErrorEvent):void{
	trace("An API error has occured: " + evt.responseDetails, "responseStatus was: " + evt.responseStatus);
}
```

## Dependencies ##
This library uses certain classes (for example JSON-decoding), found in the AS3CoreLib by Mike Chambers, Daniel Dura and Christian Cantrell.
These classes can be checked out or downloaded here: http://code.google.com/p/as3corelib

## Versions ##
If possible, checkout the latest source via SVN.
SVN Clients I would recommend:
  * Windows:http://tortoisesvn.tigris.org/
  * Mac: http://versionsapp.com/

## Latest changelog ##
### Changelog 2.0.2 to 2.1 ###
  * API core: GoogleAPIServiceURL; All API URLs are now collected in this new class, this for maintenance purposes.
  * API core: GoogleApiKeyStore; removed a private function & added new keyIsSet getter

  * Search APIs: GoogleImageSearch: added 2 parameters to search() function; imageColor and restrictToDomain; imageColor is added between colorization and imageType; so beware, **FUNCTION SIGNATURE HAS CHANGED**
  * Search APIs: GoogleWebSearch: added 6 new parameters to search()-function; safeMode, LanguageRestrict, duplicateFilter, countryCode, customSearchEngineID, customSearchEngineRef
  * Search APIs: GoogleLocalSearch: changed parameter centerPointOfSearch in search()-function from type String to type Point

  * Global: removed string concatenations when building URLs, replaced them with URLVariables
  * Global: minor bugfixes