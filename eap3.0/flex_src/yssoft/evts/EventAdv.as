package yssoft.evts
{
	import flash.events.Event;
	
	public class EventAdv extends Event
	{
		public static var eventtype:String="EventAdv";
		public var param:Object;
		public function EventAdv(type:String,param:Object)
		{
			super(type,false,false);
			this.param=param;
		}
	}
}