package yssoft.evts
{
	import flash.events.Event;
	
	public class EventGetCall extends Event
	{
		public static var eventtype:String="GetCall";
		public var param:String;
		public function EventGetCall(type:String,param:String)
		{
			super(type,false,false);
			this.param=param;
		}
	}
}