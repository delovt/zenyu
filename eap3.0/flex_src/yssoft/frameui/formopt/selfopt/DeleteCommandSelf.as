package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.DeleteAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.DeleteBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.DeletingCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class DeleteCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var deleteBeforeCommandSelf:DeleteBeforeCommandSelfImp=new DeleteBeforeCommandSelfImp();
		private var deletingCommandSelf:DeletingCommandSelfImp=new DeletingCommandSelfImp();
		private var deleteAfterCommandSelf:DeleteAfterCommandSelfImp=new DeleteAfterCommandSelfImp();
		
		public function DeleteCommandSelf(cmdselfName:String,context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			deleteBeforeCommandSelf.deleteCommandSelf = this;
			
			
			
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
				   case "DeleteBeforeCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,deleteBeforeCommandSelf);
					   break;
				   }
				   case "DeletingCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,deletingCommandSelf);
					   break;
				   }
				   case "DeleteAfterCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,deleteAfterCommandSelf);
					   break;
				   }
			   }
		}
	}
}