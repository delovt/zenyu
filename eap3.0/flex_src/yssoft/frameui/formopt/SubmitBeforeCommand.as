package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.impls.ICommand;
	
	public class SubmitBeforeCommand extends BaseCommand
	{
		public function SubmitBeforeCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
	}
}