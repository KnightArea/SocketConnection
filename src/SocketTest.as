package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import socketService.SocketCaller;
	import socketService.types.Register_Params;
	
	public class SocketTest extends Sprite
	{
		
		private var socketListener:Socket ;
		
		private var socketTime:uint,
					httpTime:uint;

		private var sock:SocketCaller;
		
		private var sampleData:Array ;
		
		private var urlLoader:URLLoader ;
		
		/**The mockIndex starts from the maximom*/
		private var mockIndex:int ;
		private var tim:int;
		
		public function SocketTest()
		{
			super();
			
			sock = new SocketCaller();
			sock.addEventListener(Event.COMPLETE,next);
			
			urlLoader = new URLLoader(new URLRequest("MOCK_DATA.json"));
			urlLoader.addEventListener(Event.COMPLETE,dataLoaded);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,sendRequestToSocketServer);
		}
		
		protected function dataLoaded(event:Event):void
		{
			sampleData = JSON.parse(urlLoader.data as String) as Array;
			mockIndex = (sampleData as Array).length-1 ;
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
			sock.loadParam(registerRequest);
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
				throw "You saved "+sampleData.length+" datas to the database in "+(getTimer()-tim)+" miliseconds";
			}
		}
		
	}
}