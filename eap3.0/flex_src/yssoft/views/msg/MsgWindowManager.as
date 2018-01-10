package yssoft.views.msg
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 *  消息发送窗体管理
	 */
	public class MsgWindowManager extends EventDispatcher
	{
		[Bindable]
		public var windowList:Array = new Array();	
		public function MsgWindowManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function add(sendMsgView:SendMsgView):void{
			if(this.windowList.indexOf(sendMsgView) < 0 ){
				this.windowList.push(sendMsgView);
			}
		}
	}
}