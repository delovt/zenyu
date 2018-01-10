package yssoft.evts
{
	import flash.events.Event;
	
	public class TwitterEvent extends Event
	{
		public static var onMainViewRender2ListClick:String="onMainViewRender2ListClick";
		
		public static var onMainViewRefresh:String="onMainViewRefresh";
		
		public static var onMainViewHotItemClick:String="onMainViewHotItemClick";
		
		public static var onMainViewCreamItemClick:String="onMainViewCreamItemClick";
		
		public static var onListViewReturnClick:String="onListViewReturnClick";
		
		public static var onDetailViewReturnClick:String="onDetailViewReturnClick";
		
		public static var onListViewItemClick:String="onListViewItemClick";
		
		public static var onListViewRefresh:String="onListViewRefresh";
		
		public static var onDetailViewRefresh:String="onDetailViewRefresh";
		
		public static var onDetailViewItemReply:String="onDetailViewItemReply";
		
		public static var onDetailViewItemQuote:String="onDetailViewItemQuote";
		
		public static var onDetailViewItemShield:String="onDetailViewItemShield";
		
		
		//----------------------------------------twitter type view events-----------------------------------
			
		public static var onTypeViewPersonSelected:String="onTypeViewPersonSelected";
		
		public var obj:Object;
		
		public function TwitterEvent(type:String, _obj:Object=null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			obj = _obj;
		}
		
		override public function clone():Event
		{
			return new TwitterEvent(type,obj,bubbles,cancelable);
		}
		
		
		
	}
}