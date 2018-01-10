package yssoft.evts
{
	import flash.events.Event;
	
	public class GetNumberEvent extends Event
	{
		public static var eventtype:String="GetCallNumber";
		public var param:Object;
		public function GetNumberEvent(type:String,param:Object)
		{
			super(type,false,false);
			this.param=param;
		}
	}
}