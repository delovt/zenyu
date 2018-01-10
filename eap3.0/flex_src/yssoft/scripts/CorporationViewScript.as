import flash.events.Event;

import mx.controls.Alert;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.evts.EventAdv;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

[Bindable]
public var winParam:Object=new Object();
private var formIfunIid:int = 0;
public var curButtonStatus:String = "onGiveUp";
public var formStatus:String = "new";
public var auth:OperDataAuth;
private var crmeap:CrmEapRadianVbox=null;

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
	tre_corporation.CollapseAll();
	CRMtool.containerChildsEnabled(crmeap,false);
	
	if(null==this.tre_corporation.treeCompsXml)
	{
		CRMtool.toolButtonsEnabled(this.lbr_Corporation,"onGiveUp",0);
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_Corporation,"onGiveUp",this.tre_corporation.treeCompsXml.length());
	}
	this.tre_corporation.enabled = true;	
	
}

public function getCorporationTreeXml():void
{
	AccessUtil.remoteCallJava("HrCorporationDest","getAllCorporation",getCorporationcallBackHandler,null,ConstsModel.EPARTMENT_GET_INFO);
}

private function getCorporationcallBackHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		var result:String = event.result as String;
		this.tre_corporation.treeCompsXml = new XML(result);
	}

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


private function onTreeClick(event:Event):void
{
	
	if(tre_corporation.selectedItem!=null){
		
		crmeap.currid=int(tre_corporation.selectedItem.@iid);
		var treid:String = tre_corporation.selectedItem.@iid;		
		crmeap.queryPm(treid);
		crmeap.addEventListener("queryComplete",queryComplete);
	}
}

private function queryComplete(event:Event):void
{
	
	
}

private function complete(event:Event):void
{
	
}


private function onGiveUp(event:Event):void
{
	CRMtool.containerChildsEnabled(crmeap,false);
	
	if(null==this.tre_corporation.treeCompsXml)
	{
		CRMtool.toolButtonsEnabled(this.lbr_Corporation,"onGiveUp",0);
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_Corporation,"onGiveUp",this.tre_corporation.treeCompsXml.length());
	}
	this.tre_corporation.enabled = true;
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
	this.tre_corporation.enabled = false;
	this.tre_corporation.selectedIndex=-1;
	CRMtool.containerChildsEnabled(crmeap,true);
	crmeap.setValue(null,1,1);
	crmeap.curButtonStatus = this.curButtonStatus;
	
	CRMtool.toolButtonsEnabled(this.lbr_Corporation,"onNew");
}

public function myEdit():void
{
	this.curButtonStatus = "onEdit";
	CRMtool.containerChildsEnabled(crmeap,true);
	crmeap.curButtonStatus = this.curButtonStatus;
	if(!this.tre_corporation.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	this.tre_corporation.enabled= false;
	CRMtool.toolButtonsEnabled(this.lbr_Corporation,"onEdit");
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
	var crmeapValue:Object = crmeap.getValue();
	if(tre_corporation.isExistsChild(crmeapValue.ccode,"存在下级目录，不可删除...")){
		return;
	}
	
	curButtonStatus = "onDelete";
	//var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	crmeap.curButtonStatus= this.curButtonStatus;
	crmeap.onDelete();
	crmeap.addEventListener("success",success);
}

public function onSave(event:Event):void
{	
	var crmeapValue:Object = crmeap.getValue();
	
	if(curButtonStatus == "onNew"&&tre_corporation.isExistsCcode(crmeapValue.ccode,"该编码已存在,请重新输入...")){
		return;
	}
	
	if(curButtonStatus == "onEdit"&&crmeapValue.ccode!=tre_corporation.selectedItem.@ccode){
		if(tre_corporation.isExistsCcode(crmeapValue.ccode,"该编码已存在,请重新输入")){
			return;
		}
	}
	
	
	if(crmeapValue.ccode==null){
		CRMtool.showAlert("需要填入内容才可保存");
	}
	else if (tre_corporation.isExistsParent(crmeapValue.ccode,"上级目录不存在,请重新输入...")){			
			var ipid:int  = tre_corporation.getIpid(crmeapValue.ccode);
			crmeapValue.ipid = ipid;
			var main:Object=new Object();
			main.mainValue=crmeapValue;
			
			//Alert.show(ObjectUtil.toString(main));
			
			crmeap.setValue(main);
			crmeap.onSave();	
			crmeap.addEventListener("success",success);
		}
	
}


private function updateCorpTreeCcode(event:ResultEvent):void
{
	var vo:Object = crmeap.getValue();	
	tre_corporation.EditTreeNode(vo);
}

private function success(event:Event):void
{
	switch (curButtonStatus){
		case "onEdit":{
			var crmeapValue:Object = crmeap.getValue();
			var oldCcode:String = tre_corporation.selectedItem.@ccode;
			var ccode:String = crmeapValue.ccode;
			crmeapValue.oldCcode = oldCcode
			//Alert.show(ObjectUtil.toString(crmeapValue));
				if(ccode!=oldCcode){
					AccessUtil.remoteCallJava("HrCorporationDest","updateCorporationCcode",updateCorpTreeCcode,crmeapValue);
				}else{
					var vo:Object = crmeap.getValue();	
					tre_corporation.EditTreeNode(vo);
				}

			break;
		}
		case "onNew":{
			var vo:Object = crmeap.getValue();
			vo.iid = crmeap.currid;
			tre_corporation.AddTreeNode(vo);
			break;
		}
		case "onDelete":{
			tre_corporation.DeleteTreeNode();
			this.tre_corporation.selectedIndex=-1;
			crmeap.setValue(null,1,1);
			break;
		}
			
	}
	
	tre_corporation.enabled = true;
	setAllButtonsEnabled("onGiveUp");
}

//设置按钮互斥
public function setAllButtonsEnabled(selectedName:String,length:int=1):void
{
	CRMtool.toolButtonsEnabled(this.lbr_Corporation,selectedName,length);
}
