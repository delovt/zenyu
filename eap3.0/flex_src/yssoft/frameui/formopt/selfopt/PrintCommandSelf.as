package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.PrintingCommandSelfImp;
	import yssoft.scripts.selfoptimp.PrintAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.PrintBeforeCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class PrintCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var printBeforeCommandSelf:PrintBeforeCommandSelfImp=new PrintBeforeCommandSelfImp();
		private var printingCommandSelf:PrintingCommandSelfImp=new PrintingCommandSelfImp();
		private var printAfterCommandSelf:PrintAfterCommandSelfImp=new PrintAfterCommandSelfImp();
		
		public function PrintCommandSelf(cmdselfName:String,context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
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
				   case "PrintBeforeCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,printBeforeCommandSelf);
					   break;
				   }
				   case "PrintingCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,printingCommandSelf);
					   break;
				   }
				   case "PrintAfterCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,printAfterCommandSelf);
					   break;
				   }
			   }
		}
	}
}