package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.impls.ICommand;
	
	public class SubmitAfterCommand extends BaseCommand
	{
		public function SubmitAfterCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
	}
}