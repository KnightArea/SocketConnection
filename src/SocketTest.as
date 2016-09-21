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
		
		public function SocketTest()
		{
			super();
			
			sock = new SocketCaller();
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN,sendRequestToSocketServer);
		}
		
		protected function sendRequestToSocketServer(event:MouseEvent):void
		{
			trace("Send the user requset");
			
			var registerRequest:Register_Params = new Register_Params();
			sock.loadParam(registerRequest);
		}
		
		
	}
}