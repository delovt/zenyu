package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.impls.ICommand;
	import yssoft.tools.CRMtool;
	
	public class AddDataGridRowAfterCommand extends BaseCommand
	{
		public function AddDataGridRowAfterCommand(context:CrmEapDataGrid, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		override public function onExcute():void{
			this.onNext();
		}
	}
}