package be.boulevart.google.api.search {

		private var _results:Array = [];
		private var _estimatedNumResults:int = 0;
		private var _currentPageIndex:int = 0;
		private var _numPages:int = 1;

		/**
		 * Array of result objects, see the classes where you queried for more information
		 */
			return _results;
		}

			_results = results;
		}

		/**
		 * Number of estimated results
		 */
			return _estimatedNumResults;
		}

			_estimatedNumResults = nor;
		}

		/**
		 * Current page index of result
		 */
			return _currentPageIndex;
		}

			_currentPageIndex = index;
		}

		/**
		 * Number of pages available
		 * @default 1
		 */
			return _numPages;
		}

			_numPages = np;
		}
	}
}