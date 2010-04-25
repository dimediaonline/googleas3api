/** * GOOGLE API - AS3 LIBRARY * * @author Joris Timmerman * @version 3.0 * * GoogleLocalSearch - Search Google and produce search results relative to a geographic region * Build by Joris Timmerman, these classes uses the Google Ajax API * * These classes are using methods and classes from the Adobe Core Libary, downloadable @ http://code.google.com/p/as3corelib/ * * SPECIAL THANKS TO GOOGLE FOR PROVIDING THE AJAX API * THIS IS AN OPEN SOURCE PROJECT DELIVERED BY BOULEVART NV (www.boulevart.be) */package be.boulevart.google.api.search.local {	import be.boulevart.google.api.core.GoogleAPIKeyStore;	import be.boulevart.google.api.core.GoogleAPIServiceURL;	import be.boulevart.google.api.core.GoogleAPISettings;	import be.boulevart.google.api.search.GoogleSearchResult;	import be.boulevart.google.api.search.GoogleSearchResultPage;	import be.boulevart.google.api.search.local.data.GoogleLocalSearchItem;	import be.boulevart.google.events.GoogleAPIErrorEvent;	import be.boulevart.google.events.GoogleAPIEvent;	import be.boulevart.google.utils.APIUtil;	import com.adobe.serialization.json.JSON;	import com.adobe.utils.StringUtil;	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.IOErrorEvent;	import flash.geom.Point;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLVariables;	import flash.utils.escapeMultiByte;
	/**	 * @author joris	 */	public class GoogleLocalSearch extends EventDispatcher {		/**		 * Start search operation, when operation is done, will dispatch an GoogleSearchEvent.LOCAL_SEARCH_RESULT event with an array of GoogleLocalSearchItem-objects.		 * Will deliver 8 results max, you can get more using the startValue param. (paging)		 * @param searchString search string, what do you wanna find?		 * @param startValue sets a start value for paging (fe. 9; delivers search results from result 9 up to 16)		 * @param centerPointOfSearch This optional argument supplies the search center point for a local search. Its value represents a latitude/longitude pair, e.g., new Point(48.8565,2.3509).		 * @param typeOfListing This optional argument specifies which type of listing the user is interested in, you can find the values in GoogleLocalSearchListingType (data.type)		 * @param lang set main language using language code		 */		public function search(searchString:String, startValue:int = 0, centerPointOfSearch:Point = null, listingType:String = "", lang:String = ""):void {			var serviceURL:String = GoogleAPIServiceURL.SEARCH_LOCAL_SERVICE;			var loader:URLLoader = new URLLoader();			var request:URLRequest = new URLRequest(serviceURL);			searchString = APIUtil.formatInputString(searchString);			lang = APIUtil.formatInputString(lang);			var vars:URLVariables = new URLVariables();			vars.v = "1.0";			vars.q = searchString;			if (startValue > 0) {				vars.start = startValue;			}			vars.rsz = "large";			if (StringUtil.trim(lang).length > 0) {				vars.hl = lang;			} else if (GoogleAPISettings.useMainLanguageAsDefaultLanguage) {				vars.hl = GoogleAPISettings.MAIN_LANGUAGE;			}			if (centerPointOfSearch) {				vars.sll = centerPointOfSearch.x + "," + centerPointOfSearch.y;			}			if (StringUtil.trim(listingType).length > 0) {				vars.mrt = listingType;			}			if (GoogleAPIKeyStore.keyIsSet) {				vars.key = GoogleAPIKeyStore.API_KEY;			}			request.data = vars;			loader.addEventListener(Event.COMPLETE, onResponse);			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);			loader.load(request);		}		private function onResponse(event:Event):void {			var json:Object = JSON.decode("" + event.target.data);			if (json.responseData != null) {				var results:Array = json.responseData.results as Array;				var resultaten:Array = [];				for each (var data:Object in results) {					var item:GoogleLocalSearchItem = new GoogleLocalSearchItem();					item.accuracy = data.accuracy;					item.addressLines = [];					for each (var addresLine:String in data.addressLines) {						item.addressLines.push(addresLine);					}					item.content = data.content;					item.titleNoFormatting = data.titleNoFormatting;					item.title = data.title;					item.longitude = data.lng;					item.latitude = data.lat;					item.maxAge = data.maxAge;					item.url = data.url;					item.streetAdress = data.streetAddress;					item.city = data.city;					item.region = data.region;					item.country = data.country;					item.phoneNumbers = data.phoneNumbers as Array;					item.drivingDirectionsUrl = data.ddUrl;					item.drivingDirectionsUrlFromHere = data.ddUrlFromHere;					item.drivingDirectionsUrlToHere = data.ddUrlToHere;					item.staticMapURL = data.staticMapUrl;					item.listingType = data.listingType;					item.viewPortMode = data.viewportmode;					resultaten.push(item);				}				var searchItem:GoogleSearchResult = new GoogleSearchResult();				searchItem.moreResultsUrl = json.responseData.cursor.moreResultsUrl;				if (json.responseData.cursor.currentPageIndex != null) {					searchItem.currentPageIndex = json.responseData.cursor.currentPageIndex;				}				if (json.responseData.cursor.pages != null) {					for each (var page:Object in json.responseData.cursor.pages) {						var resultPage:GoogleSearchResultPage = new GoogleSearchResultPage();						resultPage.pageIndex = page.label;						resultPage.nextStartValue = page.start;						searchItem.pages.push(resultPage);					}				}				searchItem.results = resultaten;				if (json.responseData.cursor.estimatedResultCount != null) {					searchItem.estimatedNumResults = json.responseData.cursor.estimatedResultCount;				}				dispatchEvent(new GoogleAPIEvent(GoogleAPIEvent.LOCAL_SEARCH_RESULT, searchItem));			} else {				dispatchEvent(new GoogleAPIErrorEvent(GoogleAPIErrorEvent.API_ERROR, json.responseDetails as String, json.responseStatus as int));			}		}		private function onIOError(event:IOErrorEvent):void {			dispatchEvent(new GoogleAPIEvent(GoogleAPIEvent.ON_ERROR, "IOERROR: " + event.text));		}	}}