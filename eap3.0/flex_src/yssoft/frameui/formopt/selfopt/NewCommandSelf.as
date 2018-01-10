package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.NewingCommandSelfImp;
	import yssoft.scripts.selfoptimp.NewAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.NewBeforeCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class NewCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var newBeforeCommandSelf:NewBeforeCommandSelfImp=new NewBeforeCommandSelfImp();
		private var newingCommandSelf:NewingCommandSelfImp=new NewingCommandSelfImp();
		private var newAfterCommandSelf:NewAfterCommandSelfImp=new NewAfterCommandSelfImp();
		
		public function NewCommandSelf(cmdselfName:String,context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
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
				   case "NewBeforeCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,newBeforeCommandSelf);
					   break;
				   }
				   case "NewingCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,newingCommandSelf);
					   break;
				   }
				   case "NewAfterCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,newAfterCommandSelf);
					   break;
				   }
			   }
		}
	}
}