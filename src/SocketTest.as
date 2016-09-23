package
{
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import socketService.SocketCaller;
	import socketService.services.Register;
	import socketService.services.UpdateUserInformation;
	import socketService.types.Register_Params;
	import socketService.types.UpdateUserInformation_Params;
	
	public class SocketTest extends Sprite
	{
		
		private var socketListener:Socket ;
		
		private var socketTime:uint,
					httpTime:uint;

		private var sock:Register;
		
		private var sampleData:Array ;
		
		private var urlLoader:URLLoader ;
		
		/**The mockIndex starts from the maximom*/
		private var mockIndex:int ;
		
		private var tim:int;
		
		public function SocketTest()
		{
			super();
			
			sock = new Register();
			sock.addEventListener(Event.COMPLETE,next);
			
			urlLoader = new URLLoader(new URLRequest("MOCK_DATA.json"));
			urlLoader.addEventListener(Event.COMPLETE,dataLoaded);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,sendRequestToSocketServer);
		}
		
		protected function dataLoaded(event:Event):void
		{
			sampleData = JSON.parse(urlLoader.data as String) as Array;
			mockIndex = 0 ;(sampleData as Array).length-1 ;
			trace("Sample datas are loaded : "+(sampleData as Array).length);
		}
		
		protected function sendRequestToSocketServer(event:MouseEvent):void
		{
			trace("Send the user requset");
			tim = getTimer();
			passTheRegParams();
		}
		
		private function passTheRegParams():void
		{
			var registerRequest:Register_Params = new Register_Params();
			registerRequest.Latitude = sampleData[mockIndex].Latitude ;
			registerRequest.Longitude = sampleData[mockIndex].Longitude ;
			sock.load(registerRequest);
		}		
		
		protected function next(event:Event):void
		{
			mockIndex--;
			if(mockIndex>0)
			{
				passTheRegParams();
			}
			else
			{
				trace("You saved "+sampleData.length+" datas to the database in "+(getTimer()-tim)+" miliseconds");
				trace("The registered user id is : "+sock.catchedData.retVal);
				
				var completeReg:UpdateUserInformation = new UpdateUserInformation();
				var userParam:UpdateUserInformation_Params = new UpdateUserInformation_Params();
				userParam.EmailAdress = "ebrahimsepehr@gmail.com";
				userParam.ID = sock.catchedData.retVal;
				userParam.Name = "MohammadEbrahim";
				userParam.PhoneNumber = "09127785180";
				userParam.TeamColor = "#ff0000";
				userParam.TeamTitle = "BestOne";
				completeReg.addEventListener(Event.COMPLETE,registerCompleted);
				completeReg.addEventListener(ErrorEvent.ERROR,ServerErrorRecieved);
				completeReg.addEventListener(Event.UNLOAD,noInternet);
				
				completeReg.load(userParam);
			}
		}
		
		protected function noInternet(event:Event):void
		{
			trace("No internet connection");
		}
		
		protected function ServerErrorRecieved(event:ErrorEvent):void
		{
			trace("Server Error recevived");
		}
		
		protected function registerCompleted(event:Event):void
		{
			trace("Registration is complete");
		}
		
	}
}