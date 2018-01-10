import flash.events.Event;

import mx.events.ItemClickEvent;
import mx.rpc.events.ResultEvent;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.evts.EventAdv;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.corpCmdPerson.CorpTitleWindow;

[Bindable]
public var winParam:Object=new Object();
private var formIfunIid:int = 0;
public var curButtonStatus:String = "onGiveUp";
public var formStatus:String = "new";

public var auth:OperDataAuth;
private var crmeap:CrmEapRadianVbox=null;

private var onSelectItem_iid:String;

//窗体初始化
public function onWindowInit():void{
	//Alert.show("init");
}
//窗体打开
public function onWindowOpen():void{
	//Alert.show("open");
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void{
	tre_corpCmdPerson.CollapseAll();
	CRMtool.containerChildsEnabled(crmeap,false);
	
	if(null==this.tre_corpCmdPerson.treeCompsXml)
	{
		CRMtool.toolButtonsEnabled(this.myButtonBar,"onGiveUp",0);
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.myButtonBar,"onGiveUp",this.tre_corpCmdPerson.treeCompsXml.length());
	}
	this.tre_corpCmdPerson.enabled = true;	
	
}

protected function myButtonbar_itemClickHandler(event:ItemClickEvent):void
{
	if(tre_corpCmdPerson.selectedItem==null){
		return;
	}
	
	//分配公司
	if(0==event.index){
		var ctw:CorpTitleWindow = new CorpTitleWindow();
		ctw.callBack = callBackHandler;
		ctw.getCorporationTreeXml(onSelectItem_iid);
		CRMtool.openView(ctw);
		
	}
	//密码重置
	if(1==event.index){
		var obj:Object = new Object();
		obj.iid = onSelectItem_iid;
		obj.oldpwd = 1;
		obj.resetFlag = 1;
		AccessUtil.remoteCallJava("hrPersonDest","modityResetPwd",resetPasswordBackHandler,obj,ConstsModel.EPARTMENT_GET_INFO);
	}
}

public function resetPasswordBackHandler(event:ResultEvent):void
{
	CRMtool.showAlert("重置密码成功");
}

public function callBackHandler():void{
	refTree();		
}

public function CorpCmdPersonTreeXml():void
{
	AccessUtil.remoteCallJava("CorpCmdPersonDest","getCmdPersonAndCorp",getCorporationcallBackHandler,null,ConstsModel.EPARTMENT_GET_INFO);
}

private function getCorporationcallBackHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		var result:String = event.result as String;
		this.tre_corpCmdPerson.treeCompsXml = new XML(result);
	}
	initForm();
}

private function initForm():void
{
	auth = new OperDataAuth();
	//---------------加载操作权限 begin---------------//
	var params1:Object=new Object();
	var itemObj:Object = CRMtool.getObject(winParam);
	params1.ifuncregedit=itemObj.ifuncregedit;
	params1.iperson=CRMmodel.userId;
	auth.get_funoperauth(params1);
	//---------------加载操作权限 end---------------//
	
	winParam = CRMtool.getObject(this.winParam);
	this.formIfunIid = int(winParam.ifuncregedit);
	
	crmeap = new CrmEapRadianVbox();
	crmeap.name="myCanva";
	crmeap.curButtonStatus=this.curButtonStatus;
	crmeap.formIfunIid = this.formIfunIid;
	crmeap.owner=this;
	crmeap.addEventListener("complete",complete);
	crmeap.addEventListener("EventAuth",authEventListener);
	crmeap.queryVouchForm();
	this.formShowArea.addChild(crmeap);
	
	setAllButtonsEnabled("onGiveUp");

}


private function refTree():void
{
	CorpCmdPersonTreeXml();
}

private function onTreeClick(event:Event):void
{
	
	if(tre_corpCmdPerson.selectedItem!=null){
		if(tre_corpCmdPerson.selectedItem.@ipid==-1){
			crmeap.currid=int(tre_corpCmdPerson.selectedItem.@iid);
			var treid:String = tre_corpCmdPerson.selectedItem.@iid;		
			onSelectItem_iid = treid;
			crmeap.queryPm(treid);
			crmeap.addEventListener("queryComplete",queryComplete);
			

		}
	}
}

private function queryComplete(event:Event):void
{
	
	
}

private function complete(event:Event):void
{
	//crmeap.setValue(null,1,0);
}


private function onGiveUp(event:Event):void
{
	CRMtool.containerChildsEnabled(crmeap,false);
	
	if(null==this.tre_corpCmdPerson.treeCompsXml)
	{
		CRMtool.toolButtonsEnabled(this.lbr_corpCmdPerson,"onGiveUp",0);
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_corpCmdPerson,"onGiveUp",this.tre_corpCmdPerson.treeCompsXml.length());
	}
	this.tre_corpCmdPerson.enabled = true;
}


private function authEventListener(event:EventAdv):void
{
	var result:Boolean = event.param;
	if(result)
	{
		if(curButtonStatus == "onNew"){
			myNew();
		}
		if(curButtonStatus == "onEdit"){
			myEdit();
		}
	}
}


public function myNew():void
{
	this.curButtonStatus = "onNew";
	this.tre_corpCmdPerson.enabled = false;
	this.tre_corpCmdPerson.selectedIndex=-1;
	CRMtool.containerChildsEnabled(crmeap,true);
	crmeap.setValue(null,1,1);
	crmeap.curButtonStatus = this.curButtonStatus;
	
	CRMtool.toolButtonsEnabled(this.lbr_corpCmdPerson,"onNew");
}

public function myEdit():void
{
	this.curButtonStatus = "onEdit";
	CRMtool.containerChildsEnabled(crmeap,true);
	crmeap.curButtonStatus = this.curButtonStatus;
	if(!this.tre_corpCmdPerson.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	this.tre_corpCmdPerson.enabled= false;
	CRMtool.toolButtonsEnabled(this.lbr_corpCmdPerson,"onEdit");
}


public function onNew(event:Event):void
{
	this.curButtonStatus = "onNew";
	crmeap.onNew();
}

public function onEdit(event:Event):void
{
	this.curButtonStatus = "onEdit";
	crmeap.onEdit();
}

public function onDelete(event:Event):void
{
	
	curButtonStatus = "onDelete";
	//var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	crmeap.curButtonStatus= this.curButtonStatus;
	crmeap.onDelete();
	crmeap.addEventListener("success",success);
}

public function onSave(event:Event):void
{	
	var crmeapValue:Object = crmeap.getValue();
	crmeapValue.iproperty = 2;
	var main:Object=new Object();
	main.mainValue=crmeapValue;
	
	crmeap.setValue(main);
	crmeap.onSave();	
	crmeap.addEventListener("success",success);
	
	
}



private function success(event:Event):void
{
	switch (curButtonStatus){

		case "onDelete":{
			crmeap.currid=int(tre_corpCmdPerson.selectedItem.@iid);
			var treid:String = tre_corpCmdPerson.selectedItem.@iid;	
			AccessUtil.remoteCallJava("CorpCmdPersonDest","delPersons",null,treid,ConstsModel.EPARTMENT_GET_INFO);
			this.tre_corpCmdPerson.selectedIndex=-1;
			crmeap.setValue(null,1,1);			
			break;
		}
			
	}
	
	refTree();
	
	tre_corpCmdPerson.enabled = true;
	setAllButtonsEnabled("onGiveUp");
}

//设置按钮互斥
public function setAllButtonsEnabled(selectedName:String,length:int=1):void
{
	CRMtool.toolButtonsEnabled(this.myButtonBar,selectedName,length);
}
