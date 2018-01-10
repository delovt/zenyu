package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.GiveUpAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.GiveUpBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.GiveUpingCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class GiveUpCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var giveUpBeforeCommandSelf:GiveUpBeforeCommandSelfImp=new GiveUpBeforeCommandSelfImp();
		private var giveUpingCommandSelf:GiveUpingCommandSelfImp=new GiveUpingCommandSelfImp();
		private var giveUpAfterCommandSelf:GiveUpAfterCommandSelfImp=new GiveUpAfterCommandSelfImp();
		
		public function GiveUpCommandSelf(cmdselfName:String,context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
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
				   case "GiveUpBeforeCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,giveUpBeforeCommandSelf);
					   break;
				   }
				   case "GiveUpingCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,giveUpingCommandSelf);
					   break;
				   }
				   case "GiveUpAfterCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,giveUpAfterCommandSelf);
					   break;
				   }
			   }
		}
	}
}