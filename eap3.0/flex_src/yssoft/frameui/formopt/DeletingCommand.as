package yssoft.frameui.formopt
{
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.impls.ICommand;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	
	public class DeletingCommand extends BaseCommand
	{
		
		//获得用户输入值
		private var paramObj:Object;
		
		//传递的参数
		//public var _param:Object;
		
		public function DeletingCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			this._param = param;
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		
		//删除
		override public function onExcute():void{
			try
			{
				AccessUtil.remoteCallJava("CommonalityDest","deletePm",onSaveBack,_param,null,false);
			}
			catch(e:Error)
			{
				Alert.show("错误，原因："+e.toString());
			}
		}
		
		private function onSaveBack(event:ResultEvent):void
		{
			context.data=event.result;
			this.onNext();
		}
	}
}