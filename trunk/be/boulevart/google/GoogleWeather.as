/**
 * GOOGLE SEARCH AS3 Library
 * /**
 * @author Joris Timmerman
 * @version 1.0
 * 
 * GoogleWeather - Search the current weather conditions for a given city
 * This uses the weather services provided by Google
 * Build by Joris Timmerman, these classes uses the Google Ajax API
 *  * 
 * SPECIAL THANKS TO GOOGLE FOR PROVIDING THE WEATHER API
 * THIS IS AN OPEN SOURCE PROJECT DELIVERED BY BOULEVART NV (www.boulevart.be)
 */
package be.boulevart.google
{
	import be.boulevart.google.data.GoogleWeatherData;
	import be.boulevart.google.data.types.GoogleWeatherCurrentCondition;
	import be.boulevart.google.data.types.GoogleWeatherForecastConditions;
	import be.boulevart.google.data.types.GoogleWeatherForecastInformation;
	import be.boulevart.google.events.GoogleSearchEvent;
	import be.boulevart.google.events.GoogleWeatherEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class GoogleWeather extends EventDispatcher
	{
		/**
		 * Search a given city in a country (optional) and get the data in a certain language.
		 * On result, the data in the event is a GoogleWeather object
		 * @param city City to get the weather for
		 * @param country (Optional) The country where the city is in
		 * @param langCode code for the language to return data in, f.e 'nl'
		 */
		public function search(city:String,country:String="",langCode:String=""):void{
			var url:String="http://www.google.com/ig/api?weather="+city
			
			if(country!=""){
				url+=","+country
			}
			
			if(langCode!=""){
				url+="&hl="+langCode
			}
			
			var loader : URLLoader = new URLLoader()
			var request : URLRequest = new URLRequest(url)
			
			loader.addEventListener(Event .COMPLETE , onWeatherResponse)
			loader.addEventListener(IOErrorEvent.IO_ERROR , onIOError); 
			loader.load(request)
		}
		
		private function onWeatherResponse(e:Event):void{
			var data:XML=XML(e.target.data)

			if(!(data.children()[0].name() == "problem_cause")){
				var fi:GoogleWeatherForecastInformation= loadForecastInfoData(data.weather.forecast_information[0]);
				var cc:GoogleWeatherCurrentCondition = loadCurrentConditionData(data.weather.current_conditions[0]);
				var fcc:Array = loadForecastConditionsData(data.weather.forecast_conditions);
				var googleWeather:GoogleWeatherData = new GoogleWeatherData(fi,cc,fcc);
				dispatchEvent(new GoogleWeatherEvent(GoogleWeatherEvent.WEATHER_RESULT , googleWeather))
			}else{
				dispatchEvent(new GoogleWeatherEvent(GoogleWeatherEvent.API_ERROR , "GoogleWeather API returned an error! Location not found or server error."))
			}	
		}
		
		private function loadForecastInfoData(xml:XML):GoogleWeatherForecastInformation{
			var stad:String = String(xml.city.@data);
			var postcode:String = String(xml.postal_code.@data);					
			var forecastDateData:Array = String(xml.forecast_date.@data).split("-");
			var forecastDate:Date = new Date(forecastDateData[0],forecastDateData[1] - 1,forecastDateData[2]);
			var latitude:String = String(xml.latitude.@data);
			var longitude:String = String(xml.longitude.@data);	
			var now:Date= new Date();
			var eenheid:String = String(xml.unit_system.@data);

			return new GoogleWeatherForecastInformation(stad,postcode,latitude,longitude,forecastDate,now,eenheid);
		}
		
		
		private function loadCurrentConditionData(xml:XML):GoogleWeatherCurrentCondition{
			var beschrijving:String = String(xml.condition.@data);
			var temperureInFahrenheit:int = int(xml.temp_f.@data);
			var temperureInCelcius:int = int(String(xml.temp_c.@data));
			var vocht:uint = uint((xml.humidity.@data).match(/\d+/g));
			var icoon:String = "http://www.google.com/ig"+String(xml.icon.@data);
			var str:String = xml.wind_condition.@data
			var windRichiting:String = String((xml.wind_condition.@data).match(/[A-Z]+ /g)).replace(/ /g,"");
			var windSnelheid:uint = uint((xml.wind_condition.@data).match(/\d+/g));
			
			return new GoogleWeatherCurrentCondition(beschrijving,temperureInFahrenheit,temperureInCelcius,vocht,windRichiting,windSnelheid,icoon);
		}
		
		
		private function loadForecastConditionsData(xml:XMLList):Array{
			var forecasts:Array = new Array();
			
			for each(var xmlCondition:XML in xml ){
				var dag:String = String(xmlCondition.day_of_week.@data);
				var minimum:int = int(xmlCondition.low.@data);
				var maximum:int = int(xmlCondition.high.@data);
				var icoon:String = "http://www.google.com/ig"+String(xmlCondition.icon.@data);
				var omschrijving:String = String(xmlCondition.condition.@data);
				
				forecasts.push(new GoogleWeatherForecastConditions(dag,minimum,maximum,icoon,omschrijving));
			}
			
			return forecasts;
		}
		
		private function onIOError(event : IOErrorEvent) : void {  
			dispatchEvent(new GoogleWeatherEvent(GoogleWeatherEvent.IO_ERROR , "IOERROR: " + event.text))
		} 
		
	}
}