package yssoft.views.msg
{
	import flash.events.Event;
	
	public class MsgEvent extends Event
	{
		public static const NEW_MSG:String="new_msg";
		public var msgBody:Object;
		public function MsgEvent(type:String,msgBody:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.msgBody=msgBody;
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new MsgEvent(type,msgBody,bubbles,cancelable);
		}
	}
}