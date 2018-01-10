package yssoft.evts
{
	import flash.events.Event;
	
	public class SumEvent extends Event
	{
		public var sum:Number=0;
		
		public static const sum_event:String="sum_event";
		
		public function SumEvent(type:String,sum:Number=0)
		{
			super(type,false,true);
			this.sum=sum;
		}
		
	}
}