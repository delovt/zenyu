package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.AddDataGridRowAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.AddDataGridRowBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.AddDataGridRowingCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class AddDataGridRowCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var addDataGridRowBeforeCommandSelf:AddDataGridRowBeforeCommandSelfImp=new AddDataGridRowBeforeCommandSelfImp();
		private var addDataGridRowingCommandSelf:AddDataGridRowingCommandSelfImp=new AddDataGridRowingCommandSelfImp();
		private var addDataGridRowAfterCommandSelf:AddDataGridRowAfterCommandSelfImp=new AddDataGridRowAfterCommandSelfImp();
		
		public function AddDataGridRowCommandSelf(cmdselfName:String,context:Object, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			cmdparam.context=context;
			cmdparam.optType=optType;
			cmdparam.param=param;
			cmdparam.nextCommand=nextCommand;
			cmdparam.excuteNextCommand=excuteNextCommand;
			cmdparam.cmdselfName=cmdselfName;
			super(context,optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			switch(cmdparam.cmdselfName)
			{
				case "AddDataGridRowBeforeCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,addDataGridRowBeforeCommandSelf);
					break;
				}
				case "AddDataGridRowingCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,addDataGridRowingCommandSelf);
					break;
				}
				case "AddDataGridRowAfterCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,addDataGridRowAfterCommandSelf);
					break;
				}
			}
		}
	}
}