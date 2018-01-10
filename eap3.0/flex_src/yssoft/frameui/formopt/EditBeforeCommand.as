package yssoft.frameui.formopt
{

import mx.core.Container;
import mx.rpc.events.ResultEvent;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.evts.EventAdv;
import yssoft.frameui.FrameCore;
import yssoft.impls.ICommand;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public class EditBeforeCommand extends BaseCommand
	{
	   public function EditBeforeCommand(context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
	   {
		   super(context,optType, param, nextCommand, excuteNextCommand);
	   }
	   override public function onExcute():void
	   {
		   checkUpdate();
	   }
	   
	   public function checkUpdate():void
	   {
           var frameCore:FrameCore = context["paramForm"] as FrameCore;
		   if (context["paramForm"].hasOwnProperty("_vouchFormValue"))
		   {
			   var crmeap:CrmEapRadianVbox=context["paramForm"].formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
			   var mainValue:Object =crmeap.getValue();
			   var param:Object = new Object();
			   param.ifuncregedit=mainValue.iifuncregedit;
			   param.iinvoice=mainValue.iid;
			   param.cfield="bupdate";

			   AccessUtil.remoteCallJava("UtilViewDest","isRepeatedly",function(evt:ResultEvent):void{
				   var isfind:Boolean = evt.result as Boolean;
				   if(isfind)
				   {
					   //如果已经提交不允许修改 lr add
					   if(frameCore&&frameCore.wfiid>0 && frameCore.resultbmodify == false) {
						   CRMtool.showAlert("单据已经绑定了工作流,不允许修改");
						   context.curButtonStatus="onGiveUp";
						   frameCore.curButtonStatus="onGiveUp";
						   return;
						   
					   }
					   
					   //--------------权限控制 刘磊 begin--------------//
					   var warning:String=context["paramForm"]["auth"].reuturnwarning("03");
					   var eventAdv:EventAdv;

					   if(warning=="hasWorkFlow"&&frameCore.resultbmodify == true){
						   warning = null;
					   }else if(warning=="hasWorkFlow"){
						   warning = "请撤消该单据对应的工作流后再执行此操作！";
					   }
					   
					   if (warning!=null){			   
						   CRMtool.showAlert(warning);
						   eventAdv=new EventAdv("EventAuth",false);
						   context.dispatchEvent(eventAdv);
						   context.curButtonStatus="onGiveUp";
						   frameCore.curButtonStatus="onGiveUp";
						   return;
					   }else{
						   eventAdv=new EventAdv("EventAuth",true);
						   context.dispatchEvent(eventAdv);
						   onNext();
					   }
					   //--------------权限控制 刘磊 end--------------//
				   }
				   else
				   {
                       context.curButtonStatus="onGiveUp";
                       frameCore.curButtonStatus="onGiveUp";
					   CRMtool.tipAlert("该单据已经被引用，不能修改！！");
				   }
			   },param,null,false);
		   }
		   else
		   {
			   //如果已经提交不允许修改 lr add
			   if(frameCore&&frameCore.wfiid>0 && frameCore.resultbmodify == false) {
				   CRMtool.showAlert("单据已经绑定了工作流,不允许修改");
				   context.curButtonStatus="onGiveUp";
				   frameCore.curButtonStatus="onGiveUp";
				   return;
				   
			   }
			   
			   //--------------权限控制 刘磊 begin--------------//
			   var warning:String=context["paramForm"]["auth"].reuturnwarning("03");
			   var eventAdv:EventAdv;
			   
			   if(warning=="hasWorkFlow"&&frameCore.resultbmodify == true){
				   warning = null;
			   }else if(warning=="hasWorkFlow"){
				   warning = "请撤消该单据对应的工作流后再执行此操作！";
			   }
			   
			   if (warning!=null){			   
				   CRMtool.showAlert(warning);
				   eventAdv=new EventAdv("EventAuth",false);
				   context.dispatchEvent(eventAdv);
				   context.curButtonStatus="onGiveUp";
				   frameCore.curButtonStatus="onGiveUp";
				   return;
			   }else{
				   eventAdv=new EventAdv("EventAuth",true);
				   context.dispatchEvent(eventAdv);
				   onNext();
			   }
			   //--------------权限控制 刘磊 end--------------//
		   }
	   }
	}
}