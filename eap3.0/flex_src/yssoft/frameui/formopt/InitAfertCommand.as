package yssoft.frameui.formopt
{
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.frameui.FrameCore;
	import yssoft.impls.ICommand;
	import yssoft.tools.CRMtool;
	
	public class InitAfertCommand extends BaseCommand
	{
		
		//传递的参数
		private var _context:FrameCore;
		
		public function InitAfertCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			_context=context as FrameCore;
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
					
		    //返回当前单据是否具有修改或删除数据权限提示集合
		    _context.loadeditordelwarning();
			
			//YJ Add 初始化更多操作菜单
			_context.iniMoreMenuBefore();
			
            this.onNext();
		}

	}
}