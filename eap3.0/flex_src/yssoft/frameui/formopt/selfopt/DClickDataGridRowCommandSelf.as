package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.DClickDataGridRowAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.DClickDataGridRowBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.DClickDataGridRowingCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class DClickDataGridRowCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var dclickDataGridRowBeforeCommandSelf:DClickDataGridRowBeforeCommandSelfImp=new DClickDataGridRowBeforeCommandSelfImp();
		private var dclickDataGridRowingCommandSelf:DClickDataGridRowingCommandSelfImp=new DClickDataGridRowingCommandSelfImp();
		private var dclickDataGridRowAfterCommandSelf:DClickDataGridRowAfterCommandSelfImp=new DClickDataGridRowAfterCommandSelfImp();
		
		public function DClickDataGridRowCommandSelf(cmdselfName:String,context:Object, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
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
				case "DClickDataGridRowBeforeCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,dclickDataGridRowBeforeCommandSelf);
					break;
				}
				case "DClickDataGridRowingCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,dclickDataGridRowingCommandSelf);
					break;
				}
				case "DClickDataGridRowAfterCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,dclickDataGridRowAfterCommandSelf);
					break;
				}
			}
		}
	}
}