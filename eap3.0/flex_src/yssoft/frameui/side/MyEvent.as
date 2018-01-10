package yssoft.frameui.side
{
	import flash.events.Event;
	
	public class MyEvent extends Event
	{
		private var _data:Object;

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		
		public function MyEvent(myData:Object,type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data=myData;
			
		}
	}
}