package yssoft.frameui.formopt
{
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.core.Container;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.impls.ICommand;
	import yssoft.models.CRMmodel;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	
	public class SavingCommand extends BaseCommand
	{
		//获得用户输入值
		private var paramObj:Object;
		
		//传递的参数
		//public var _param:Object;
		
		private var _optType:String="";
		
		private var arr:Array=null;//用于存放前台传过来的按键数组
		
		public function SavingCommand(context:Container,optType:String, param:*, nextCommand:ICommand, excuteNextCommand:Boolean=false,arr:Array=null)
		{
			this._optType = optType;
			this._param = param;
			this.arr=arr;
			super(context, optType,param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			//super.onExcute();
			onSave();
		}
		
		override public function onResult(result:*):void{
		
		}
		
		//保存
		
		private function onSave():void
		{
			_param.iperson = CRMmodel.userId+"";
			try
			{
				if(arr!=null){
					arr[3].enabled=false;
				}
				if (this._optType == "onNew") {
					AccessUtil.remoteCallJava("CommonalityDest", "addPm", onSaveBack, _param, "正在保存单据，请等待。", true, null, errorHandler);
				}
				else if (this._optType == "onEdit") {
					AccessUtil.remoteCallJava("CommonalityDest", "updatePm", onSaveBack, _param, "正在保存单据，请等待。", true, null, errorHandler);
				}

				
			}
			catch(e:Error){
				arr[3].enabled=true;
				Alert.show("错误，原因："+e.toString());
			}
		}
		
		private function errorHandler(evt:FaultEvent):void{
			Alert.show("错误,原因："+evt.toString());
			arr[3].enabled=true;
		}
		private function onSaveBack(event:ResultEvent):void
		{
			if(event.result!="fail")
			{
				if(this._optType=="onNew"||this._optType=="onEdit")
				{
					if(this._optType=="onNew")
					{
						this._param.value.iid=int(event.result);
					}
					context.data=this._param;
					this.onNext();
				}
				else
				{
					context.data=event.result;
					this.onNext();
				}
			}
			else
			{
				context.data="fail";
				this.onNext();
			}
		}
		
		
	}
}