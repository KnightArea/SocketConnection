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
	
	public class SocketTest extends Sprite
	{
		
		private var socketListener:Socket ;
		
		private var socketTime:uint,
					httpTime:uint;
		
		public function SocketTest()
		{
			super();
			
			
			socketListener = new Socket();
			socketListener.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,socketProggress);
			socketListener.addEventListener(Event.CONNECT,socketConnected);
			trace("try to connect to server...");
			socketListener.connect("185.55.226.102",31001);
		}
		
		protected function socketProggress(event:OutputProgressEvent):void
		{
			trace("...Socket progress...");
		}
		
		/**Server connected*/
		protected function socketConnected(event:Event):void
		{
			trace("Server connected, Packet sending...");
			stage.addEventListener(MouseEvent.MOUSE_DOWN,sendSocket);
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,loadAfile);
			//socketListener.flush();
		}
		
		protected function loadAfile(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			event.preventDefault();
			trace("Try to load a file in http");
			httpTime = getTimer();
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE,fileLoaded);
			loader.load(new URLRequest("https://www.google.com/"));
		}
		
			protected function fileLoaded(event:Event):void
			{
				// TODO Auto-generated method stub
				var loadedString:String = (event.target as URLLoader).data;
				trace("HTTP data loaded : "+(loadedString.substr(0,Math.min(loadedString.length,10))));
				trace("And it takes : "+(getTimer()-httpTime));
			}
		
		protected function sendSocket(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			socketTime = getTimer();
			var rr:RequestType = new RequestType();
			rr.functions = "salam";
			var tmpStr:String = JSON.stringify(rr);
			trace('Send this : '+tmpStr)
			//socketListener.writeUTF("salam");
			socketListener.addEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
			socketListener.writeUTFBytes(tmpStr);
			socketListener.flush();
		}
		
			/**Some data received*/
			protected function socketDataRecevied(event:ProgressEvent):void
			{
				socketListener.removeEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
				var retVal:String = socketListener.readUTFBytes(event.bytesLoaded);
				//This functin will not call...
				trace("Server data received : "+retVal);
				
				var response:Object = JSON.parse(retVal) ;
				trace(response.functions);
				trace("... and it takes : "+(getTimer()-socketTime));
			}
	}
}