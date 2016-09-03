package socketService
{
	internal class SocketRequestFormat
	{
		/**Pass the function name here*/
		public var funcName:String ;
		
		public var param:Object ;
		
		public function SocketRequestFormat(theFunctionName:String,requestedData:Object)
		{
			funcName = theFunctionName ;
			param = requestedData ;
		}
	}
}