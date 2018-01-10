package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.SaveAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.SaveBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.SavingCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class SaveCommandSelf extends BaseCommand
	{
		//传递的参数
		public var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var saveBeforeCommandSelf:SaveBeforeCommandSelfImp=new SaveBeforeCommandSelfImp();		
		private var savingCommandSelf:SavingCommandSelfImp=new SavingCommandSelfImp();
		private var saveAfterCommandSelf:SaveAfterCommandSelfImp=new SaveAfterCommandSelfImp();
		
		public function SaveCommandSelf(cmdselfName:String,context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			//为保存前注入命令   特殊 加入 保存命令引用 以保证保存前牵扯到回调的命令链控制 lr add
			saveBeforeCommandSelf.saveCommandSelf = this;
			
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
				   case "SaveBeforeCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,saveBeforeCommandSelf);
					   break;
				   }
				   case "SavingCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,savingCommandSelf);
					   break;
				   }
				   case "SaveAfterCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,saveAfterCommandSelf);
					   break;
				   }
			   }
		}
	}
}