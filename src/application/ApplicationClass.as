package application
{
	import flash.events.Event;
	
	import mx.core.Application;
	import mx.events.FlexEvent;
	


	public class ApplicationClass extends Application
	{


		/**
		 * MXML Components
		 **/


		/**
		 * Variables
		 **/
		 

		/**
		 * Constructor And Creation Complete Handler
		 **/


		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}


		public function creationCompleteHandler(value:Event):void
		{
			
		}


		/**
		 * Event Handlers
		 **/


		/**
		 * Methods
		 **/
	}
}