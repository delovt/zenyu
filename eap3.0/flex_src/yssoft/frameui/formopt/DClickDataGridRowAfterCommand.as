package yssoft.frameui.formopt
{
	import mx.controls.Alert;
	
	import yssoft.impls.ICommand;
	
	public class DClickDataGridRowAfterCommand extends BaseCommand
	{
		public function DClickDataGridRowAfterCommand(context:Object, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		override public function onExcute():void{
			this.onNext();
		}
	}
}