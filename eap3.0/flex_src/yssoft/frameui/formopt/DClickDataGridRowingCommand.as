package yssoft.frameui.formopt
{
	import yssoft.impls.ICommand;
	
	public class DClickDataGridRowingCommand extends BaseCommand
	{
		public function DClickDataGridRowingCommand(context:Object, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		override public function onExcute():void{
			this.onNext();
		}
	}
}