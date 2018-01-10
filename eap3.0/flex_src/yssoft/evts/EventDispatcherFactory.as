package yssoft.evts
{
	import flash.events.EventDispatcher;
	
	public class EventDispatcherFactory
	{
		private static var _instance:EventDispatcher;
		public static function getEventDispatcher():EventDispatcher
		{
			if( _instance == null )
			{
				_instance = new EventDispatcher();
			}
			return _instance;
		}
	}
}