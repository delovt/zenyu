package yssoft.frameui.formopt.selfopt
{
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.DeleteDataGridRowAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.DeleteDataGridRowBeforeCommandSelfImp;
	import yssoft.vos.CommandParam;
	
	public class DeleteDataGridRowCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var DeleteDataGridRowBeforeCommandSelf:DeleteDataGridRowBeforeCommandSelfImp=new DeleteDataGridRowBeforeCommandSelfImp();
		private var DeleteDataGridRowAfterCommandSelf:DeleteDataGridRowAfterCommandSelfImp=new DeleteDataGridRowAfterCommandSelfImp();
		
		public function DeleteDataGridRowCommandSelf(cmdselfName:String,context:Object, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			
			DeleteDataGridRowBeforeCommandSelf.deleteDataGridRowCommandSelf=this;
			
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
				case "DeleteDataGridRowBeforeCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,DeleteDataGridRowBeforeCommandSelf);
					break;
				}
				case "DeleteDataGridRowAfterCommandSelf":
				{
					FormOpt.onCommandSelf(cmdparam,"onExcute",this,DeleteDataGridRowAfterCommandSelf);
					break;
				}
			}
		}
	}
}