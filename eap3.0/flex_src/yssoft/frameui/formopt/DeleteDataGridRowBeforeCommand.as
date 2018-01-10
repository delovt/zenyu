package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.impls.ICommand;
	
	public class DeleteDataGridRowBeforeCommand extends BaseCommand
	{
		public function DeleteDataGridRowBeforeCommand(context:CrmEapDataGrid, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			this.onNext();
		}
	}
}