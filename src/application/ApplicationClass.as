package application
{
	import com.collectivecolors.errors.XMLParseError;
	import com.collectivecolors.utils.XMLParser;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.ComboBox;
	import mx.controls.List;
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
		public var txtiTag:TextInput;
		public var lstXmlTags:List;
		public var cmboParseOptions:ComboBox;
		public var btnParse:Button;

		/**
		 * Variables
		 **/
		 
		 //Contains the information and data of the XML file once the user selects it
		 private var fileRef:FileReference;
		 
		 //Array containing the XML parser options for the combo box
		 private var xmlParserOptions:Array = ["Single Tag Required", "Single Tag Optional",
		 	"Multi Tag Required", "Multi Tag Optional" ];
		 	
		 //XML Tag List Data Provider
		 private var xmlParseReturn:Array = [];

		/**
		 * Constructor And Creation Complete Handler
		 **/


		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}


		public function creationCompleteHandler(value:Event):void
		{
			//Set cmboParserOption data provider
			cmboParseOptions.dataProvider = xmlParserOptions;
			
			//Create new instance of the file reference class
			fileRef = new FileReference();
			
			//Add event listeners to buttons
			btnBrowse.addEventListener(MouseEvent.CLICK, btnBrowseHandler);
			btnParse.addEventListener(MouseEvent.CLICK, btnParseHandler);
			
			//Add event listeners to fileRef
			fileRef.addEventListener(Event.SELECT, fileSelectedHandler);
			fileRef.addEventListener(Event.COMPLETE, fileLoadedHandler);
		}


		/**
		 * Event Handlers
		 **/

		//Allow the user to select the xml file to read from his system
		public function btnBrowseHandler(value:Event):void{
			fileRef.browse(new Array(new FileFilter("XML Files", "*.xml")));
		}
		
		//Parse the XML if the user has actually entered a tag to search for
		public function btnParseHandler(value:Event):void{
			if(txtiTag.text != ""){
				parse();
			}
		}
		
		//Once the user selects a file, go ahead and load the data from that file
		public function fileSelectedHandler(value:Event):void{
			//Update the text input with the file's name and size
			txtiFile.text = value.target.name + " - ( " + value.target.size + " bytes )";
			//Load the data from the file
			fileRef.load();
			
		}
		
		//Once the file's data is loaded, enable the parse XML button
		public function fileLoadedHandler(value:Event):void{
			btnParse.enabled = true;
		}

		/**
		 * Methods
		 **/
		 
		 //Parse the selected XML file for the selected tag in the selected mode
		 public function parse():void{
		 	
		 	//XML data from the selected file
		 	var data:XML = XML(fileRef.data);
		 	
			//Clear the data provider of the list
			xmlParseReturn=[];
			
			//Remove Any Blank Spaces
			txtiTag.text = txtiTag.text.replace(new RegExp( ' ', 'g' ), "");
			
			//Create two strings, one for the requested tag, and one for the hierarchy
			var tag:String = txtiTag.text.substring(txtiTag.text.lastIndexOf("/")+1, txtiTag.text.length);
			var heirarchy:String =  txtiTag.text.substring(0, txtiTag.text.lastIndexOf("/")+1);
			
			//Determine how deep the rabbit hole goes
			var length:int = heirarchy.match(new RegExp( '\/', 'g' )).length;
			
			try{
			//Based on the information above, dig through the XML until we get to the desired point
			for(var i:int=0 ; i<length ; i++){
				data = XML(data[heirarchy.substring(0, heirarchy.indexOf("/"))]);
				heirarchy = heirarchy.substring(heirarchy.indexOf("/")+1 , heirarchy.length);
			}
			}
			//If the user inputs an incorrect XML hiearchy, alert them and return out of the function
			catch(error:TypeError){
				Alert.show("The XML Hierarchy Is Invalid", "Invalid XML Hierarchy");
				return;
			}
			
			try
			{
				switch (cmboParseOptions.selectedItem)
				{

					//Single Tag Required
					case "Single Tag Required":
					{
						xmlParseReturn.push(XMLParser.parseSingleTagRequired(data, tag, "Not Found", "Invalid"));
						break;
					}

					//Single Tag Optional
					case "Single Tag Optional":
					{
						xmlParseReturn.push(XMLParser.parseSingleTagOptional(data, tag, "Invalid"));
						break;
					}

					//Multi Tag Required
					case "Multi Tag Required":
					{
						xmlParseReturn=XMLParser.parseMultiTagRequired(data, tag, "Not Found", "Invalid");
						break;
					}

					//Multi Tag Optional
					case "Multi Tag Optional":
					{
						xmlParseReturn=XMLParser.parseMultiTagOptional(data, tag, "Invalid");
						break;
					}
					
				}
				
				//Set the data provider of the list again to update its contents
				lstXmlTags.dataProvider=xmlParseReturn;
			}
			catch (error:XMLParseError)
			{
				//If the library throws an XML Not Found error, alert the user
				if (error.message == "Not Found")
				{
					Alert.show("The XML Tag \"" + error.xmlTag + "\" Was Not Found", "Nonexistent XML Tag");
				}
				//If the library throws an XML Invalid error, alert the user
				else if (error.message == "Invalid")
				{
					Alert.show("The XML Tag \"" + error.xmlTag + "\" Is Invalid", "Invalid XML Tag");
				}
			}
		 }
	}
}