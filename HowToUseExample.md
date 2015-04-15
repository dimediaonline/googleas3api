#Example on how to use this library

## Little example code ##
```
var googleWebSearch:GoogleWebSearch=new GoogleWebSearch();
googleWebSearch.search(txtInput.text,0,lang);
googleWebSearch.addEventListener(GoogleApiEvent.WEB_SEARCH_RESULT,onWebResults) ;

//If you want to catch the API errors yourself:
googleWebSearch.addEventListener(GoogleAPIErrorEvent.API_ERROR,onAPIError)

private function onWebResults(e: GoogleApiEvent):void{
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