package yssoft.frameui.formopt
{
import flash.events.Event;

import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.frameui.FrameCore;
	import yssoft.impls.ICommand;
	import yssoft.models.CRMmodel;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	
	public class SubmitWorkflowingCommand extends BaseCommand
	{
		public function SubmitWorkflowingCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			submitWorkFlow();
			
		}
		
		private function submitWorkFlow():void
		{
			var frameCore:FrameCore = context["paramForm"] as FrameCore;
            var cexecsql:String = CRMtool.replaceCrmeapAndSystemValues(frameCore.cexecsql,frameCore.crmeap);
			AccessUtil.remoteCallJava("WorkFlowDest","coopHandler",coopCallBack,{ifuncregedit:frameCore.formIfunIid,iinvoice:frameCore.currid,iperson:CRMmodel.userId,cexecsql:cexecsql});
		}
		
		private function coopCallBack(event:ResultEvent):void
		{
			var frameCore:FrameCore = context["paramForm"] as FrameCore;
			var crmeap:CrmEapRadianVbox = frameCore.crmeap;
			//Alert.show(""+(event.result as String),"提交返回信息");
			var ret:String=event.result as String;
			if(isNaN(parseInt(ret))){
				CRMtool.tipAlert(ret);
				//setWfStatusDes("提交工作流失败");
			}else{
				//frameCore.currid=parseInt(ret); //获取生成后的 工作流 内码
				frameCore.wfiid = parseInt(event.result as String);
				//setWfStatusDes("协同浏览["+frameCore.wfiid+"]");
				setWfStatusDes("已提交");
				//this.getWordFlowDetail(this.formIfunIid,this.currid,0);
//				frameCore.leftPart.refreshData(frameCore.formIfunIid,frameCore.currid,frameCore.wfiid);
				//wtf add
				frameCore.coreSide.refreshData(frameCore.formIfunIid,frameCore.currid,frameCore.wfiid,false);
				//获取工作流节点信息
				if(frameCore.currentState=="draw"){
					frameCore.workflow.getFormWorkFlow(frameCore.formIfunIid,frameCore.currid);
					isShowDeleteImg();
				}

                frameCore.dispatchEvent(new Event("cardValueChange"));
			}
			var _csubject:String="";
			for(var j:int=0;j<crmeap.vouchFormArr.length;j++)
			{
				var _datadictionaryObj:Object = crmeap.vouchFormArr.getItemAt(j);
				if(_datadictionaryObj.childMap is ArrayCollection)
				{
					var childlist:ArrayCollection=_datadictionaryObj.childMap;
					if (childlist.length>0)
					{
						for(var k:int=0;k<childlist.length;k++)
						{
							var childObj:Object =childlist.getItemAt(k);
							var st:String = "";
							if(childObj.iconsult!=null&&childObj.iconsult>0)
							{
								st=crmeap.getconsultsetResult(childObj.cfield);
							}
							else
							{
								st=crmeap.getValue()[childObj.cfield];
							}
							if(childObj.bintitle!=null&&(childObj.bintitle=="1"||Boolean(childObj.bintitle))&&null!=st&&""!=st)
							{
								if(childObj.iconsult>0)
								{
									_csubject=_csubject+"_"+crmeap.getconsultsetResult(childObj.cfield+"");
								}
								else
								{
									_csubject=_csubject+"_"+crmeap.getValue()[childObj.cfield+""];
								}
							}
						}
					}
				}
				
			}
			var paramObj:Object = new Object();
			paramObj.csubject = _csubject;
			paramObj.ifuncregedit = crmeap.formIfunIid;
			paramObj.iinvoice = crmeap.currid;
			AccessUtil.remoteCallJava("hrPersonDest","updatecsubject",null,paramObj);
			this.onNext();
		}
		
		private function setWfStatusDes(info:String=""):void{
			var frameCore:FrameCore = context["paramForm"] as FrameCore;
			frameCore.setWfStatusDes(info);
		}
		
		// 设置工作流中 删除图标的 是否显示
		private function isShowDeleteImg(bool:Boolean=false):void
		{
			var frameCore:FrameCore = context["paramForm"] as FrameCore;
			if(frameCore.workflow){
				frameCore.workflow.wf_trash.visible=bool;
			}
		}
	}
}