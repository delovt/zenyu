import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.events.ResultEvent;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public var parentForm:Object;

public function onWindowInit():void
{
	parentForm = this.owner; 
	var objvalue:Object = new Object();
	objvalue.sqlcondition = " bvouchform=1";
	objvalue.single="";
	AccessUtil.remoteCallJava("DatadictionaryDest","getTreeMenuList",onWindowInitBack,objvalue);
}

private function onWindowInitBack(event:ResultEvent):void
{
	if(event.result!=null)
	{
		var treexml:XML = new XML(event.result as String);
		this.tre_vouch.treeCompsXml = treexml;
	}
}

//窗体打开
public function onWindowOpen():void
{
	onWindowInit();
}

//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}

public function treeMenu_itemClickHandler():void
{
	if(!this.tre_vouch.selectedItem)
	{
		CRMtool.tipAlert("请选择一条记录!");
		return;
	}
	if(this.tre_vouch.selectedItem.@ctable!="")
	{
		var crmeap:CrmEapRadianVbox=parentForm.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
		//获取选中向的功能内码
		var ifuncregedit:String =this.tre_vouch.selectedItem.@iid;
		var ojb:Object = new Object();
		var obj:Object=new Object();
		obj.ifuncregedit=ifuncregedit;
		ojb.mainValue=obj;
		crmeap.popupTree = true;
		crmeap.setValue(ojb,1);
		crmeap.queryPm(ifuncregedit);
		crmeap.addEventListener("queryComplete",queryComplete);
	}
}

private function queryComplete(event:Event):void
{
	var crmeap:CrmEapRadianVbox=parentForm.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	if(crmeap.vouchFormValue.mainValue==null)
	{
		parentForm.setAllButtonsEnabled(parentForm.curButtonStatus,0);
	}
	else
	{
		parentForm.setAllButtonsEnabled(parentForm.curButtonStatus);
	}
}



