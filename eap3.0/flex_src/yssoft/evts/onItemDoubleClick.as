package yssoft.evts
{
	import flash.events.Event;
	
	public class onItemDoubleClick extends Event
	{
		public static var eventtype:String="onItemDoubleClick";
		public var param:Object;
		public function onItemDoubleClick(type:String,param:Object)
		{
			super(type,false,false);
			this.param=param;
		}
	}
}