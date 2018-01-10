package yssoft.frameui.formopt
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.frameui.event.FormEvent;
	import yssoft.impls.ICommand;
	import yssoft.tools.AccessUtil;
	
	public class SaveAfterCommand extends BaseCommand
	{
		public var param:Object=null;
		public function SaveAfterCommand(context:Container ,optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			if(context.data is String)
			{
				var evt:FormEvent=new FormEvent(FormEvent.FORM_OPT_FAILURE,"deleteaffter","fail","保存失败...");
				context.dispatchEvent(evt);
			}
			else
			{
				try
				{
					var param:Object = context.data;
					
					if(this.optType=="onNew"||this.optType=="onEdit")
					{
						var _valueObj:Object=new Object();
						var selectSql:String =param.mainSqlObj.selectSql;
						_valueObj.selectSql = selectSql;
						_valueObj.childSql = param.childSqlObj;
						var tableMessage:ArrayCollection=param.tableMessage;
						for(var i:int=0;i<tableMessage.length;i++)
						{
							var obj:Object = tableMessage.getItemAt(i);
							if(Boolean(obj.bMain))
							{
								/*if(obj.foreignKey=="ifuncregedit")
								{
									_valueObj[obj.foreignKey] = param.value.iifuncregedit;
								}
								else
								{*/
									_valueObj[obj.foreignKey] = param.value[obj.foreignKey];
								/*}*/
								break;	
							}
						}
						AccessUtil.remoteCallJava("CommonalityDest","queryPm",queryPmBack,_valueObj,null,false);
					}
					
					
				}
				catch(e:Error){
					Alert.show("错误，原因："+e.toString());
				}
			}
		}
		
		private function queryPmBack(event:ResultEvent):void
		{
			var result:Object = event.result as Object;
			var evt:FormEvent=new FormEvent(FormEvent.FORM_OPT_SUCCES,"saveaffter",result,"保存成功...");
			context["vouchFormValue"]=result;
			
			context["setValue"](result,1,1);
			if(result!=null)
			{
				context["currid"]=result.mainValue.iid;
				context["paramForm"]["currid"]=context["currid"];
			}
			if (context["paramForm"].hasOwnProperty("loadeditordelwarning"))
			{
			    context["paramForm"].loadeditordelwarning();
			}
			context.dispatchEvent(evt);
			this.onNext();
		}
		
		override public function onResult(result:*):void{
			
		}
	}
}