package be.boulevart.google.events {
	import flash.events.ErrorEvent;			/**
	 * @author joris
	 */
	public class GoogleAPIErrorEvent extends ErrorEvent {
		public static const API_ERROR:String="api_error" 
		
		private var _errorID:int
		public function GoogleAPIErrorEvent(error_type:String,message:String = "", id:int = 0) {
			super(error_type,false,false,message)
			this._errorID=id;
		}

		public function get responseDetails() : String {
			return this.text;
		}

		public function get responseStatus() : int {
			return this._errorID;
		}

		public override function toString() : String {
			return 	"Google API Error:: " + text + " (responseStatus: " + responseStatus + ")\n" + 
					"Please check your search query.\n" +
					"Error-details:";
		}
	}
}

