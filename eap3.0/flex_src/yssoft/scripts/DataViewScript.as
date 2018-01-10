/**
 * 模块名称：基础档案数据对应的脚本文件
 * 模块说明：基础档案数据前台业务处理
 * 创建人：	YJ
 * 创建时间：20110822
 * 
 **/

import flash.utils.describeType;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.AsDataVO;



/**********************  变量定义  ****************************************/

[Bindable]protected  var iid:int;//选中节点的内码

[Bindable]protected 	var asDataVo:AsDataVO = new AsDataVO();//实体类

[Bindable]public 	  	var operType:String;//按钮类型

[Bindable]protected 	var instanceInfo:XML=null;//生成描述 ActionScript 对象（命名为方法的参数）的 XML 对象。

[Bindable]protected 	var properties:XMLList=null;

[Bindable]protected	var arr_notNull:ArrayCollection = new ArrayCollection();//必输项记录集

[Bindable]public 	  	var arr_menuBar:ArrayCollection = new ArrayCollection(
	[	{label:"增加",name:"onNew"},
		{label:"修改",name:"onEdit"},
		{label:"删除",name:"onDelete"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"}]
);





/**********************  函数  ****************************************/
/**
 *
 * 函数名称：ini()
 * 函数说明：窗体初始化的操作(初始化树菜单和必输字段)
 * 函数参数：无
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
protected function ini():void{
	var tablename:String = "aa_data";
	
	var obj:Object = new Object();
	obj.bsystem = Number(this.lblflag.text.toString());
	obj.tablename = tablename;
	
	AccessUtil.remoteCallJava("DataDest","getMenuListByClass",onGetMenuListByClassBack,obj);
}


/**
 *
 * 函数名称：onGetMenuListBack()
 * 函数说明：读取树菜单后的操作(数据绑定)
 * 函数参数：无 
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onGetMenuListByClassBack(evt:ResultEvent):void{
	
	//树菜单数据集
	if(evt.result.treeXml != null)
		this.treeClassMenu.dataProvider = new XML(evt.result.treeXml as String);
	
	//必输项设定
	if(evt.result.fieldslist != null)
		arr_notNull = evt.result.fieldslist as ArrayCollection;
	
	setPageElements();
}


/**
 *
 * 函数名称：setPageElements()
 * 函数说明：设置页面元素(页面状态、获取页面元素、回车键)
 * 函数参数：无
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function setPageElements():void{
	//统一设置页面是否可以编辑
	CRMtool.containerChildsEnabled(this.container,false);
	
	//获取页面元素
	instanceInfo = describeType(this);
	
	//获取页面中所有TextInput元素的集合
	properties = instanceInfo..accessor.(@type=="mx.controls::TextInput");//不灵活，考虑单一
	
	//回车替代TAB键
	CRMtool.setTabIndex(this.container);
}


/**
 *
 * 函数名称：menuBar_itemClickHandler()
 * 函数说明：菜单项的业务操作(增加、修改、删除、保存、放弃)
 * 函数参数：event:ItemClickEvent
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
protected function menuBar_itemClickHandler(event:ItemClickEvent):void
{
	var enabled:Boolean;
	if(event.item.name != "onSave") operType = event.item.name;
	
	switch(event.item.name){
		case "onNew":
			enabled = true;
			this.rbuse_y.selected = true;
			if(!onBeforeNew())return;
			onAdd();
			break;
		
		case "onEdit":
			enabled=true;
			if(!onBeforeEdit())return;
			onEdit();
			break;
		
		case "onDelete":
			if(onBeforeDelete())
				onDelete();
			else
				return;
			break;
		
		case "onSave":
			enabled = false;
			if(onBeforeSave())
				onSave();
			else
				return;
			break;
		
		case "onGiveUp":
			enabled = false;
			onGiveUp();
			break;
		default:
			break
	}
	
	//按钮互斥
	CRMtool.toolButtonsEnabled(this.menuBar,event.item.name)
	CRMtool.containerChildsEnabled(this.container,enabled);
}


/**
 *
 * 函数名称：onAdd()
 * 函数说明：数据增加
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onAdd():void{
	this.onClearAll(0);
}

/**
 *
 * 函数名称：onBeforeNew()
 * 函数说明：数据编辑之前的操作
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onBeforeNew():Boolean{
	if(this.treeClassMenu.selectedItem == null){CRMtool.showAlert(ConstsModel.MENU_CLASS_CHOOSE); return false;}
	if(this.treeClassMenu.dataDescriptor.isBranch(this.treeClassMenu.selectedItem)){CRMtool.showAlert(ConstsModel.MENU_CLASS_CHOOSEEND); return false;};
	return true;
}


/**
 *
 * 函数名称：onBeforeEdit()
 * 函数说明：数据编辑之前的操作
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onBeforeEdit():Boolean{
	if(this.treeMenu.selectedItem == null){CRMtool.showAlert(ConstsModel.MENU_CHOOSE); return false;}
	return true;
}


/**
 *
 * 函数名称：onEdit()
 * 函数说明：数据编辑
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onEdit():void{
	this.onClearAll(0);
}

/**
 *
 * 函数名称：onBeforeDelete()
 * 函数说明：数据删除之前操作
 * 函数参数：void
 * 函数返回：Boolean
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onBeforeDelete():Boolean{
	if(this.treeMenu.selectedItem == null) {CRMtool.showAlert(ConstsModel.MENU_CHOOSE);return false;}
	return true;
}

/**
 *
 * 函数名称：onDelete()
 * 函数说明：数据删除
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onDelete():void{
	var ccode:String = String(this.treeMenu.selectedItem.@ccode);
	if(this.treeMenu.isExistsChild(ccode,ConstsModel.MENU_ROMEVE_PID))
	{
		return;
	}
	removeTreeXml(this.treeMenu.selectedItem,operType);
}


/**
 * 函数名称：removeTreeXml
 * 函数说明：移除树节点
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */ 
public function removeTreeXml(node:Object,operType:String):void
{
	iid =int(Number(node.@iid));
	CRMtool.tipAlert(ConstsModel.MENU_DETERMINE_HEAD+"  "+node.@cname+"  "+ConstsModel.MENU_DETERMINE_TAIL,null,"AFFIRM",this,"onDeleteData");
}


/**
 * 函数名称：onDeleteTree
 * 函数说明：从数据库中删除树节点
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
public function onDeleteData():void
{
	AccessUtil.remoteCallJava("DataDest","delData",onDataBack,iid,ConstsModel.MENU_REMOVE_INFO);
}


/**
 *
 * 函数名称：onBeforeSave()
 * 函数说明：数据保存之前(验证数据)
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onBeforeSave():Boolean{
	//新增时检查编码是否重复
	if(operType=="onNew")
	{
		if(this.treeMenu.isExistsCcode(this.ccode.text,ConstsModel.MENU_CCODE_WARNMSG))
		{
			return false;
		}
	}
	//编辑时校验
	if(operType=="onEdit")
	{
		if(!this.treeMenu.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.MENU_CHOOSE);
			return false;
		}
		if(this.treeMenu.selectedItem.@ccode!=this.ccode.text){
			if(this.treeMenu.isExistsCcode(this.ccode.text,ConstsModel.MENU_CCODE_WARNMSG))
			{
				return false;
			}
		}
	}
	
	if(!this.treeMenu.isExistsParent(this.ccode.text,ConstsModel.MENU_PID_WARNMSG))
	{
		return false;
	}
	
	//检验不为空的字段值是否为空	
	for each (var DataInfo:Object in arr_notNull){
		var name:String=DataInfo.cfield;
		if(StringUtil.trim(TextInput(this[name]).text) ==""){this.setMessage(ConstsModel.DATA_NOTNULL);return false;break;}
	}
	
	onSetVO();
	
	return true;
}

/**
 *
 * 函数名称：onSetVO()
 * 函数说明：给实体类赋值
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onSetVO():void{
	if(operType == "onEdit"){
		asDataVo.iid =  int(Number(this.treeMenu.selectedItem.@iid));
		asDataVo.oldCcode=this.treeMenu.selectedItem.@ccode;
	}
	
	asDataVo.ipid 		= this.treeMenu.getIpid(this.ccode.text);
	asDataVo.ccode 		= StringUtil.trim(this.ccode.text);
	asDataVo.cname 		= StringUtil.trim(this.cname.text);
	asDataVo.cmnemonic 	= StringUtil.trim(this.cmnemonic.text);
	asDataVo.cmemo 		= StringUtil.trim(this.cmemo.text);
	asDataVo.cabbreviation 	= StringUtil.trim(this.cabbreviation.text);
	asDataVo.coutkey 	= StringUtil.trim(this.coutkey.text);
	asDataVo.bbuse 		= Number(this.buse.selectedValue+"");
}


/**
 *
 * 函数名称：onSave()
 * 函数说明：数据保存
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onSave():void{
	switch(operType)
	{			
		case "onNew":{	AccessUtil.remoteCallJava("DataDest","addData",onDataBack,asDataVo);break;}
		case "onEdit":{AccessUtil.remoteCallJava("DataDest","updateData",onDataBack,asDataVo);;break;}
		default:break;
	}
	
}



/**
 *
 * 函数名称：onAddDataClassBack()
 * 函数说明：数据保存后操作
 * 函数参数：evt:ResultEvent
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onDataBack(evt:ResultEvent):void{
	
	if(evt.result.toString()!="no")
	{
		var result:String = evt.result as String;
		
		if(this.operType =="onNew")		
			asDataVo.iid=int(Number(result));
		
		updateTreeItem();
		onClearAll(1);
	}
	else
	{
		this.setMessage(ConstsModel.DATA_FAIL);
	}
	
}

/**
 *
 * 函数名称：updateTreeItem()
 * 函数说明：更新树操作
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
public function updateTreeItem():void
{
	switch(operType)
	{
		case "onNew":
			this.treeMenu.AddTreeNode(asDataVo);
			break;
		case "onEdit":
			var curxml:XML = this.treeMenu.selectedItem as XML;
			var ccode:String = curxml.@ccode; //原选中编码
			this.treeMenu.EditTreeNode(asDataVo);
			setValue();
			break;
		case "onDelete":
			this.treeMenu.DeleteTreeNode();
			break;
		default:
			break;
	}
}


/**
 *
 * 函数名称：onGiveUp()
 * 函数说明：放弃操作
 * 函数参数：void
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onGiveUp():void{
	onClearAll(1);
	this.setValue();
}


/**
 * 函数名称：onClearAll
 * 函数说明：清除页面上的元素信息，原始状态
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function onClearAll(flag:int):void{
	//清除控件值
	if(operType != "onEdit"){
		for each(var propertyInfo:XML in properties){
			var propertyName:String =propertyInfo.@name;
			TextInput(this[propertyName]).text="";
		}
	}
	
	//设置控件样式
    /*	if(arr_notNull.length >0){
		for each (var DataInfo:Object in arr_notNull){
			var name:String=DataInfo.cfield;
			if((operType == "onNew" || operType == "onEdit") && flag==0){//点击新增时
				TextInput(this[name]).setStyle("borderStyle","solid");
				TextInput(this[name]).setStyle("borderVisible","true");
				TextInput(this[name]).setStyle("borderColor","red");
			}
			else
				TextInput(this[name]).setStyle("borderStyle","none");
		}
	}*/
	if(operType == "onNew" || operType == "onEdit") this.ccode.setFocus();
	this.lblmessage.visible = false;
	
}

/**
 * 函数名称：setMessage
 * 函数说明：设置提示信息
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function setMessage(message:String):void{
	this.lblmessage.visible = true;
	this.lblmessage.text = message;
	CRMtool.toolButtonsEnabled(this.menuBar,operType)
	CRMtool.containerChildsEnabled(this.container,true);
}

protected function treeMenu_itemClickHandler(event:ListEvent):void
{
	this.buse.selectedValue = this.treeMenu.selectedItem.@bbuse;
}

public function setValue():void{
	
	this.ccode.text			=	asDataVo.ccode;
	this.cname.text			=	asDataVo.cname;
	this.cmnemonic.text		=	asDataVo.cmnemonic;
	this.cmemo.text			=	asDataVo.cmemo;
	this.cabbreviation.text = asDataVo.cabbreviation;
	this.coutkey.text = asDataVo.coutkey;
	this.buse.selectedValue	= asDataVo.bbuse;
}

/**
 * 函数名称：treeClassMenu_itemClickHandler
 * 函数说明：档案分类点击事件
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
protected function treeClassMenu_itemClickHandler(event:ListEvent):void
{
	this.lblDataName.text = this.treeClassMenu.selectedItem.@cname;
	var iclass:int = this.treeClassMenu.selectedItem.@iid;
	this.asDataVo.iclass = iclass;
	
	AccessUtil.remoteCallJava("DataDest","getMenuList",onGetMenuListBack,iclass);
}



/**
 *
 * 函数名称：onGetMenuListBack()
 * 函数说明：读取树菜单后的操作(数据绑定)
 * 函数参数：无
 * 函数返回：无
 * 创建	 人：YJ
 * 创建日期：20110822
 */
private function onGetMenuListBack(evt:ResultEvent):void{
	//树菜单数据集
	if(evt.result != null)
		this.treeMenu.treeCompsXml = new XML(evt.result as String);
	else
		this.treeMenu.treeCompsXml = null;
}


