package yssoft.evts
{
	import flash.events.Event;
	
	public class WorkFlowEvent extends Event
	{
		// 要选中 节点
		public static const SELETED_NODE:String="seletedNode";
		public function WorkFlowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			//TODO: implement function
			super(type, bubbles, cancelable);
		}
	}
}