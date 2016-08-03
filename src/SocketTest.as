package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	
	public class SocketTest extends Sprite
	{
		
		private var socketListener:Socket ;
		
		public function SocketTest()
		{
			super();
			
			
			socketListener = new Socket();
			socketListener.addEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
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
			socketListener.writeUTF("public struct ResponseType{public string function { get; set; }}");
			//socketListener.flush();
		}
		
		/**Some data received*/
		protected function socketDataRecevied(event:ProgressEvent):void
		{
			//This functin will not call...
			trace("Server data is : "+socketListener.readUTF());
		}
	}
}