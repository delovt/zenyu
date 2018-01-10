package yssoft.evts
{
	import flash.events.Event;
	
	public class NavEvent extends Event
	{
		private var _itemIndex:int;
		public var childIndex:int;

		public function get itemIndex():int
		{
			return _itemIndex;
		}

		public function set itemIndex(value:int):void
		{
			_itemIndex = value;
		}

		public static const OVERCHANGE:String="overchange";
		public static const OUTCHANGE:String="outchange";
		public function NavEvent(type:String,index:int,cindex:int)
		{
			super(type,false,false);
			_itemIndex=index;
			childIndex=cindex;
		}
		
		
	}
}