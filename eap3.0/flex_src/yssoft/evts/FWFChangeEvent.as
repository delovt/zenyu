package yssoft.evts
{
	import flash.events.Event;
	
	import mx.events.PropertyChangeEvent;
	
	public class FWFChangeEvent extends Event
	{
		
		public static const PROPERTYCHANGE:String="fwfpropertychange";
		public static const SOURCEOBJECTCHANGE:String="fwfnodechange";
		public var property:String;
		public var oldValue:Object;
		public var newValue:Object;
		public var source:Object;
		public function FWFChangeEvent(type:String,source:Object=null,property:String=null,oldValue:Object=null,newValue:Object=null,bubbles:Boolean=false,cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
			this.property=property;
			this.oldValue=oldValue;
			this.newValue=newValue;
			this.source=source;
		}
		override public function clone():Event
		{
			return new FWFChangeEvent(type,source,property,oldValue,newValue,bubbles,cancelable);
		}
	}
}