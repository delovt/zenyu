package yssoft.frameui.formopt
{
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.frameui.event.FormEvent;
	import yssoft.impls.ICommand;
	import yssoft.tools.AccessUtil;
	
	public class NewAfterCommand extends BaseCommand
	{
		//public var param:Object=null;
		public function NewAfterCommand(context:Container ,optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			this.onNext();
		}
	}
}
