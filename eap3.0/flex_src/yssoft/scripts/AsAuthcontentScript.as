/**
 * 模块说明：权限目录定制相关业务操作
 * 创建人：YJ
 * 创建日期：20110905
 * 修改人：
 * 修改日期：
 *
 */
import flash.events.KeyboardEvent;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.Menu;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.events.MenuEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.XMLUtil;

import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

[Bindable]protected var arrDataList:ArrayCollection = new ArrayCollection();	//数据集
[Bindable]public var operType:String;
[Bindable]protected var treeXml:String;
[Bindable]public var myenabled:Boolean=false;
[Bindable]
protected var menubar:ArrayCollection = new ArrayCollection(
		[
		 {label:"写入",name:"onUpdate"},
		 {label:"修改",name:"onEdit"},		
		 {label:"保存",name:"onSave"},
		 {label:"放弃",name:"onGiveUp"}]);

[Bindable] public var menu:Menu = new Menu();

[Bindable]
private var menuData:ArrayCollection = new ArrayCollection([
	{label:"查询全部",		name:"queryall"	},
	{label:"数据导出",		name:"onExcelExport"	}
]);

/**
 * 函数名称：ini
 * 函数说明：功能注册表初始化相关业务操作，主要是初始化树菜单
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110810 
 * 修改日期：
 *	
 */
protected function ini():void{
	AccessUtil.remoteCallJava("AuthcontentDest","getTreeMenuList",onGetMenuListBack);
}

private function onGetMenuListBack(evt:ResultEvent):void{
	//菜单赋值 
	treeXml = evt.result as String;
	
	//add by zhong_jing 加入导出功能
	menu.dataProvider = this.menuData;
	menu.variableRowHeight = true;
	menu.addEventListener(MenuEvent.CHANGE,onClick);
	this.ppb.popUp = menu;
}


//加入导出功能
private function onClick(event:MenuEvent):void
{
	if(event.item.name=="onExcelExport"){
		//YJ Add 
		/*
		YJ Add 列表数据导出至Excel
		前台传入参数说明：arr(数据集)，
		columnArr(列数据集，包括字段、字段标题)
		title(Excel标题)，
		flag(Excel是否显示序号,0--显示，1--不显示)
		
		*/
		
		if(this.arrDataList.length ==0){CRMtool.tipAlert("请选择要导出的记录！！");return;}
		var objvalue:Object = {};
		var title:String = "数据权限";
		var columnArr:ArrayCollection=new ArrayCollection();//记录字段名称和标题的记录集
		
		
		var newresultArr:ArrayCollection=new ArrayCollection();
		for each(var resultObj:Object in this.arrDataList)
		{
			switch(resultObj.buse)
			{
				case true:
				{
					resultObj.buse="是";
					break;
				}
				case false:
				{
					resultObj.buse="否";
					break;
				}	
			}
			
			newresultArr.addItem(resultObj);
		}
		objvalue.arr =newresultArr;//数据集
		
		objvalue.title = "数据权限";//标题
		objvalue.flag = 0;//是否显示序号
		
		columnArr.addItem({"cfld":"buse","cfldcaption":"是否启用","width":200});
		columnArr.addItem({"cfld":"ccode","cfldcaption":"权限编码","width":200});
		columnArr.addItem({"cfld":"cname","cfldcaption":"权限默认内容","width":200});
		columnArr.addItem({"cfld":"ccaption","cfldcaption":"权限标题","width":200});
		columnArr.addItem({"cfld":"cfunction","cfldcaption":"权限功能","width":200});
		columnArr.addItem({"cfld":"cform","cfldcaption":"权限窗体","width":200});
		columnArr.addItem({"cfld":"cmemo","cfldcaption":"备注","width":200});
		objvalue.fieldsList=columnArr;
		
		AccessUtil.remoteCallJava("ExcelHadleDest","writeExcel",onWriteExcelBack,objvalue);//调用后台的导出方法
	}
	else if(event.item.name=="queryall"){
		var param:Object = new Object();
		AccessUtil.remoteCallJava("AuthcontentDest","getDataList",onGetDataListBack,param);
	}
}

//YJ Add 数据导出后的操作
private function onWriteExcelBack(evt:ResultEvent):void{
	var filename:String = "";			
	if(evt.result.hasOwnProperty("filename")){
		filename = evt.result.filename as String;
	}
	var requestUrl:String ="/"+ConstsModel.publishAppName+"/excelExportServlet?fn="+filename;
	var request: URLRequest = new URLRequest(requestUrl);
	navigateToURL(request, "_blank");
}

/**
 * 函数名称：treeMenu_itemClickHandler
 * 函数说明：树菜单的点击事件，获取选中节点的功能列表
 * 函数参数：event
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
protected function treeMenu_itemClickHandler(event:ListEvent):void
{
	//初始化按钮互斥
	CRMtool.toolButtonsEnabled(btn_menubar,null);
	myenabled = false;	
	// wtf modify
//	if(this.treeMenu.selectedItem.@ctable != ""){
//	var xml:XML = this.treeMenu.treeCompsXml;
	var obj: Object = this.treeMenu.selectedItem;
	var xml:XML = new XML(obj+"");
	var i:int = xml.children().length();

	if(i==0){
		iniDataList(this.treeMenu.selectedItem.@iid);
	}
		
//	}
}

/**
 * 函数名称：iniDataColumn
 * 函数说明：初始化数据列中文标题信息
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
protected function iniDataList(ifuncregedit:int):void{	
	var param:Object = new Object();
	param.ifuncregedit = ifuncregedit;
	AccessUtil.remoteCallJava("AuthcontentDest","getDataList",onGetDataListBack,param);
}

private function onGetDataListBack(evt:ResultEvent):void{
	arrDataList = evt.result as ArrayCollection;
	this.dglist.dataProvider = arrDataList;
}

protected function btn_menubar_itemClickHandler(event:ItemClickEvent):void
{
	var enabled:Boolean;
	if(event.item.name != "onSave") operType = event.item.name;
	
	switch(event.item.name){
		case "onUpdate":				
			onUpdate();
			break;
		case "onEdit":
			if(!onBeforeEdit())return;
			onEdit();
			break;
		case "onSave":
			onSave();
			break;
		case "onGiveUp":
			onGiveUp();
			break;
		default:
			break;
	}
	
	//按钮互斥
	CRMtool.toolButtonsEnabled(this.btn_menubar,event.item.name)
}

/**
 * 函数名称：rownum_DataGrid
 * 函数说明：DataGrid序号
 * 函数参数：
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


/**
 * 函数名称：onBeforeEdit
 * 函数说明：编辑操作之前的操作
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
private function onBeforeEdit():Boolean{
	if(this.treeMenu.selectedIndex == -1 || this.treeMenu.selectedItem.@ctable == ""){CRMtool.showAlert(ConstsModel.MENU_CHOOSE); return false;}
	if(arrDataList.length == 0){CRMtool.showAlert(ConstsModel.DATAGRID_DATANULL);return false;}
	return true;
}

/**
 * 函数名称：onEdit
 * 函数说明：编辑操作
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
private function onEdit():void{
	this.myenabled = true;
	this.dglist.addEventListener(KeyboardEvent.KEY_DOWN,CRMtool.doKeyDown);//调用回车事件
}

private function onGiveUp():void{
	this.myenabled = false;
	iniDataList(this.treeMenu.selectedItem.@iid);
}

/**
 * 函数名称：onSave
 * 函数说明：保存操作
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110815 
 * 修改日期：
 *	
 */
private function onSave():void{
	var datalist:ArrayCollection = new ArrayCollection();
	var objvalue:Object = new Object();
	
	datalist  = this.arrDataList as ArrayCollection;
	objvalue.datalist = datalist;
	
	AccessUtil.remoteCallJava("AuthcontentDest","saveAsAuthcontent",onSaveAsAuthcontentBack,objvalue);
}


private function onSaveAsAuthcontentBack(evt:ResultEvent):void{
	
	onGiveUp();
	
}

/**
 * 函数名称：onUpdate
 * 函数说明：写入权限设置操作
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20111006 
 * 修改日期：
 *	
 */
private function onUpdate():void{
	AccessUtil.remoteCallJava("AuthcontentDest","updateAsAuthcontent",onUpdateAsAuthcontentBack);
}

private function onUpdateAsAuthcontentBack(evt:ResultEvent):void{
	Alert.show(evt.result as String);
}

