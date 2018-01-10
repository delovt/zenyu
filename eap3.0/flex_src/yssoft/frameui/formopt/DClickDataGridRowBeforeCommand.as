package yssoft.frameui.formopt
{
	import mx.controls.Alert;
	
	import yssoft.impls.ICommand;
	
	public class DClickDataGridRowBeforeCommand extends BaseCommand
	{
		public function DClickDataGridRowBeforeCommand(context:Object, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		override public function onExcute():void{
			this.onNext();
		}
	}
}