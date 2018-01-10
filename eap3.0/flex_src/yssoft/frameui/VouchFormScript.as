import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.containers.TitleWindow;
import mx.events.ItemClickEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import yssoft.comps.ConsultTree;
import yssoft.comps.ConsultTreeImportUI;
import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.frameui.RightVouchForm;
import yssoft.frameui.VouchForm;
import yssoft.frameui.event.FormEvent;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;


[Bindable]
public var curButtonStatus:String="onGiveUp";
[Bindable]
public var triggerCrmEapControl:Object=null;
[Bindable]
private var bb_opt_items:ArrayCollection=new ArrayCollection([
	{label:"增加",name:"onNew"		},
	{label:"修改",name:"onEdit"	},
	{label:"删除",name:"onDelete"	},
	{label:"保存",name:"onSave"	},
	{label:"放弃",name:"onGiveUp"	}
	
]);
//菜单(列表)传参
[Bindable]
public var winParam:Object=new Object();

private var tableMessage:ArrayCollection;

private var _vouchFormArr:ArrayList;

private var flag:Boolean;

// 单据功能注册码
[Bindable]
public var formIfunIid:int=0;

public var currid:int=0;




/**
 *  单据状态, 新增 new ，编辑 edit ，浏览 browser, 默认为新增 new
 * 	从菜单触发 状态为new，从其他触发与单据列表触发 可以设为new,edit,browser其中之一
 */
[Bindable]
public var formStatus:String="new";

//权限类对象
public var auth:OperDataAuth;

// 窗体初始化后，添加相关操作事件

private function onFormOpt(event:FormEvent):void{
	
}

//打开（初始化界面）进行按钮互斥
private function initWindow():void
{
	//初始化权限
	auth=new OperDataAuth();
	//---------------加载操作权限 begin---------------//
	var params1:Object=new Object();
	var itemObj:Object = CRMtool.getObject(winParam);
	params1.ifuncregedit=itemObj.ifuncregedit;
	params1.iperson=CRMmodel.userId;
	auth.get_funoperauth(params1);
	//---------------加载操作权限 end---------------//
	winParam = CRMtool.getObject(this.winParam);
	this.formIfunIid = int(winParam.ifuncregedit);
	var crmeap:CrmEapRadianVbox = new CrmEapRadianVbox();
	crmeap.name="myCanva";
	crmeap.curButtonStatus=this.curButtonStatus;
	crmeap.formIfunIid = this.formIfunIid;
	crmeap.owner=this;
	crmeap.addEventListener("complete",complete);
	crmeap.queryVouchForm();
	this.formShowArea.addChild(crmeap);
	setAllButtonsEnabled(this.curButtonStatus,0);
}

public function onWindowInit():void
{
	initWindow();
}

private function complete(event:Event):void
{
	
}

//窗体打开
public function onWindowOpen():void
{
	this.formShowArea.removeAllChildren();
	this.formStatus="new";
	this.curButtonStatus="onGiveUp";
	onWindowInit();
	this.righVouchFrom.onWindowInit();
	this.righVouchFrom.enabled=true;
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
}

private function bb_itemclick(event:ItemClickEvent):void
{
	
	
	if(event.item.name == "onNavData"){ // 不做处理
		return;
	}
	// 区分导航按钮组,不记录 该组按钮的状态
	
	// 判断当前按钮状态
	var type:String=event.item.name as String;

	if(type!="onSave")
	{
		curButtonStatus=event.item.name; // 记录当前按钮状态
	}
	
	
	//执行按钮对应的 相关功能函数
	this[event.item.name]();
	
	//var f:FormOpt;
}

//设置按钮互斥
public function setAllButtonsEnabled(selectedName:String,length:int=1):void
{
	CRMtool.toolButtonsEnabled(this.bb_opt,selectedName,length);
}

// 增加
private function onNew():void
{
	if(!this.righVouchFrom.tre_vouch.selectedItem)
	{
		CRMtool.tipAlert("请选择一条记录!");
		return;
	}

	var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	queryComplete(crmeap);
	if(this.righVouchFrom.tre_vouch.selectedItem.@ctable != ""){
		if(flag==false){
			CRMtool.showAlert("表单设置已存在不允许在增加");
			this.curButtonStatus="onGiveUp";
			return;
		}
	}

	this.righVouchFrom.enabled=false;
	setAllButtonsEnabled(this.curButtonStatus);
	crmeap.curButtonStatus = this.curButtonStatus;
	crmeap.setCurButtonStatus();
		
	var ifuncregedit:String =this.righVouchFrom.tre_vouch.selectedItem.@iid;
	var ojb:Object = new Object();
	var obj:Object=crmeap.getValue();
	obj.ifuncregedit=ifuncregedit;
	ojb.mainValue=obj;
	
	crmeap.ifun = obj.ifuncregedit;
	crmeap.setValue(ojb,1);
	impt.enabled=true;
	CRMtool.containerChildsEnabled(crmeap,true);
	
}

private function queryComplete(crmeap:CrmEapRadianVbox):void
{
	if(crmeap.vouchFormValue != null){
		var tableList:ArrayCollection =crmeap.vouchFormValue.ac_vouchform as ArrayCollection;
		if(tableList!=null&&tableList.length>0)
		{
			this.flag = false;
			this.btn_automatic.enabled=false;
	
		}
		else
		{
			this.flag = true;
			this.btn_automatic.enabled=true;
		}
	}
}

// 修改
private function onEdit():void
{
	if(!this.righVouchFrom.tre_vouch.selectedItem)
	{
		CRMtool.tipAlert("请选择一条记录!");
		return;
	}
	
	this.righVouchFrom.enabled=false;
	var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	queryComplete(crmeap);
	CRMtool.containerChildsEnabled(crmeap,true);
	crmeap.setCurButtonStatus();
	crmeap.curButtonStatus = this.curButtonStatus;
	setAllButtonsEnabled(this.curButtonStatus);
}
// 删除
private function onDelete():void
{
	if(!this.righVouchFrom.tre_vouch.selectedItem)
	{
		CRMtool.tipAlert("请选择一条记录!");
		return;
	}

	var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	crmeap.curButtonStatus= this.curButtonStatus;
	crmeap.onDelete();
	this.flag = true;
	crmeap.addEventListener("success",success);
}

private function success(event:Event):void
{
	this.curButtonStatus="onGiveUp";
	this.righVouchFrom.enabled=true;
	setAllButtonsEnabled("onGiveUp");
	CRMtool.tipAlert("操作成功!");
	(this as VouchForm).righVouchFrom.treeMenu_itemClickHandler();
}

// 保存
private function onSave():void
{
	var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	crmeap.onSave(1);
	crmeap.addEventListener("success",success);
}
// 放弃
private function onGiveUp():void
{
	var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
    //crmeap.vouchFormValue.mainValue = crmeap.oldvouchFormValue.mainValue;
    //crmeap.vouchFormValue.ac_vouchform = crmeap.oldvouchFormValue.ac_vouchform;
	setAllButtonsEnabled(this.curButtonStatus);
	crmeap.setCurButtonStatus();
	this.btn_automatic.enabled=false;
	this.righVouchFrom.enabled=true;
	impt.enabled=false;
	CRMtool.containerChildsEnabled(crmeap,false);
    //crmeap.setValue(crmeap.vouchFormValue, 1, 1);
}


private function automaticallyGenerated():void
{
	AccessUtil.remoteCallJava("CommonalityDest","automaticallyGenerated",reSetAllBack,int(this.righVouchFrom.tre_vouch.selectedItem.@iid),null,false);
}


private function reSetAllBack(event:ResultEvent):void
{
	var crmeap:CrmEapRadianVbox=this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
	
	var tableList:ArrayCollection =event.result as ArrayCollection;
	var obj:Object = new Object();
	obj.mainValue = crmeap.getValue();
	obj.ac_vouchform=tableList;
	crmeap.setValue(obj);
}
/**
 * 点击引入按钮弹出功能目录
 * 创建人：王炫皓
 * 创建时间：20121121
 * */
private function impt_clickHandler(event:MouseEvent):void{
	
	var imports:ConsultTreeImportUI = new ConsultTreeImportUI();
	imports.crmEapRadianVbox = this.formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;

	CRMtool.openView(imports,false);
}
