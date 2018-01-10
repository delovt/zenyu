package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.impls.ICommand;
	
	public class GiveUpBeforeCommand extends BaseCommand
	{
		public function GiveUpBeforeCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
	}
}