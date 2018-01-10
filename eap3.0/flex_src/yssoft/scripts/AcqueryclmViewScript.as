import flash.events.KeyboardEvent;
import flash.utils.describeType;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.ComboBox;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import mx.events.DataGridEventReason;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.SecurityUtil;
import mx.utils.StringUtil;

import yssoft.comps.frame.module.CrmEapTextInput;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.sysmanage.AcqueryclmView;
import yssoft.vos.AsAcQueryclmVO;

[Bindable]public var operType:String;
[Bindable]public var arrDataList:ArrayCollection = new ArrayCollection();	//数据集
[Bindable]protected var treeXml:String;
[Bindable]protected var asacquaryclmvo:AsAcQueryclmVO = new AsAcQueryclmVO();
[Bindable]public var myenabled:Boolean  = false;
//菜单
[Bindable]protected var menubar:ArrayCollection=new ArrayCollection(
	[
		{label:"增加",name:"onNew"},
		{label:"修改",name:"onEdit"},
		{label:"删除",name:"onDelete"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"}
	]
);

//字段类型
[Bindable]public var arr_ifieldtype:ArrayCollection=new ArrayCollection(
	[
		{label:"",		data:"-1"},
		{label:"字符",	data:"0"},
		{label:"整数",	data:"1"},
		{label:"浮点数",data:"2"},
		{label:"日期",	data:"3"},
		{label:"布尔",	data:"4"},
		{label:"图片",	data:"5"}		
	]
);

//常用条件类型
[Bindable]public var arr_icmtype:ArrayCollection=new ArrayCollection(
	[
		{label:"",data:"-1"},
		{label:"单项",	data:"0"},
		{label:"区间",	data:"1"},
		{label:"多选",data:"2"},
		{label:"是否BIT型",	data:"3"}
	]
);

//常用条件类型
[Bindable]public var arr_isttype:ArrayCollection=new ArrayCollection(
	[
		{label:"",data:"-1"},
		{label:"无序",	data:"0"},
		{label:"升序",	data:"1"},
		{label:"降序",data:"2"}
	]
);

[Bindable] public var arr_cdefault:ArrayCollection=new ArrayCollection(
	[
		{label:"",data:""}
	]
);

/**
 * 函数名称：ini
 * 函数说明：页面初始化操作，树菜单、数据字典列表、按钮初始化操作
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
protected function ini():void{
	//树菜单
	iniTreeMenu();
	
}


/**
 * 函数名称：iniTreeMenu
 * 函数说明：树菜单初始化
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
protected function iniTreeMenu():void{
	var objvalue:Object = new Object();
	objvalue.sqlcondition = " bquery=1";
	AccessUtil.remoteCallJava("DatadictionaryDest","getTreeMenuList",onGetTreeMenuListBack,objvalue);
}
private function onGetTreeMenuListBack(evt:ResultEvent):void{
	treeXml = evt.result as String;
	
}

/**
 * 函数名称：rownum_DataGrid
 * 函数说明：DataGrid序号
 * 函数参数：KeyboardEvent，前台无需传入参数
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
public function rownum_DataGrid(objitem:Object,icol:int):String{
	var iindex:int=arrDataList.getItemIndex(objitem)+1;
	return String(iindex);
}

public function convertType(item:Object,column:DataGridColumn):String{
	var itemlabel:String = item.ifieldtype+"";
	
	switch(itemlabel){
		case "0":
			return "字符";
			break;
		case "1":
			return "整数";
			break;
		case "2":
			return "浮点数";
			break;
		case "3":
			return "日期";
			break;
		case "4":
			return "布尔";
			break;
		case "5":
			return "图片";
			break;
		default:
			break;
	}
	return "";
}

public function convertIcmType(item:Object,column:DataGridColumn):String{
	var itemlabel:String = item.icmtype+"";
	
	switch(itemlabel){	
		case "0":
			return "单项";
			break;
		case "1":
			return "区间";
			break;
		case "2":
			return "多选";
			break;
		case "3":
			return "是否BIT型";
			break;
		default:
			break;
	}
	return "";
}

public function convertIstType(item:Object,column:DataGridColumn):String{
	var itemlabel:String = item.isttype+"";
	
	switch(itemlabel){	
		case "0":
			return "无序";
			break;
		case "1":
			return "升序";
			break;
		case "2":
			return "降序";
			break;
		default:
			break;
	}
	return "";
}



/**
 * 函数名称：treeMenu_itemClickHandler
 * 函数说明：树菜单的点击事件
 * 函数参数：event:ListEvent
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
protected function treeMenu_itemClickHandler(event:ListEvent):void
{
	if(treeMenu.selectedItem.@ctable != ""){
		asacquaryclmvo.ifuncregedit = treeMenu.selectedItem.@iid;
		inidata();
	}else {
		asacquaryclmvo.ifuncregedit = treeMenu.selectedItem.@iid;
		inidata();
	}
}

protected function inidata():void{
	AccessUtil.remoteCallJava("ACqueryclmDest","getAcQueryclmList",onGetAcQueryclmListBack,asacquaryclmvo.ifuncregedit);
}

private function onGetAcQueryclmListBack(evt:ResultEvent):void{
	arrDataList = evt.result as ArrayCollection;
}


/**
 * 函数名称：btn_menubar_itemClickHandler
 * 函数说明：菜单按钮事件
 * 函数参数：event:ItemClickEvent
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
protected function btn_menubar_itemClickHandler(event:ItemClickEvent):void
{
	var enabled:Boolean;
	if(event.item.name != "onSave") operType = event.item.name;
	
	switch(event.item.name){
		case "onNew":
			onNew();
			break;
		case "onEdit":
			onEdit();
			break;
		case "onDelete":
			onDelete();
			break;
		case "onSave":	
			if(emptyDataHadle())
				onSave();
			else
				Alert.show("false");
			break;
		case "onGiveUp":
			onGiveUp();
			break;
		default:
			break
	}
	
	//按钮互斥
	CRMtool.toolButtonsEnabled(btn_menubar,event.item.name)
}

/**
 * 函数名称：onNew
 * 函数说明：新增数据时的操作
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onNew():void{
	//新增行
	for(var i:int=0;i<10;i++){
		var obj:Object = new Object();
		obj.bcommon = 0;
		obj.bunnull = true;
		obj.bconsultendbk = 0;
		arrDataList.addItem(obj);
	}
	
	this.myenabled = true;
	dglist.selectedIndex = arrDataList.toArray().length-10;
	dglist.addEventListener(KeyboardEvent.KEY_DOWN,CRMtool.doKeyDown);//调用回车事件
}

private function onEdit():void{
	this.myenabled = true;
	dglist.addEventListener(KeyboardEvent.KEY_DOWN,CRMtool.doKeyDown);//调用回车事件
}

/**
 * 函数名称：onBeforeSave
 * 函数说明：保存之前操作处理(移除空白记录)
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110821
 * 修改日期：
 *	
 */
private function emptyDataHadle():Boolean{
	var rflag:Boolean = true;
	try
	{
		for(var i:int=0;i<this.arrDataList.length;i++){
			if(arrDataList.getItemAt(i).cfield == null || mx.utils.StringUtil.trim(this.arrDataList.getItemAt(i).cfield) == ""){
				arrDataList.removeItemAt(i);
				i--;
			}
			
		}
	}
	catch(e:Error){
		rflag = false;
	}
	return rflag;
}


/**
 * 函数名称：onSave
 * 函数说明：数据保存操作
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onSave():void{
	
	if(operType == "onEdit"){}
	
	var objvalue:Object = new Object();
	objvalue.ifuncregedit = asacquaryclmvo.ifuncregedit;//注册程序内码
	objvalue.datalist = arrDataList;					//数据集
	if(operType =="onNew")
		AccessUtil.remoteCallJava("ACqueryclmDest","addAcqueryclm",onAddAcqueryclmBack,objvalue);
	if(operType == "onEdit")
		AccessUtil.remoteCallJava("ACqueryclmDest","updateAcqueryclmData",onAddAcqueryclmBack,objvalue);
	
}


/**
 * 函数名称：onAddAcqueryclmBack
 * 函数说明：保存事件后处理
 * 函数参数：event:ListEvent
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onAddAcqueryclmBack(evt:ResultEvent):void{
	Alert.show(evt.result as String);
	afterSave();
}

/**
 * 函数名称：afterSave
 * 函数说明: 数据保存后的处理(不可编辑)
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function afterSave():void{
	this.myenabled = false;
}


/**
 * 函数名称：onGiveUp
 * 函数说明: 放弃按钮的处理(不可编辑、清空空白数据)
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onGiveUp():void{
	emptyDataHadle();
	dglist.selectedIndex=0;//焦点移动
	this.myenabled = false;
	this.inidata();
}


/**
 * 函数名称：onDelete
 * 函数说明: 删除处理(删除当前记录)
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onDelete():void{
	if(dglist.selectedIndex ==-1){Alert.show("请选择删除记录！");return;}
	var iid:int = this.arrDataList.getItemAt(dglist.selectedIndex).iid;
	this.arrDataList.removeItemAt(dglist.selectedIndex);
	AccessUtil.remoteCallJava("ACqueryclmDest","deleteAcqueryclm",onDelAcqueryclmBack,iid);
}


/**
 * 函数名称：onDelAcqueryclmBack
 * 函数说明：删除事件后处理
 * 函数参数：event:ListEvent
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onDelAcqueryclmBack(evt:ResultEvent):void{
	Alert.show(evt.result as String);	
}


private function validateItem(event:DataGridEvent):void    {
	
	if (event.reason == DataGridEventReason.CANCELLED){
		return;
	}
	
/*	if(event.dataField == "iconsult" ){
		var cinput:CrmEapTextInput=CrmEapTextInput(dglist.itemEditorInstance);
		var cnewData:String=CrmEapTextInput(event.currentTarget.itemEditorInstance).text;
		//验证必须为数字
		if (isNaN(Number(StringUtil.trim(cnewData)))){
			event.preventDefault();
			cinput.errorString="应输入数字！";
			return;
		}
	}*/
	
	if(event.dataField == "iqryno" || event.dataField == "isortno"){
		var input:TextInput=TextInput(dglist.itemEditorInstance);
		var newData:String=TextInput(event.currentTarget.itemEditorInstance).text;
		//验证必须为数字
		if (isNaN(Number(StringUtil.trim(newData)))){
			event.preventDefault();
			input.errorString="应输入数字！";
			return;
		}
	}
}

