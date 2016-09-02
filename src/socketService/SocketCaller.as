package socketService
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;

	public class SocketCaller
	{
		private var funcName:String ;
		
		private var socketListener:Socket ;
		
		private var sendThisJSON:String ;
		
		public function SocketCaller(theFunctionName:String="Register")
		{
			funcName = theFunctionName ;
			
			socketListener = new Socket();
			//socketListener.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS,socketProggress);
			socketListener.addEventListener(Event.CONNECT,socketConnected);
		}
		
		public function loadParam(sendData:Object):void
		{
			var request:SocketRequestFormat = new SocketRequestFormat(funcName,sendData);
			sendThisJSON = JSON.stringify(request);
			trace("try to connect to server for "+funcName);
			socketListener.connect(SocketInit.ip,SocketInit.port);
		}
		
			/**Socket connection is connected*/
			private function socketConnected(e:Event):void
			{
				trace("Now send this : "+sendThisJSON);
				socketListener.addEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
				socketListener.writeUTFBytes(sendThisJSON);
				socketListener.flush();
			}
			
				private function socketDataRecevied(e:ProgressEvent):void
				{
					trace("Socket data is : "+e.bytesTotal);
				}
	}
}