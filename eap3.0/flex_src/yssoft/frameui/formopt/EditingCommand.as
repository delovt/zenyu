package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.frameui.FrameCore;
	import yssoft.impls.ICommand;
	import yssoft.tools.CRMtool;
	
	
	public class EditingCommand extends BaseCommand
	{
		//传递的参数
		//public var _param:Object;
		
		private var _optType:String="";
		
		
		public function EditingCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			this._optType = optType;
			this._param = param; 
			super(context, optType,param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			
			try
			{
				if (context["paramForm"].hasOwnProperty("_vouchFormValue"))
				{
					var crmeap:CrmEapRadianVbox=context["paramForm"].formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
					CRMtool.containerChildsEnabled(crmeap,true);
					crmeap.curButtonStatus = context["paramForm"].curButtonStatus;
					if(Boolean(context["isFirst"]))
					{
						crmeap.setValue(crmeap.fzsj(crmeap.getValue()),0,0);
					}
					else
					{
						crmeap.setValue(crmeap.fzsj(crmeap.getValue()),1,0);
					}
					context["isFirst"]=false;
					context["paramForm"].setAllButtonsEnabled(context["paramForm"].curButtonStatus,context["paramForm"]._vouchFormValue.length);
					context["paramForm"].setOtherButtons(false);
					crmeap.setCurButtonStatus();
				}
				context.data="success";
				this.onNext();
			}
			catch(e:Error)
			{
				context.data="fail";
				CRMtool.showAlert("修改异常！原因："+e.toString()); 
			}
		}
	}
}