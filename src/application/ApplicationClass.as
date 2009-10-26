package application
{
	import com.collectivecolors.utils.XMLParser;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.controls.Button;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.events.FlexEvent;
	


	public class ApplicationClass extends Application
	{


		/**
		 * MXML Components
		 **/

		public var btnBrowse:Button;
		public var txtiFile:TextInput;
		public var txtaTest:TextArea;

		/**
		 * Variables
		 **/
		 
		 private var fileRef:FileReference;

		/**
		 * Constructor And Creation Complete Handler
		 **/


		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}


		public function creationCompleteHandler(value:Event):void
		{
			//Create new instance of the file reference class
			fileRef = new FileReference();
			
			//Add event listeners to buttons
			btnBrowse.addEventListener(MouseEvent.CLICK, btnBrowseHandler);
			
			//Add event listeners to fileRef
			fileRef.addEventListener(Event.SELECT, fileRefHandler);
		}


		/**
		 * Event Handlers
		 **/

		public function btnBrowseHandler(value:Event):void{
			fileRef.browse(new Array(new FileFilter("XML Files", "*.xml")));
		}
		
		public function fileRefHandler(value:Event):void{
			txtiFile.text = value.target.name;
		}

		/**
		 * Methods
		 **/
	}
}