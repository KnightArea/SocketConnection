package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
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
		
		private var sampleData:Object ;
		
		private var urlLoader:URLLoader ;
		
		public function SocketTest()
		{
			super();
			
			sock = new SocketCaller();
			
			urlLoader = new URLLoader(new URLRequest("MOCK_DATA.json"));
			urlLoader.addEventListener(Event.COMPLETE,dataLoaded);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,sendRequestToSocketServer);
		}
		
		protected function dataLoaded(event:Event):void
		{
			sampleData = JSON.parse(urlLoader.data as String);
			trace("Sample datas are loaded : "+(sampleData as Array).length);
		}
		
		protected function sendRequestToSocketServer(event:MouseEvent):void
		{
			trace("Send the user requset");
			
			var registerRequest:Register_Params = new Register_Params();
			sock.loadParam(registerRequest);
		}
		
		
	}
}