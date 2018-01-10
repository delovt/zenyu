/**
 * 模块说明：单据编码表相关业务操作
 * 创建人：YJ
 * 创建日期：20110828
 * 修改人：
 * 修改日期：
 *
 */

import flash.events.Event;
import flash.events.FocusEvent;
import flash.utils.getDefinitionByName;

import mx.collections.ArrayCollection;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.TextInput;
import mx.core.UIComponent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberFormatter;
import mx.messaging.channels.StreamingAMFChannel;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import spark.components.ComboBox;
import spark.components.RadioButton;
import spark.components.RadioButtonGroup;
import spark.formatters.NumberFormatter;

import yssoft.impls.ICRMWindow;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.AcNumberSetVO;

/******************		变量		**********************/

[Bindable]protected var acNumberSetVO:AcNumberSetVO = new AcNumberSetVO();//实体类

[Bindable]protected var treeCompsXml:XML;//树数据

[Bindable]protected var arr_menubar:ArrayCollection = new ArrayCollection(
	[
		{label:"修改",name:"onEdit"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"}
	]);

[Bindable]public var operType:String;

[Bindable]public var arr_cb:ArrayCollection = null;//前缀数据集

[Bindable]public var arr_date:ArrayCollection = new ArrayCollection(
	[
		{label:"年",data:"1",width:40,selected:true},
		{label:"年月",data:"2",width:50,selected:false},
		{label:"年月日",data:"3",width:80,selected:false}
	]);


[Bindable]public var ctable:String;

[Bindable]public var ifuncregedit:int;

[Bindable]public var flag:int;//标识

[Bindable]public var arr_prefixlist:ArrayCollection;

[Bindable]public var arr_numbersetlist:ArrayCollection;

[Bindable]public var arr_numberhistory:ArrayCollection;//单据历史信息

[Bindable]public var vouchNumber:String="";//单据编号

[Bindable]public var projectEffect:String;//方案效果

/******************		函数		**********************/

/**
 * 函数名称：ini
 * 函数说明：页面初始化操作，树菜单读取、按钮初始化操作
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110828 
 * 修改日期：
 *	
 */
protected function ini():void{
	
	//树菜单
	iniTreeMenu();
}

//窗体初始化
public function onWindowInit():void
{
	
}
//窗体打开
public function onWindowOpen():void
{
	ini();
	
	CRMtool.toolButtonsEnabled(this.btn_menubar,"onGiveUp");
	this.treeMenu.enabled = true;
	
	onClearElements(0);
	this.ccode.text = "";
	this.vouchNumber = "";
	
	this.dg.dataProvider = null;
	
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}


/**
 * 函数名称：iniTreeMenu
 * 函数说明：初始化树菜单
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110828 
 * 修改日期：
 *	
 */
protected function iniTreeMenu():void{
	AccessUtil.remoteCallJava("NumberSetDest","getTreeMenuList",onGetTreeMenuListBack);
}
private function onGetTreeMenuListBack(evt:ResultEvent):void{
	if(evt.result != null)		
		treeMenu.treeCompsXml = new XML(evt.result as String);
	
	//统一设置页面是否可以编辑
	CRMtool.containerChildsEnabled(container,false);
	//回车替代TAB键
	CRMtool.setTabIndex(this.container);
}



/**
 * 函数名称：btn_menubar_itemClickHandler
 * 函数说明：菜单点击事件
 * 函数参数：event
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110828 
 * 修改日期：
 *	
 */
protected function btn_menubar_itemClickHandler(event:ItemClickEvent):void
{
	var enabled:Boolean;
	var node:Object=this.treeMenu.selectedItem;
	operType = event.item.name;
	
	switch(event.item.name)
	{
		case "onEdit":	
			if(onEditBefore()){
				onEdit();
				enabled=true;
			}
			else
				return;
			break;
		
		case "onSave":
			enabled=false;
			if (onBeforeSave())
			{
				onSave();
			}
			else
			{
				return;
			}
			break;			
		case "onGiveUp":	{enabled=false;onGiveUp();break;}
		default:
			break;
	}
	
	//调用按钮互斥
	CRMtool.toolButtonsEnabled(btn_menubar,event.item.name)
	//调用统一设置BorderContainer容器内控件enabled属性
	CRMtool.containerChildsEnabled(container,enabled);
	
	if(itype.selectedValue != 2)
		setPageByItype();
	else
		CRMtool.containerChildsEnabled(v4,false);
}


/**
 * 函数名称：onEditBefore
 * 函数说明：修改之前的操作
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110828 
 * 修改日期：
 *	
 */
private function onEditBefore():Boolean{
	if(this.treeMenu.selectedItem == null){setMessage(ConstsModel.MENU_CHOOSE);return false;}
	if(StringUtil.trim(this.ccode.text) == "") {setMessage("请选择有意义的单据");return false;}
	return true;
}


/**
 * 函数名称：onEdit
 * 函数说明：修改的操作
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110828 
 * 修改日期：
 *	
 */
private function onEdit():void{
	this.treeMenu.enabled = false;
	
	if(v21.getChildren().length != 0) v21.enabled = true;
	if(v22.getChildren().length != 0) v22.enabled = true;
	if(v23.getChildren().length != 0) v23.enabled = true;
	
	
}


/**
 * 函数名称：onBeforeSave
 * 函数说明：数据保存之前的操作(设置实体类数据)
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110829 
 * 修改日期：
 *	
 */
private function onBeforeSave():Boolean{
	
	setAcNumberSetVO();
	return true;
	
}


/**
 * 函数名称：onSave
 * 函数说明：数据保存
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110829 
 * 修改日期：
 *	
 */
private function onSave():void{
	if(this.arr_numbersetlist.length>0 && this.arr_numbersetlist[0]["iid"] != null)
		AccessUtil.remoteCallJava("NumberSetDest","updateNumberSet",onAddNumberSetBack,acNumberSetVO);//更新
	else
		AccessUtil.remoteCallJava("NumberSetDest","addNumberSet",onAddNumberSetBack,acNumberSetVO);//新增
}



/**
 * 函数名称：onAddNumberSetBack
 * 函数说明：数据保存后操作
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110829 
 * 修改日期：
 *	
 */
private function onAddNumberSetBack(evt:ResultEvent):void{
	if(evt.result as String == "no")
		this.setMessage("操作失败！");
	else{
		this.onClearElements(0);
		switch(acNumberSetVO.cprefix1)
		{
			case "1":
			{
				this.cb1.text ="服务器日期";
				this.vouchNumber = "服务器日期";		
				this.cb1.selectedIndex= Number(acNumberSetVO.cprefix1);
				if(this.arr_numbersetlist.length > 0){
					this.arr_numbersetlist[0] = this.acNumberSetVO;
				}
				setControls(this.cb1,this.v21,"cprefix1value");
				break;
			}
			case "2":
			{
				this.cb1.text ="本机日期";
				this.vouchNumber = "本机日期";
				this.cb1.selectedIndex= Number(acNumberSetVO.cprefix1);
				if(this.arr_numbersetlist.length > 0){
					this.arr_numbersetlist[0] = this.acNumberSetVO;
				}
				setControls(this.cb1,this.v21,"cprefix1value");
				break;
			}
			case "3":
			{
				this.cb1.text ="固定字符";
				this.vouchNumber = "固定字符";
				this.cb1.selectedIndex= Number(acNumberSetVO.cprefix1);
				if(this.arr_numbersetlist.length > 0){
					this.arr_numbersetlist[0] = this.acNumberSetVO;
				}
				setControls(this.cb1,this.v21,"cprefix1value");
				break;
			}
				
			default:
			{
				this.cb1.text ="";
				this.vouchNumber = "";
				break;
			}
		}
		switch(acNumberSetVO.cprefix2)
		{
			case "1":
			{
				this.cb2.text ="服务器日期";
				this.cb2.selectedIndex= Number(acNumberSetVO.cprefix2);
				setControls(this.cb2,this.v22,"cprefix2value");
				break;
			}
			case "2":
			{
				this.cb2.text ="本机日期";
				this.cb2.selectedIndex= Number(acNumberSetVO.cprefix2);
				setControls(this.cb2,this.v22,"cprefix2value");
				break;
			}
			case "3":
			{
				this.cb2.text ="固定字符";
				this.cb2.selectedIndex= Number(acNumberSetVO.cprefix2);
				setControls(this.cb2,this.v22,"cprefix2value");
				break;
			}
				
			default:
			{
				this.cb2.text ="";
				break;
			}
		}		
		switch(acNumberSetVO.cprefix3)
		{
			case "1":
			{
				this.cb3.text ="服务器日期";
				this.cb3.selectedIndex= Number(acNumberSetVO.cprefix3);
				setControls(this.cb2,this.v23,"cprefix3value");
				break;
			}
			case "2":
			{
				this.cb3.text ="本机日期";
				this.cb3.selectedIndex= Number(acNumberSetVO.cprefix3);
				setControls(this.cb2,this.v23,"cprefix3value");
				break;
			}
			case "3":
			{
				this.cb3.text ="固定字符";
				this.cb3.selectedIndex= Number(acNumberSetVO.cprefix3);
				setControls(this.cb2,this.v23,"cprefix3value");
				break;
			}
				
			default:
			{
				this.cb3.text ="";
				break;
			}
		}
		this.ilength.text = acNumberSetVO.ilength.toString();
		this.istep.text = acNumberSetVO.istep.toString();
		this.ibegin.text = acNumberSetVO.ibegin.toString();
		this.itype.selectedValue = acNumberSetVO.itype.toString();
		if(acNumberSetVO.itype == 0){
			this.vouchNumber = "完全手工";
		}
		if(acNumberSetVO.itype == 1){
			this.vouchNumber = "纯流水";
		}
		if(arr_numbersetlist&&this.arr_numbersetlist.length>0){
			this.setMyProject(this.arr_numbersetlist);
		}
		this.treeMenu.enabled = true;
	}
	
}


/**
 * 函数名称：setAcNumberSetVO
 * 函数说明：给实体类设置数据
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110829 
 * 修改日期：
 *	
 */
private function setAcNumberSetVO():void{
	
	//判断主键是否为空
	if(this.arr_numbersetlist.length>0 && this.arr_numbersetlist[0]["iid"] != null) 
		acNumberSetVO.iid = arr_numbersetlist[0]["iid"];
	
	acNumberSetVO.ifuncregedit = treeMenu.selectedItem.@iid;
	
	switch(itype.selectedValue){
		case 0://完全手工
			acNumberSetVO.itype = 0;
			acNumberSetVO.cprefix1 = "";
			acNumberSetVO.cprefix1value ="";
			acNumberSetVO.bprefix1rule = 0;
			acNumberSetVO.cprefix2 = "";
			acNumberSetVO.cprefix2value = "";
			acNumberSetVO.bprefix2rule = 0;
			acNumberSetVO.cprefix3 = "";
			acNumberSetVO.cprefix3value = "";
			acNumberSetVO.bprefix3rule = 0;
			acNumberSetVO.ilength = 0;
			acNumberSetVO.istep =0;
			acNumberSetVO.ibegin = 0;
			break;
		case 1://纯流水
			acNumberSetVO.itype = 1;
			acNumberSetVO.ilength = int(this.ilength.text==null?0:this.ilength.text);
			acNumberSetVO.istep = int(this.istep.text==null?0:this.istep.text);
			acNumberSetVO.ibegin = int(this.ibegin.text==null?0:this.ibegin.text);
			acNumberSetVO.cprefix1 = "";
			acNumberSetVO.cprefix1value ="";
			acNumberSetVO.bprefix1rule = 0;
			acNumberSetVO.cprefix2 = "";
			acNumberSetVO.cprefix2value = "";
			acNumberSetVO.bprefix2rule = 0;
			acNumberSetVO.cprefix3 = "";
			acNumberSetVO.cprefix3value = "";
			acNumberSetVO.bprefix3rule = 0;	
			break;
		case 2:
			acNumberSetVO.itype = 2;
			acNumberSetVO.cprefix1 = this.cb1.selectedItem.value;
			acNumberSetVO.bprefix1rule = this.bprefix1rule.selected?1:0;
			acNumberSetVO.cprefix2 = this.cb2.selectedItem.value;
			acNumberSetVO.bprefix2rule = this.bprefix2rule.selected?1:0;
			acNumberSetVO.cprefix3 = this.cb3.selectedItem.value;
			acNumberSetVO.bprefix3rule = this.bprefix3rule.selected?1:0;			
			acNumberSetVO.ilength = int(this.ilength.text==null?0:this.ilength.text);
			acNumberSetVO.istep = int(this.istep.text==null?0:this.istep.text);
			acNumberSetVO.ibegin = int(this.ibegin.text==null?0:this.ibegin.text);
			break;
		default:
			break;
	}
}


private function onGiveUp():void{
	this.treeMenu.enabled = true;
	this.flag = 0;
	this.onSetElements(2);
}


/**
 * 函数名称：treeMenu_itemClickHandler
 * 函数说明：树菜单点击事件
 * 函数参数：event
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110828 
 * 修改日期：
 *	
 */
protected function treeMenu_itemClickHandler(event:ListEvent):void{
	if(this.treeMenu.selectedItem.@ctable != "" && this.treeMenu.selectedItem.@ipid !=-1){
		this.lblmessage.visible = false;
		this.ccode.text = this.treeMenu.selectedItem.@cname;
		
		var objvalue:Object = {};
		this.ifuncregedit = treeMenu.selectedItem.@iid;
		this.ctable = treeMenu.selectedItem.@ctable;
		
		objvalue.ctable = ctable;
		objvalue.ifuncregedit = ifuncregedit;
		//读取对应的编码信息
		AccessUtil.remoteCallJava("NumberSetDest","getNumberSetListByIfid",onGetNumberSetListByIfidBack,objvalue);
	}
	else{
		onClearElements(0);
		this.ccode.text = "";
		this.vouchNumber = "";
	}
	
}



private function onGetNumberSetListByIfidBack(evt:ResultEvent):void{
	
	if(evt.result != null){
		
		arr_prefixlist = evt.result.prefix_list as ArrayCollection;//作为前缀出现的字段集合
		arr_numbersetlist = evt.result.numberset_list as ArrayCollection;//编码规则记录集
		arr_numberhistory = evt.result.number_history as ArrayCollection;//单据历史信息
		
		if(arr_prefixlist.length == 0) this.setPrefixList(arr_prefixlist);
		
		if(arr_numbersetlist.length >0){		
			
			onSetElements(int(arr_numbersetlist[0]["itype"]));
			
			//设置方案效果
			setMyProject(arr_numbersetlist);
		}
		else
			this.onClearElements(0);
		
		this.dg.dataProvider = arr_numberhistory;
		
	}
	
}

/**
 * 函数名称：itype_changeHandler
 * 函数说明：方案改变事件
 * 函数参数：event
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110828 
 * 修改日期：
 *	
 */
protected function itype_changeHandler(event:Event):void
{
	this.vouchNumber = "";
	setPageByItype();
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
//		CRMtool.toolButtonsEnabled(btn_menubar,operType)
//		CRMtool.containerChildsEnabled(container,enable);
}


/**
 * 函数名称：setPageByItype
 * 函数说明：根据方案重新设置页面的输入元素
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function setPageByItype():void{
	if(operType == "onGiveUp") return;
	
	this.ccode.editable = false;
	CRMtool.containerChildsEnabled(v4,false);
	
	switch(itype.selectedValue){
		case 0:
			this.vouchNumber = "完全手工";
			this.onClearElements(0);
			CRMtool.containerChildsEnabled(v2,false);
			CRMtool.containerChildsEnabled(v3,false);
			break;
		case 1:
			this.vouchNumber = "纯流水";
			this.onSetElements(1);
			CRMtool.containerChildsEnabled(v2,false);
			CRMtool.containerChildsEnabled(v3,true);
			break;
		case 2:
			if(this.arr_cb == null) this.setPrefixList(this.arr_prefixlist);
			this.onSetElements(2);
			CRMtool.containerChildsEnabled(v2,true);
			CRMtool.containerChildsEnabled(v3,true);
			break;
		default:
			break;
	}
	
}


private function iniComboxData():void{
	
	var objvalue:Object = new Object();
	objvalue.ctable = ctable;
	objvalue.ifuncregedit = ifuncregedit;
	
	AccessUtil.remoteCallJava("NumberSetDest","getPreFixList",onGetPreFixListBack,objvalue);
}


private function onGetPreFixListBack(evt:ResultEvent):void{
	
	if(evt.result != null){
		var arr_data:ArrayCollection = evt.result as ArrayCollection;
			
		setPrefixList(arr_data);
		
	}
	
}


/**
 * 函数名称：setPrefixList
 * 函数说明：设置前缀数据
 * 函数参数：arr_data:ArrayCollection(表中作为参与单据编码的字段集合)
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function setPrefixList(arr_data:ArrayCollection):void{
	arr_cb = new ArrayCollection([
		{label:"",			value:"0",	datatype:"0"},
		{label:"服务器日期",value:"1",	datatype:"1"},
		{label:"本机日期",	value:"2",	datatype:"2"},
		{label:"固定字符",	value:"3",	datatype:"3"}
	]);
	
	
	for each(var dataitem:Object in arr_data){
		var obj:Object = {};
		obj.label	 = dataitem.ccaption;
		obj.value 	 = dataitem.cfield;
		obj.datatype = dataitem.idatatype;
		
		arr_cb.addItem(obj);
		
	}
	
	this.cb1.dataProvider = arr_cb;
	this.cb2.dataProvider = arr_cb;
	this.cb3.dataProvider = arr_cb;
}


/**
 * 函数名称：cb_changeHandler
 * 函数说明：所有前缀的改变事件，通用方法
 * 函数参数：event:ListEvent
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
protected function cb_changeHandler(event:ListEvent):void
{
	flag = 1;
	var cbid:String = mx.controls.ComboBox(event.target).id;//cb1
	var hboxid:String = "v2"+cbid.substr(2,1);
	
	var arrtemp:ArrayCollection = new ArrayCollection([{name:"cb1",label:cb1.text,value:this.cb1.selectedItem.value,datatype:this.cb1.selectedItem.datatype},
														{name:"cb2",label:cb2.text,value:this.cb2.selectedItem.value,datatype:this.cb2.selectedItem.datatype},
														{name:"cb3",label:cb3.text,value:this.cb3.selectedItem.value,datatype:this.cb3.selectedItem.datatype}]);
	
//	for(var i:int=0;i<arrtemp.length;i++){
//		var cbname:String = arrtemp[i]["name"].toString();
//		var cblabel:String = arrtemp[i]["label"].toString();
//		if(cblabel == "") break;
//		if(cbid == cbname){
//			
//			var objitem:Object = new Object();
//			objitem.label = arrtemp[i]["label"].toString();
//			objitem.value = arrtemp[i]["value"].toString();
//			objitem.value = arrtemp[i]["datatype"].toString();
//			this.arr_cb.addItem(objitem);
//			
//		}
//		else{
//		
//			this.arr_cb.removeItemAt(i);
//			
//		}
//	}
	
	this.setMyShow();
	
	this.setControls(this[cbid],this[hboxid],"");
}


/**
 * 函数名称：setShow
 * 函数说明：设置单据编码
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110906
 * 修改日期：
 * 
 */
private function setMyShow():void{
	
	/****	设置单据编码		***/
	var myPattern:RegExp = /\++/g;
	
	var textvalue:String = cb1.text+ "+" + cb2.text + "+" + cb3.text;
	
	//替换"++"
	var strreplace:String = textvalue.replace(myPattern,"+");
	
	//除去首尾"+"号
	if(strreplace.charAt(0) == "+")//首有"+"号
		strreplace = strreplace.substr(1,strreplace.length);
	if(strreplace.charAt(strreplace.length-1) == "+")//尾部有"+"
		strreplace = strreplace.substr(0,strreplace.length-1);
	
	this.vouchNumber = strreplace;
}


/**
 * 函数名称：setMyProject
 * 函数说明：设置方案效果
 * 函数参数：
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110906
 * 修改日期：
 * 
 */
private function setMyProject(arr_numbersetlist:ArrayCollection):void{
	
	switch(this.itype.selectedValue){
		case 0://完全手工
			this.projectEffect = "";
			break;
		case 1://纯流水
			
			var ilength:int = arr_numbersetlist[0]["ilength"];
			var effect:String = ilength.toString();
			while(effect.length<ilength)//Flex 补零
				effect = "0"+effect;
			this.projectEffect = effect;
			
			break;
		case 2://系统规则
			var cprefix1:String = arr_numbersetlist[0]["cprefix1"];
			var cprefix1value:String = arr_numbersetlist[0]["cprefix1value"];
			var bprefix1rule:Boolean = arr_numbersetlist[0]["bprefix1rule"]==0?false:true;
			
			var cprefix2:String = arr_numbersetlist[0]["cprefix2"];
			var cprefix2value:String = arr_numbersetlist[0]["cprefix2value"];
			var bprefix2rule:Boolean = arr_numbersetlist[0]["bprefix2rule"]==0?false:true;
			
			var cprefix3:String = arr_numbersetlist[0]["cprefix3"];
			var cprefix3value:String = arr_numbersetlist[0]["cprefix3value"];
			var bprefix3rule:Boolean = arr_numbersetlist[0]["bprefix3rule"]==0?false:true;
			
			var prefix:String = "";//前缀值
			
			if(cprefix1 != "")
				prefix += this.getValueByPreFix(cprefix1,cprefix1value,bprefix1rule,1);
			if(cprefix2 != "")
				prefix += this.getValueByPreFix(cprefix2,cprefix2value,bprefix2rule,2);
			if(cprefix3 != null && cprefix3 != "0")
				prefix += this.getValueByPreFix(cprefix3,cprefix3value,bprefix3rule,3);
			
			
			//流水
			var ilength2:int = arr_numbersetlist[0]["ilength"];
			var effect2:String = ilength2.toString();
			while(effect2.length<ilength2)//Flex 补零
				effect2 = "0"+effect2;
			this.projectEffect = prefix+effect2;
			
			break;
		default:
			break;
	}
	
}


private function getValueByPreFix(cprefix:String,cprefixvalue:String,bprefixrule:Boolean,cflag:int):String{
	if(cprefix == "1"){//服务器日期
		
		var sdate:String = "20110101";
		
		if(cprefixvalue == "年") 	  return sdate.substring(0,4);
		if(cprefixvalue	== "年月")    return sdate.substring(0,6);
		if(cprefixvalue	== "年月日")  return sdate;
		
	}
	else if(cprefix == "2"){//客户端日期
		
		var date:Date = new Date();
		var dateFormatter:DateFormatter = new DateFormatter();
		dateFormatter.formatString = "yyyymmdd";
		var cusdate:String = dateFormatter.format(date);
		
		if(cprefixvalue == "年") 	   return cusdate.substring(0,4);
		if(cprefixvalue == "年月")    return cusdate.substring(0,6);
		if(cprefixvalue == "年月日")  return cusdate;
		
	}
	else if(cprefix == "3"){//固定字符
		
		return cprefixvalue;
		
	}
	else{
		switch(cflag){
			case 1:
				return this.cb1.text;
			case 2:
				return this.cb2.text;
			case 3:
				return this.cb3.text;
		}
		
	}
	return "";
}


/**
 * 函数名称：setControls
 * 函数说明：根据前缀选择动态创建相应的控件
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
public function setControls(cb:mx.controls.ComboBox,hbox:HBox,fixfield:String):void{
	
	var i:int;
	
	if(hbox == null) return;
	hbox.removeAllChildren();
	
	if(cb.selectedItem.value=="1" || cb.selectedItem.value=="2" || cb.selectedItem.datatype=="datetime"){//日期类型
		
		var RBClass:Class=getDefinitionByName("spark.components.RadioButton") as Class;
		
		while(i<arr_date.length){
			
			var RBInstance:UIComponent=new RBClass();
			
			RadioButton(RBInstance).id 			= hbox.id+"_rb"+i;//RadioButton赋值id
			RadioButton(RBInstance).label 		= arr_date[i]["label"];
			RadioButton(RBInstance).value 		= arr_date[i]["data"];
			RadioButton(RBInstance).width		= arr_date[i]["width"];
			
			if(this.arr_numbersetlist.length >0 && operType != "onEdit"){
				if(arr_numbersetlist[0][fixfield] == arr_date[i]["label"])
					RadioButton(RBInstance).selected = true;
				else
					RadioButton(RBInstance).selected = false;
			}
			else
				RadioButton(RBInstance).selected 	= arr_date[i]["selected"];
			
			RadioButton(RBInstance).groupName	= "rbg"+hbox.id;
			
			hbox.addChild(RadioButton(RBInstance));
			
			//赋值默认(未改变的时候)
			if(this.arr_numbersetlist.length >0 && operType != "onEdit"){
				hbox.enabled = false;
				setCprefixValue(hbox.id,arr_numbersetlist[0][fixfield]);
			}
			else{
				hbox.enabled = true;
				setCprefixValue(hbox.id,"年");
			}
			
			RadioButton(RBInstance).addEventListener(Event.CHANGE,rb_Change);//监听改变事件
			
			i++;
			
		}
		
	} 
	else if(cb.selectedItem.value=="3"){//固定字符
		
		var TIClass:Class=getDefinitionByName("mx.controls.TextInput") as Class;
		var TIInstance:UIComponent=new TIClass();
		
		TextInput(TIInstance).id = hbox.id+"_txt";
		TextInput(TIInstance).styleName="contentTextInput";
		
		hbox.addChild(TextInput(TIInstance));
		
		if(this.arr_numbersetlist.length >0){
			if(operType == "onEdit")
				hbox.enabled = true;
			else
				hbox.enabled = false;
			TextInput(TIInstance).text = arr_numbersetlist[0][fixfield];
		}
		else{
			
			hbox.enabled = true;
			TextInput(TIInstance).setFocus();
		}
		
		TextInput(TIInstance).addEventListener(flash.events.FocusEvent.FOCUS_OUT,txt_FOCUS_OUT);//监听离开事件
		
	}
	else{//其他
		
		hbox.removeAllChildren();
		
		setCprefixValue(hbox.id,"");
	}
}


/**
 * 函数名称：rb_Change
 * 函数说明：RadioButton改变事件
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function rb_Change(evt:Event):void{
	
	//获取控件ID
	var rb_id:String = (evt.target as RadioButton).id.substr(0,3);
	var rb_label:String = (evt.target as RadioButton).label;
	
	setCprefixValue(rb_id,rb_label);
	
}


/**
 * 函数名称：txt_FOCUS_OUT
 * 函数说明：TextInput焦点离开事件
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function txt_FOCUS_OUT(evt:Event):void{
	
	var txt_id:String = (evt.currentTarget as TextInput).id.substr(0,3);
	var txt_value:String = mx.utils.StringUtil.trim((evt.currentTarget as TextInput).text);
	
	setCprefixValue(txt_id,txt_value);
}


/**
 * 函数名称：setCprefixValue
 * 函数说明：实体类中前缀值赋值，公共方法(多处调用)
 * 函数参数：key_id：判断依据，一般是HBox的id
 * 			value ：值
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function setCprefixValue(key_id:String,value:String):void{
	
	switch(key_id){
		case "v21":
			this.acNumberSetVO.cprefix1value = value;
			break;
		case "v22":
			this.acNumberSetVO.cprefix2value = value;
			break;
		case "v23":
			this.acNumberSetVO.cprefix3value = value;
			break;
		default:
			break;
	}
}


/**
 * 函数名称：onClearElements
 * 函数说明：清空页面中的元素
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function onClearElements(c_flag:int):void{
	if(c_flag == 0){
		this.itype.selectedValue = "0";		
		this.ibegin.text = "";
		this.istep.text = "";
		this.ilength.text = "";
		this.vouchNumber = "完全手工";
		this.projectEffect = "";
		//移除监听
		this.removeEventListener(flash.events.FocusEvent.FOCUS_OUT,txt_FOCUS_OUT);
		this.removeEventListener(Event.CHANGE,rb_Change);
	}
	else{
		this.itype.selectedValue = "1";
		this.vouchNumber = "纯流水";
	}
	
	this.cb1.selectedIndex = 0;
	this.cb2.selectedIndex = 0;
	this.cb3.selectedIndex = 0;		
	this.v21.removeAllChildren();
	this.v22.removeAllChildren();
	this.v23.removeAllChildren();
	this.bprefix1rule.selected = false;
	this.bprefix2rule.selected = false;
	this.bprefix3rule.selected = false;
	
}


/**
 * 函数名称：onSetElements
 * 函数说明：设置页面中的元素值
 * 函数参数：s_flag(标志)
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function onSetElements(s_flag:int):void{
	
	this.itype.selectedValue = s_flag;
	
	if(s_flag == 2){//系统规则
		
		if(this.arr_prefixlist.length >0) this.setPrefixList(arr_prefixlist);
		
		if(arr_cb != null){
			if(arr_numbersetlist.length>0){
				
				for(var i:int=0;i<arr_cb.length;i++){
					if(i>3){//如果前缀数据大于固定数据，则是字段数据，需要更改赋值方式
						if(arr_cb.getItemAt(i).value == arr_numbersetlist[0]["cprefix1"])
							this.cb1.selectedIndex = i;
						if(arr_cb.getItemAt(i).value == arr_numbersetlist[0]["cprefix2"])
							this.cb2.selectedIndex = i;
						if(arr_cb.getItemAt(i).value == arr_numbersetlist[0]["cprefix3"])
							this.cb3.selectedIndex = i;
					}
					else{//固定数据的赋值方式
						this.cb1.selectedIndex = arr_numbersetlist[0]["cprefix1"];
						this.cb2.selectedIndex = arr_numbersetlist[0]["cprefix2"];
						this.cb3.selectedIndex = arr_numbersetlist[0]["cprefix3"];
					}
				}
				
			}
			setControls(cb1,v21,"cprefix1value");
			setControls(cb2,v22,"cprefix2value");
			setControls(cb3,v23,"cprefix3value");
		}
				
		if(arr_numbersetlist.length>0){
			this.bprefix1rule.selected = arr_numbersetlist[0]["bprefix1rule"]==0?false:true;
			this.bprefix2rule.selected = arr_numbersetlist[0]["bprefix2rule"]==0?false:true;
			this.bprefix3rule.selected = arr_numbersetlist[0]["bprefix3rule"]==0?false:true;
		}
		
		this.setMyShow();
	}
	else if(s_flag == 1){
		this.onClearElements(1);
	}
	
	if(arr_numbersetlist.length >0){
		this.ilength.text = arr_numbersetlist[0]["ilength"];
		this.istep.text = arr_numbersetlist[0]["istep"];
		this.ibegin.text = arr_numbersetlist[0]["ibegin"];
	}
	else{
		if(operType == "onGiveUp") {
			this.ilength.text = "";
			this.istep.text = "";
			this.ibegin.text = "";
			this.vouchNumber = "";
		}
		else{
			this.ilength.text = "4";
			this.istep.text = "1";
			this.ibegin.text = "1";
		}
	}
	
}
