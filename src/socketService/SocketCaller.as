package socketService
{
	import com.mteamapp.JSONParser;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;

	/**Server connected and receveid data is ready to use*/
	[Event(name="complete", type="flash.events.Event")]
	/**Server connected but the input data was wrong*/
	[Event(name="error", type="flash.events.ErrorEvent")]
	/**Server is not connected*/
	[Event(name="unload", type="flash.events.Event")]
	public class SocketCaller extends EventDispatcher
	{
		private var funcName:String ;
		
		private var socketListener:Socket ;
		
		private var sendThisJSON:String ;
		
		/**This will make jsons to pars again for debugging*/
		private const debug:Boolean = true ;
		
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
			this.dispatchEvent(new Event(Event.UNLOAD));
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
				this.dispatchEvent(new Event(Event.CONNECT));
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
						if(receivedData.indexOf("error")==-1)
						{
							JSONParser.parse(receivedData,catchedData);
						}
						else
						{
							trace("error is :: "+receivedData);							
							this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR)));
							return ;
						}
						if(debug)
						{
							trace("The returned data is : "+JSON.stringify(catchedData,null,' '));
						}
					}
					else
					{
						trace("!!! there is no data on the socket !!!");	
						this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR)));
						return;
					}
					socketListener.close();
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
	}
}