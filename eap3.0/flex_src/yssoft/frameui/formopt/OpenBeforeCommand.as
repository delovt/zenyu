package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.evts.EventAdv;
	import yssoft.impls.ICommand;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	
	public class OpenBeforeCommand extends BaseCommand
	{
		public function OpenBeforeCommand(context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context,optType, param, nextCommand, excuteNextCommand);
		}
		override public function onExcute():void{
		
				this.onNext();
		}
	}
}