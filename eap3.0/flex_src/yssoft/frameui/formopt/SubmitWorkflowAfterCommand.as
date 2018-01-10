package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.impls.ICommand;
	
	public class SubmitWorkflowAfterCommand extends BaseCommand
	{
		public function SubmitWorkflowAfterCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		override public function onExcute():void{
		}
	}
}