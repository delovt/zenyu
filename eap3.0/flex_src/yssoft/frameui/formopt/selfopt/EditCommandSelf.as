package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	import mx.utils.object_proxy;
	
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.EditAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.EditBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.EditingCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.tools.AccessUtil;
	import yssoft.vos.CommandParam;
	import mx.rpc.events.ResultEvent;
	
	public class EditCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var editBeforeCommandSelf:EditBeforeCommandSelfImp=new EditBeforeCommandSelfImp();
		private var editingCommandSelf:EditingCommandSelfImp=new EditingCommandSelfImp();
		private var editAfterCommandSelf:EditAfterCommandSelfImp=new EditAfterCommandSelfImp();
		
		public function EditCommandSelf(cmdselfName:String,context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
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
				   case "EditBeforeCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,editBeforeCommandSelf);
					   break;
				   }
				   case "EditingCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,editingCommandSelf);
					   break;
				   }
				   case "EditAfterCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,editAfterCommandSelf);
					   break;
				   }
			   }
		}
	}
}