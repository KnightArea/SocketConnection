package socketService
{
	import com.mteamapp.JSONParser;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
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
			socketListener.addEventListener(ProgressEvent.SOCKET_DATA,socketDataRecevied);
			socketListener.addEventListener(Event.CONNECT,socketConnected);
			socketListener.addEventListener(IOErrorEvent.IO_ERROR,noConnectionAvailable);
		}
		
		/**Connection fails*/
		protected function noConnectionAvailable(event:IOErrorEvent):void
		{
			trace("!! The connection fails");
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
				trace(">>Now send this : "+sendThisJSON);
				socketListener.writeUTFBytes(sendThisJSON);
				socketListener.flush();
			}
			
				private function socketDataRecevied(e:ProgressEvent):void
				{
					trace("<<Socket data is : "+socketListener.bytesAvailable);
					var catchedData:SocketReceivedFormat = new SocketReceivedFormat();
					if(socketListener.bytesAvailable>0)
					{
						var receivedData:String = socketListener.readUTFBytes(socketListener.bytesAvailable) ;
						JSONParser.parse(receivedData,catchedData);
						trace("The returned data is : "+JSON.stringify(catchedData,null,' '));
					}
					else
					{
						trace("!!! there is no data on the socket !!!");
					}
					socketListener.close();
				}
	}
}