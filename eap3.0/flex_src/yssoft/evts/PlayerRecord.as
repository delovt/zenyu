package yssoft.evts
{
	import flash.events.Event;
	
	public class PlayerRecord extends Event
	{
		public static var eventtype:String="playRecord";
		public var param:Object;
		public function PlayerRecord(type:String,param:Object)
		{
			super(type,false,false);
			this.param=param;
		}
	}
}