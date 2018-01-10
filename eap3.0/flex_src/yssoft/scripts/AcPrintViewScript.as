/**
 * 模块说明：打印设置相关业务操作
 * 创建人：YJ
 * 创建日期：2011-10-19
 * 修改人：
 * 修改日期：
 *
 */
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.utils.describeType;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Application;
import mx.events.DataGridEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.events.Request;
import mx.messaging.channels.StreamingAMFChannel;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLEncoder;
import mx.utils.StringUtil;
import mx.utils.URLUtil;

import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.printreport.PrintParam;
import yssoft.views.sysmanage.FuncregeditView;
import yssoft.vos.AcPrintSetVO;

[Bindable]
public var ifieldtypeArr:ArrayCollection=new ArrayCollection();
[Bindable]
public var dgData:Object=new Object();
[Bindable]
public var printsets:ArrayCollection=null;
[Bindable]
public var printclm:ArrayCollection=null;
[Bindable]public var typeindex:int;//模板类型
[Bindable]public var myenabled:Boolean;//是否可以编辑
[Bindable]protected var listArr:ArrayCollection = null;
[Bindable]protected var acprintsetvoArr:ArrayCollection = new ArrayCollection();//能够批量修改模板参数
[Bindable]protected var countNum:int = 0;//控制sql配置和字段信息的保存次数
[Bindable]protected var instanceInfo:XML=null;
[Bindable]protected var properties:XMLList=null;
[Bindable]public var operType:String;
[Bindable]protected var treeCompsXml:XML;
[Bindable]protected var acprintsetvo:AcPrintSetVO = new AcPrintSetVO();
[Bindable]private var curRowNum:int=-1;
[Bindable]public var fileReference:FileReference;//文件
[Bindable]
protected var arr_menubar:ArrayCollection = new ArrayCollection(
	[
		{label:"增加",name:"onNew"},
		{label:"修改",name:"onEdit"},
		{label:"删除",name:"onDelete"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"},
		{label:"更新",name:"onRefresh"}
	]);
[Bindable]
public var arr_itype:ArrayCollection = new ArrayCollection(
	[
		{label:"卡片打印",value:"1"},
		{label:"列表打印",value:"2"}
	]
);
//原始字段信息集
[Bindable]
public var fileName:String = "";

private var oldsqlfields:ArrayCollection=new ArrayCollection();
[Bindable]public var ifuncregedit:int;//选中节点的注册内码
private var reportpnvalues:ArrayCollection;//当前打印模板参数及赋值

private var isNull:Boolean=false;

//获得字段类型
public function getIfieldtypeLabel(item:Object,icol:int):String
{
	/*var obj:Object=this.ifieldtypeArr.getItemAt(item.ifieldtype);*/
	var obj:Object;
	for(var i:int=0;i<this.ifieldtypeArr.length;i++)
	{
		var ifieldObj:Object = ifieldtypeArr.getItemAt(i);
		if(ifieldObj.iid==item.ifieldtype)
		{
			obj=ifieldObj;
			break;
		}
	}
	if(obj==null)
	{
		return "";
	}
	return obj.cname;
}

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
	this.addEventListener("getReportParamValuesCompleted",getReportParamValuesCompleted);
	AccessUtil.remoteCallJava("AcPrintSetDest","getMenuList",onGetMenuListBack);
	AccessUtil.remoteCallJava("ConsultDest","getDataType",getDataType_callBackHandler); 
}
public function getDataType_callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		this.ifieldtypeArr=event.result.success as ArrayCollection;		
	}
	else
	{
		this.ifieldtypeArr=null;
	}
}

private function onGetMenuListBack(evt:ResultEvent):void{
	//菜单赋值 
	if(evt.result.treeXml != null)
		treeMenu.treeCompsXml = new XML(evt.result.treeXml as String);
	
}

/**
 * 函数名称：treeMenu_itemClickHandler
 * 函数说明：树菜单点击事件处理
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：2011020 
 * 修改日期：
 *	
 */
protected function treeMenu_itemClickHandler():void
{
	var condition:String = "";//传入的条件
	
	ifuncregedit = treeMenu.selectedItem.@iid;//选中节点的注册内码
	this.oldsqlfields.removeAll();
	if (this.printsets!=null && this.printsets.length>0)
	{
		for each (var sqlitem:Object in printsets) 
		{
			var sqlfields:ArrayCollection=(sqlitem.sqlfields as ArrayCollection);
			if (sqlfields!=null && sqlfields.length>0)
			{
				sqlfields.removeAll();
			}
		}
		this.printsets.removeAll();
	}
	if (this.printclm!=null && this.printclm.length>0)
	{
		this.printclm.removeAll();
	}
	this.myenabled=false;
	CRMtool.toolButtonsEnabled(btn_menubar,null);
	if(treeMenu.selectedItem.@ipid==-1) return;
	//	if(treeMenu.selectedItem.@ipid==-1){//父节点查询所有子节点的信息
	//	 	condition = " ac_printset.ifuncregedit in(select iid from as_funcregedit where ipid="+ifuncregedit+")";
	//	}
	//	else
	//condition = ifuncregedit;
	
	AccessUtil.remoteCallJava("AcPrintSetDest","getDataByIfuncregedit",onGetDataByIfuncregeditBack,ifuncregedit,null,false);
	
}

private function onGetDataByIfuncregeditBack(evt:ResultEvent):void{
	listArr = new ArrayCollection();
	if (evt.result)
	{
		listArr = evt.result as ArrayCollection;
	}
	
	this.dglist.dataProvider = listArr;
	if (listArr.length>0)
	{
		this.dglist.setFocus();
		this.dglist.selectedIndex=0;
	}
	dglist_changeHandler();
}
/**
 *
 * 函数名：btn_menubar_itemClickHandler
 * 作者：YJ
 * 日期：2011-08-04
 * 功能：工具栏按钮点击事件处理
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function btn_menubar_itemClickHandler(event:ItemClickEvent):void
{
	var node:Object=this.treeMenu.selectedItem;
	
	switch(event.item.name)
	{
		case "onNew":
			if(!(onNewBefore())) return;
			onNew();
			operType=event.item.name;
			treeMenu.enabled = false;
			break;
		case "onEdit":	
			if(!onEdit())return;
			operType=event.item.name;
			treeMenu.enabled = false;
			this.curRowNum = this.dglist.selectedIndex;
			break;
		case "onDelete":
			if(onBeforeDelete()){
				onDelete();
			}
			break;
		case "onSave":
			if (onBeforeSave())
			{
				onSave();
				myenabled = false;
				treeMenu.enabled = true;
			}
			break;			
		case "onGiveUp":	{treeMenu.enabled = true;myenabled =false;operType=event.item.name;onGiveUp();break;}
		case "onRefresh":	{onRefresh();break;}
		default:
			break;
	}
	
	//调用按钮互斥
	CRMtool.toolButtonsEnabled(btn_menubar,event.item.name)
}

//LL 更新字段信息
private function onRefresh():void
{
	for each (var item:Object in this.dgrd_printsets.dataProvider) 
	{
		if (item.iid==null || item.iid==0)
		{
			CRMtool.showAlert("请先保存SQL设置后，再执行更新操作。");
			return;
		}
	}
	
	if (this.dgrd_printsets.selectedItem==null)
	{
		CRMtool.showAlert("请先选择SQL配置行。");
		return;
	}
	getReportParamValues();
}
private function getReportParamValuesCompleted(evt:Event):void
{
	var csql:String=this.dgrd_printsets.selectedItem.csql;
	for each (var item:Object in this.reportpnvalues) 
	{
		csql=csql.replace(item.name,item.value);
	}
	AccessUtil.remoteCallJava("ConsultDest","getDAODataType",onRefresh_callBackHandler,csql);	
}
private function onRefresh_callBackHandler(event:ResultEvent):void
{
	if (event.result.hasOwnProperty("success"))
	{
		if (this.printclm==null)
		{
			this.printclm=new ArrayCollection();
		}
		var newclmfields:ArrayCollection=new ArrayCollection();
		var arrtmp:ArrayCollection=event.result.success as ArrayCollection;
		if (arrtmp.length==0)
		{
			CRMtool.showAlert(ConstsModel.CONSULT_NULLSTATEERR);
			return;
		}
		var item:Object;
		for (var i:int = 0; i < arrtmp.length; i++) 
		{
			item=new Object();
			item.ino=i+1;
			var cfield:String=arrtmp[i].fieldname;
			var type:String=arrtmp[i].fieldtype;
			item.ifieldtype= CRMtool.GetDataTypeIid(type);
			item.cfield=cfield;
			var iid:String=this.dgrd_printsets.selectedItem.iid;
			item.iprints=iid;
			item.buse=1;
			item.ccaption=cfield;
			item.cnewcaption=cfield;
			newclmfields.addItem(item);
		}
		if (this.printclm.length>0)
		{
			CRMtool.dosqlfields(this.printclm,newclmfields);
		}
		else
		{
			this.dgrd_printclm.dataProvider=newclmfields;
			this.printclm=newclmfields;
		}
		updatesqlfields();

        isNull = false;
	}
	else
	{
		CRMtool.showAlert(String(event.result.exception));
	}
}

private function onNewBefore():Boolean{
	if(treeMenu.selectedItem == null){CRMtool.showAlert(ConstsModel.MENU_CHOOSE);return false;}
	if(treeMenu.selectedItem.@ipid==-1){CRMtool.tipAlert("父节点不能添加打印设置！");return false;}
	return true;
}

/**
 * 函数名称：onNew
 * 函数说明：新增一条空记录
 * 函数参数：无
 * 函数返回：Boolean
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 *	
 */
private function onNew():void{
	for(var i:int=0;i<1;i++){
		
		var obj:Object = {};
		typeindex = 0;
		obj.ifuncregedit = this.treeMenu.selectedItem.@iid;
		obj.fcname = this.treeMenu.selectedItem.@cname;
		//obj.itype = "列表打印";
		obj.buse=0;
		obj.bdefault = 0;
		obj.ctemplate = null;
		listArr.addItem(obj);
	}
	curRowNum = listArr.length-1;
	this.myenabled = true;
	dglist.selectedIndex = listArr.toArray().length;
	dglist.addEventListener(KeyboardEvent.KEY_DOWN,CRMtool.doKeyDown);//调用回车事件
}

/**
 * 函数名称：onEdit
 * 函数说明：修改前的验证
 * 函数参数：无
 * 函数返回：Boolean
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 *	
 */
private function onEdit():Boolean{
	if(treeMenu.selectedItem == null){CRMtool.showAlert(ConstsModel.MENU_CHOOSE); return false;}
	if(dglist.selectedIndex == -1){CRMtool.showAlert("请选择需要修改的记录！"); return false;}
	this.myenabled = true;
	return true;
}

/**
 * 函数名称：onSave
 * 函数说明：保存数据
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 *	
 */

public function onSave():void{
	if(operType=="onNew"){//增加操作
		AccessUtil.remoteCallJava("AcPrintSetDest","addAcPrintSet",onHandleBack,this.acprintsetvo);
	}
	else{//更新操作
		//AccessUtil.remoteCallJava("AcPrintSetDest","updateAcPrintSet",onHandleBack,this.acprintsetvo);	
		countNum = 0;
		for each(var o:Object in this.acprintsetvoArr) {
			var acp:AcPrintSetVO = new AcPrintSetVO();
			acp.iid                 = o.iid;
			acp.ifuncregedit = 	treeMenu.selectedItem.@iid;
			acp.cname 		    = 	o.cname;
			acp.ctemplate 	= 	o.ctemplate;
			acp.ccondit 		= 	o.ccondit;
			acp.itype 		    = 	o.itype;
			acp.buse 			    = 	o.buse==true?1:0;
			acp.bdefault 		= 	o.bdefault==true?1:0;
			acp.cmemo 		= 	o.cmemo;
			AccessUtil.remoteCallJava("AcPrintSetDest","updateAcPrintSet",onHandleBack,acp);
		}
	}
}

private function onGiveUp():void{
	emptyDataHadle();
	dglist_changeHandler();
	this.myenabled = false;
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
		for(var i:int=0;i<this.listArr.length;i++){
			if(listArr.getItemAt(i).iid == null){
				listArr.removeItemAt(i);
				i--;
			}
			
		}
	}
	catch(e:Error){
		rflag = false;
	}
	return rflag;
}

private function onHandleBack(evt:ResultEvent):void{
	if(operType == "onNew"){
		var obj:Object = dglist.selectedItem;
		obj.iid  = evt.result;
	}
	
	if(evt.result.toString()=="fail"){
	}
	else{
		//onUploadFile();
		updateTreeItem();
	}
	if(countNum<1) {
		savePrintsets();
		countNum ++;
	}
}
//LL 保存SQL设置
private function savePrintsets():void
{
	var operData:Object=new Object();
	operData.deletedata=this.dataGridOperRow.delData;
	var updatedata:ArrayCollection=new ArrayCollection();
	var insertdata:ArrayCollection=new ArrayCollection();
	for each (var item:Object in this.printsets) 
	{
		if (item.iid!=null && item.iid!=0)
		{
			updatedata.addItem(item);		
		}
		else
		{
			if (item.csql!=null)
			{
				item["iprint"]=dglist.selectedItem.iid;
				insertdata.addItem(item);
			}
		}
	}
	operData.updatedata=updatedata;
	operData.insertdata=insertdata;
	AccessUtil.remoteCallJava("AcPrintSetDest","oper_printsets",on_oper_printsets,operData,null,false);
}
private function on_oper_printsets(evt:ResultEvent):void
{
	if (evt.result.toString()=="fail")
	{
		CRMtool.showAlert("SQL配置保存失败！");
	}
	else
	{
		savePrintclm();
	}
}
//LL 保存字段信息
private function savePrintclm():void
{
	var operData:Object=new Object();
	var deletedata:ArrayCollection=new ArrayCollection();
	var updatedata:ArrayCollection=new ArrayCollection();
	var insertdata:ArrayCollection=new ArrayCollection();
	
	var newsqlfields:ArrayCollection=new ArrayCollection();
	
	if(isNull)
	{
		deletedata.addAll(oldsqlfields);
		oldsqlfields.removeAll();
	}
	for each (var sqlitem:Object in this.printsets) 
	{
		if (sqlitem.sqlfields!=null)
		{
			newsqlfields.addAll(sqlitem.sqlfields);
		}
	}
	
	for each (var oldfield:Object in this.oldsqlfields) 
	{
		for (var i:int = 0; i < newsqlfields.length; i++) 
		{
			if (oldfield.cfield==newsqlfields[i].cfield && oldfield.iprints==newsqlfields[i].iprints)
			{
				break;
			}	
		}	
		if (i==newsqlfields.length)
		{
			deletedata.addItem(oldfield);		
		}
	}
	
	for each (var newfield2:Object in newsqlfields) 
	{
		if (newfield2.iid!=null && newfield2.iid!=0)
		{
			updatedata.addItem(newfield2);		
		}
		else
		{
			if (newfield2.cfield!=null)
			{
				insertdata.addItem(newfield2);
			}
		}
	}
	operData.updatedata=updatedata;
	operData.insertdata=insertdata;
	operData.deletedata=deletedata;
	AccessUtil.remoteCallJava("AcPrintSetDest","oper_printclm",on_oper_printclm,operData);
}
private function on_oper_printclm(evt:ResultEvent):void
{
	if (evt.result.toString()=="fail")
	{
		CRMtool.showAlert("字段信息保存失败！");
	}
	else
	{
		treeMenu_itemClickHandler();
	}
}
//上传文件
public function onUploadFile():void{
	
	var request:URLRequest = new URLRequest("/"+ConstsModel.publishAppName+"/FileUploadServlet?fileName="+ifuncregedit+"_"+(dglist.selectedIndex+1)+".xml");
	if(fileReference == null) return;
	fileName=ifuncregedit+"_"+(dglist.selectedIndex+1)+".xml"
	this.fileReference.upload(request);
	
}

//操作完成后更新树的相关信息
private function updateTreeItem():void{
	
}

/**
 * 函数名称：setFuncregeditVO
 * 函数说明：给VO赋值
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
public function setFuncregeditVO():void{
	
	this.acprintsetvoArr.removeAll();
	for(var i:int=0; i<this.listArr.length; i++) {
		//var obj:Object = this.listArr.getItemAt(dglist.selectedIndex);
		var obj:Object = this.listArr.getItemAt(i);
		if(operType=="onEdit"){
			this.acprintsetvo.iid = obj.iid;
		}
		
		this.acprintsetvo.ifuncregedit = 	treeMenu.selectedItem.@iid;
		this.acprintsetvo.cname 		= 	obj.cname;
		this.acprintsetvo.ctemplate 	= 	obj.ctemplate;
		this.acprintsetvo.ccondit 		= 	obj.ccondit;
		//this.acprintsetvo.itype 		= 	obj.itype=="卡片打印"?1:2;
		this.acprintsetvo.itype 		    = 	obj.itype;
		this.acprintsetvo.buse 			= 	obj.buse==true?1:0;
		this.acprintsetvo.bdefault 		= 	obj.bdefault==true?1:0;
		this.acprintsetvo.cmemo 		= 	obj.cmemo;
		
		this.acprintsetvoArr.addItem(this.listArr[i]);
	}
}

/**
 * 函数名称：onBeforeSave
 * 函数说明：数据保存前检验数据
 * 函数参数：无
 * 函数返回：Boolean
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 *	
 */
private function onBeforeSave():Boolean{
	
	setFuncregeditVO();
	
	return true;
}

/**
 * 函数名称：onClick
 * 函数说明：选择文件的操作
 * 函数参数：无
 * 函数返回：Boolean
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：2011020
 * 修改日期：
 *	
 */
private function onClick():void{
	
}

public function dglist_itemEditBeginHandler(event:DataGridEvent):void
{
	//	var len:int=this.dglist.dataProvider.length;
	//	if (operType=="onNew"){
	//		if (dglist.selectedIndex!=curRowNum){
	//			dglist.editedItemPosition = null;
	//			this.myenabled = false;
	//		}
	//		else
	//			this.myenabled = true;
	//	}else if(operType=="edit"){
	////		if(oldRowNum!=curRowNum){
	////			return;
	////		}else{
	////			if(MyDataGrid.selectedIndex!=curRowNum)
	////				MyDataGrid.editedItemPosition = null;
	////		}
	//	}else{
	//		dglist.editedItemPosition = null;
	//	}
	
}

public function dglist_itemFocusInHandler(event:DataGridEvent):void
{
	//	if(event.rowIndex != curRowNum)
	//		this.myenabled = false;
	//	if (event.rowIndex!=curRowNum && (dgState=="edit"||dgState=="add")){
	//		UtilsCollection.create3BtAlert("是否保存当前的修改？","提示",focusBack,null);	
	//	}
	
}

//YJ Add 删除之前操作
private function onBeforeDelete():Boolean{
	if(dglist.selectedIndex ==-1){CRMtool.tipAlert("请选择需要删除的记录！");return false;}
	
	return true;
}

//YJ Add 删除操作
private function onDelete():void{
	
	var iid:int = dglist.selectedItem.iid; //获取需要删除的记录内码
	this.curRowNum = dglist.selectedIndex;
	CRMtool.tipAlert1("确定要删除该记录吗?",null,"AFFIRM",function():void{
		AccessUtil.remoteCallJava("AcPrintSetDest","deleteAcPrintSet",onDeleteAcPrintSetBack,iid);
	});
	
}

//YJ Add 删除后的操作
private function onDeleteAcPrintSetBack(evt:ResultEvent):void{
	if(evt.result != "fail"){
		(this.dglist.dataProvider as ArrayCollection).removeItemAt(curRowNum);
		(this.dgrd_printclm.dataProvider as ArrayCollection).removeAll();
		(this.dgrd_printsets.dataProvider as ArrayCollection).removeAll();
		
		var arr:ArrayCollection = this.dglist.dataProvider as ArrayCollection;
		if(arr.length>0)
		{
			dglist.selectedIndex=0;
			dglist_changeHandler();
		}
	}
}

//LL 联查SQL配置
protected function dglist_changeHandler():void
{
	if (dglist.selectedItem)
	{
		this.oldsqlfields.removeAll();
		var condition:String="iprint="+dglist.selectedItem.iid;
		AccessUtil.remoteCallJava("AcPrintSetDest","get_sql_byprintsets",onget_sql_byprintsets,condition,null,false);
	}
	else
	{
		(this.dgrd_printclm.dataProvider as ArrayCollection).removeAll();
	}
}
public function onget_sql_byprintsets(evt:ResultEvent):void
{
	this.dataGridOperRow.Init();
	printsets=evt.result as ArrayCollection;
	dgData.dataProvider=printsets;	
	this.dataGridOperRow.data=dgData;
	this.dataGridOperRow.addNewItem=dgrd_addNewItem;
	var condition:String="iprints in (select iid from ac_printsets where iprint="+this.dglist.selectedItem.iid+")";
	AccessUtil.remoteCallJava("AcPrintSetDest","get_bywhere_ac_printclm",onget_bywhere_ac_printclm,condition,null,false);
}
private function onget_bywhere_ac_printclm(evt:ResultEvent):void
{
	var arr:ArrayCollection=evt.result as ArrayCollection;
	for each (var sqlitem:Object in printsets) 
	{
		sqlitem.sqlfields=new ArrayCollection();
		for each (var itemfields:Object in arr) 
		{
			if (sqlitem.iid==itemfields.iprints)
			{
				(sqlitem.sqlfields as ArrayCollection).addItem(itemfields);
			}
		}
	}
	if (arr)
	{
		this.dgrd_printsets.selectedIndex=0;
		dgrd_printsets_changeHandler();
		this.dgrd_printsets.selectedIndex=0;
		if(dgrd_printsets.selectedItem)
		{
		    getSelectFields(int(dgrd_printsets.selectedItem.iid));
		}
		/*this.dgrd_printclm.dataProvider=arr;*/
		//this.oldsqlfields=new ArrayCollection(CRMtool.ObjectCopy(arr.toArray()));
	}
}
public function getSelectFields(iid:int):void
{
	for each (var sqlitem:Object in printsets) 
	{
		if (sqlitem.iid==iid)
		{
			this.printclm=sqlitem.sqlfields;
			this.oldsqlfields.removeAll();
			this.oldsqlfields = new ArrayCollection(CRMtool.ObjectCopy(printclm.toArray()));
			for (var i:int = 0; i < this.printclm.length; i++) 
			{
				this.printclm[i].ino=i+1;			     
			}
			break;
		}
	}
}
public function dgrd_addNewItem():void
{
	var item:Object=new Object();
	item.iid=null;
	item.iprint=null;
	item.bhead=0;
	item.csql=null;
    if(printsets==null)
        printsets = new ArrayCollection();

	printsets.addItem(item);
}
protected function dgrd_printsets_changeHandler():void
{
	dgData.selectedItem=this.dgrd_printsets.selectedItem;
	if (dgData.selectedItem)
	{
		getSelectFields(dgData.selectedItem.iid);
	}else{
		//避免空指针错误
		if(printclm && printclm.length>0) {
			printclm.removeAll();
		}
	}
}

private function updatesqlfields():void
{
	if (dgData.selectedItem)
	{
		for each (var sqlitem:Object in this.printsets) 
		{
			if (sqlitem.iid==dgData.selectedItem.iid)
			{
				for (var i:int = 0; i < this.printclm.length; i++) 
				{
					this.printclm[i].ino=i+1;
				}
				if (this.printclm.length>0)
				{
					sqlitem.sqlfields=new ArrayCollection(CRMtool.ObjectCopy(this.printclm.toArray()));
				}
				else
				{
					sqlitem.sqlfields=this.printclm;
				}
				break;
			}
		}
	}
}

protected function clmClear_clickHandler():void
{
	if (this.printclm!=null && this.printclm.length>0)
	{
		isNull=true;
		this.printclm.removeAll();
		this.dgrd_printclm.dataProvider.removeAll();
	}
}
//获得打印参数及赋值
private function getReportParamValues():void
{
	//加载模板参数
	AccessUtil.remoteCallJava("AcPrintSetDest","getDataByIfuncregedit",onGetDataByIfuncregedit,ifuncregedit,null,false);
}
private function onGetDataByIfuncregedit(evt:ResultEvent):void{
	var reportpnames:Array=new Array();
	if (evt.result)
	{
		var printListArr:ArrayCollection = evt.result as ArrayCollection;
		for each (var item:Object in printListArr) 
		{
			if (item.iid==dglist.selectedItem.iid)
			{
				reportpnames=GetParamsName(item.ccondit);
				break;
			}
		}
	}
	//为参数赋值
	var i:int=0;
	reportpnvalues=new ArrayCollection();
	for each (var pname:String in reportpnames) 
	{
		reportpnvalues.addItemAt(PrintParam.AddParam(pname,"1"),i);
		i++;
	}
	this.dispatchEvent(new Event("getReportParamValuesCompleted"));
}



//获得模板参数名
public static function GetParamsName(ccondit:String):Array
{
	var arr:Array=new Array();
	if (ccondit && StringUtil.trim(ccondit.toString())!="")
	{
		if (ccondit.indexOf(",")==-1)
		{
			arr.push(ccondit);
		}
		else
		{
			arr=ccondit.split(",");
		}
	}
	return arr;
}


private function lineNum(item:Object, column:DataGridColumn):String{	
	var lineNum:int = (dglist.dataProvider as ArrayCollection).getItemIndex(item)+1;
	return lineNum+"";
	
}
/**
 * 下载空白模版
 * 创建人:王炫皓
 * 创建时间:2012-11-16
 **/
private function downLoadBlankTemplate():void{
	//downfile/*
	//http://10.60.2.94:8080/WebRoot/printmodel/emptymodel.rar
	callLater(navigateToURL,[new URLRequest("../printmodel/emptymodel.rar")]);
}

