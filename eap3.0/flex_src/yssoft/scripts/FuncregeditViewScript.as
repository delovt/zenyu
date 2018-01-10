/**
 * 模块说明：功能注册表相关业务操作
 * 创建人：YJ
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 *
 */
import flash.utils.describeType;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLEncoder;
import mx.utils.StringUtil;

import yssoft.comps.CRMReferTextInput;
import yssoft.comps.frame.module.CrmEapTextInput;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.sysmanage.FuncregeditView;
import yssoft.vos.AsFuncregeditVO;

public var iid:int;
public var crm:CrmEapTextInput;

[Bindable]protected var arr_fields:ArrayCollection = new ArrayCollection();
[Bindable]protected var instanceInfo:XML=null;
[Bindable]protected var properties:XMLList=null;
[Bindable]public var operType:String;
[Bindable]protected var treeCompsXml:XML;
[Bindable]protected var asfuncregeditvo:AsFuncregeditVO = new AsFuncregeditVO();

[Bindable]
protected var arr_menubar:ArrayCollection = new ArrayCollection(
	[{label:"增加",name:"onNew"},
		{label:"修改",name:"onEdit"},
		{label:"删除",name:"onDelete"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"}]
);

[Bindable]
private var singleType:Object;
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
	AccessUtil.remoteCallJava("FuncregeditDest","getMenuList",onGetMenuListBack,"as_funcregedit");
}

private function onGetMenuListBack(evt:ResultEvent):void{
	//菜单赋值 
	if(evt.result.treexml != null)
		this.tree.treeCompsXml = new XML(evt.result.treexml as String);
	
	arr_fields = (evt.result.fieldslist) as ArrayCollection;
	
	//获取页面元素
	instanceInfo = describeType(this);
	
	
	//获取页面中所有TextInput元素的集合
	properties = instanceInfo..accessor.(@type=="mx.controls::TextInput");//不灵活，考虑单一
	
	var obj:Object=new Object();
	obj.cobjectname="UI_AS_funcregedit_ifuncregedit";
	obj.ifuncregedit="1";
	obj.cfield="ifuncregedit";
	AccessUtil.remoteCallJava("CommonalityDest","queryFun",requestCallBack,obj);
}

private function requestCallBack(event:ResultEvent):void
{
	if (ifuncregeditHbox.numChildren==0)
	{
		var obj:Object = event.result as Object;
		crm  = new CrmEapTextInput();
		crm.percentWidth=100;
		crm.singleType = obj;
		ifuncregeditHbox.addChild(crm);
	}
	
	
	//统一设置页面是否可以编辑
	CRMtool.containerChildsEnabled(this.container,false);
	
	//回车替代TAB键
	CRMtool.setTabIndex(this.container);
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
	var enabled:Boolean;
	var node:Object=this.tree.selectedItem;
	
	switch(event.item.name)
	{
		case "onNew":
			enabled = true;
			operType=event.item.name;
			onNew();
			break;
		case "onEdit":		{
			if(!onEdit())return;
			
			if (node==null)
			{
				CRMtool.showAlert(ConstsModel.MENU_CHOOSE);
				return;
			}
			else
			{				
				enabled=true;operType=event.item.name;
				/*onClearAll(operType,0);*/
				break;
			}
		}
		case "onDelete":{
			operType=event.item.name;
			if (node==null)
			{
				CRMtool.showAlert(ConstsModel.MENU_CHOOSE);
				return;
			}
			else
			{
				var ccode:String = String(node.@ccode);
				if(this.tree.isExistsChild(ccode,ConstsModel.MENU_ROMEVE_PID))
				{
					return;
				}
				removeTreeXml(this.tree.selectedItem,operType);
			}
			break;
		}
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
		case "onGiveUp":	{enabled=false;operType=event.item.name;onGiveUp();break;}
		default:
			break;
	}
	
	//调用按钮互斥
	CRMtool.toolButtonsEnabled(this.btn_menubar,event.item.name)
	//调用统一设置BorderContainer容器内控件enabled属性
	CRMtool.containerChildsEnabled(this.container,enabled);
	this.bdataauth.enabled=false;
}

/**
 * 函数名称：onGiveUp
 * 函数说明：放弃操作
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 *	
 */
private function onGiveUp():void{	
	
	onClearAll(operType,1);
	/*this.ifuncregedit.text = "";*/
	//crm = ifuncregeditHbox.getChildByName("UI_AS_funcregedit_ifuncregedit") as CrmEapTextInput;
	crm.text="";
	setValue();
	
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
	if(this.tree.selectedItem == null){CRMtool.showAlert(ConstsModel.MENU_CHOOSE); return false;}
	return true;
}

/**
 * 函数名称：onNew
 * 函数说明：增加数据时清空页面元素
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 *	
 */
private function onNew():void{	
	onClearAll(this.operType,0);
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
private function onClearAll(operType:String,flag:int):void{
	//清除控件值
	if(operType != "onEdit"){
		for each(var propertyInfo:XML in properties){
			var propertyName:String =propertyInfo.@name;
			TextInput(this[propertyName]).text="";
		}
		this.boperauth.selected=false;
		this.bdataauth.selected=false;
		this.bdataauth1.selected=false;
		this.bdataauth2.selected=false;
		this.bdictionary.selected = false;
		this.bnumber.selected = false;	
		this.bquery.selected = false;
		this.blist.selected = false;
		this.bprint.selected = false;
		this.bvouchform.selected=false;
		this.buse.selected=false;
		this.bbind.selected=false;
		this.bworkflowmodify.selected=false;
		//XZQWJ 2013-02-04 修改;原因：新增时，清空关联程序
		crm = ifuncregeditHbox.getChildByName("UI_AS_funcregedit_ifuncregedit") as CrmEapTextInput;
		crm.text="";
	}
	
	//清除控件样式
	/*for each (var DataInfo:Object in arr_fields){
	var name:String=DataInfo.cfield;
	if((operType == "onNew" || operType == "onEdit") && flag==0){//点击新增时
	TextInput(this[name]).setStyle("borderStyle","solid");
	TextInput(this[name]).setStyle("borderVisible","true");
	TextInput(this[name]).setStyle("borderColor","red");
	}
	else
	TextInput(this[name]).setStyle("borderStyle","none");
	}*/
	
	if(operType == "onNew" || operType == "onEdit")this.ccode.setFocus();
	
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

private function onSave():void{
	switch(operType)
	{			
		case "onNew":{	AccessUtil.remoteCallJava("FuncregeditDest","addFuncrededit",onFuncrededitBack,asfuncregeditvo);break;}
		case "onEdit":{AccessUtil.remoteCallJava("FuncregeditDest","updateFuncrededit",onFuncrededitBack,asfuncregeditvo);break;}
		default:break;
	}
	
}

private function onFuncrededitBack(evt:ResultEvent):void{
	if(evt.result || evt.result.toString()!="fail")
	{
		var result:String = evt.result as String;
		
		if(this.operType =="onNew")
		{
			asfuncregeditvo.iid=int(Number(result));
			//CRMtool.tipAlert(ConstsModel.MENU_ADD_SUCCESS);
            CRMtool.tipAlert("新增成功！");
		}
		else if(this.operType=="onDelete")
		{
			//CRMtool.tipAlert(ConstsModel.MENU_REMOVE);
            CRMtool.tipAlert("删除成功！");
		}
		else if(this.operType=="onEdit")
		{
            if(!(tree.selectedItem.@bdataauth1 == bdataauth1.selected+"" && tree.selectedItem.@bdataauth2 == bdataauth2.selected+"")){
                update_initdata();
            }

			//CRMtool.tipAlert(ConstsModel.MENU_UPDATE_SUCCESS);
            CRMtool.tipAlert("修改成功！");
		}
		
		this.updateTreeItem();
		onAfterSave();
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.MENU_FAIL);
	}
}

/**
 * 函数名称：onAfterSave
 * 函数说明：数据保存后数据处理
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 *	
 */
private function onAfterSave():void{
	
	//清除样式
	onClearAll(operType,1);
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
	
	if(this.operType=="onEdit")
	{
		asfuncregeditvo.iid =  int(Number(this.tree.selectedItem.@iid));
		asfuncregeditvo.oldCcode=this.tree.selectedItem.@ccode;
	}
	asfuncregeditvo.ipid = this.tree.getIpid(this.ccode.text);
	asfuncregeditvo.ccode = this.ccode.text; 
	asfuncregeditvo.cname = this.cname.text;
	asfuncregeditvo.cparameter =this.cparameter.text;
	asfuncregeditvo.cprogram = this.cprogram.text;
	asfuncregeditvo.ctable = this.ctable.text;
	asfuncregeditvo.iworkflow = 0; 
	asfuncregeditvo.iform = 0;
	asfuncregeditvo.ccaptionfield=this.ccaptionfield.text;
	
	//参照赋值
	
	if(crm.text == null)asfuncregeditvo.ifuncregedit = 0;
	else asfuncregeditvo.ifuncregedit = crm.consultList.getItemAt(0)[crm.singleType.cconsultbkfld];
	
//	crm.text= asfuncregeditvo.ifuncregedit+"";
//	crm.onDataChange();
//	if(null!=crm.consultList&&crm.consultList.length>0)
//	{
//		asfuncregeditvo.ifuncregedit =crm.consultList.getItemAt(0)[crm.singleType.cconsultbkfld];
//	}
	
	/*	this.ifuncregedit.text = "";
	this.ifuncregedit.text = this.tree.selectedItem.@ifuncregedit;*/
	
	asfuncregeditvo.boperauth = int(Number(this.boperauth.selected));
	asfuncregeditvo.bdataauth = int(Number(this.bdataauth.selected));
	asfuncregeditvo.bdataauth1 = int(Number(this.bdataauth1.selected));
	asfuncregeditvo.bdataauth2 = int(Number(this.bdataauth2.selected));
	
	asfuncregeditvo.bdictionary = int(Number(this.bdictionary.selected));
	asfuncregeditvo.bnumber = int(Number(this.bnumber.selected));
	asfuncregeditvo.bquery = int(Number(this.bquery.selected));
	asfuncregeditvo.blist = int(Number(this.blist.selected));
	asfuncregeditvo.brepeat = int(Number(this.brepeat.selected));
	asfuncregeditvo.brelation = int(Number(this.brelation.selected));
	asfuncregeditvo.bprint = int(Number(this.bprint.selected));
	asfuncregeditvo.bworkflow = this.bworkflow.selected;
	if (this.iimage.text!="")
	{
		asfuncregeditvo.iimage=int(Number(this.iimage.text));
	}
	asfuncregeditvo.bvouchform=int(Number(this.bvouchform.selected));
	asfuncregeditvo.buse=int(Number(this.buse.selected));
	asfuncregeditvo.bbind=int(Number(this.bbind.selected));
	asfuncregeditvo.bworkflowmodify=int(Number(this.bworkflowmodify.selected));
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-04
 * 功能： 刷新树节点
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function updateTreeItem():void
{
	switch(operType)
	{
		case "onNew":
			this.tree.AddTreeNode(asfuncregeditvo);
			break;
		case "onEdit":
			var curxml:XML = this.tree.selectedItem as XML;
			var ccode:String = curxml.@ccode; //原选中编码
			this.tree.EditTreeNode(asfuncregeditvo);			
			setValue();
			break;
		case "onDelete":
			this.tree.DeleteTreeNode();
			break;
		default:
			break;
	}
}
/**
 * 函数名称：deleteTreeItems
 * 函数说明：删除树节点
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
public function deleteTreeItems():void
{
	delete (treeCompsXml.descendants("*").(@iid==this.tree.selectedItem.@iid) as XMLList)[0] as XML;
}
/**
 * 函数名称：addTreeItems
 * 函数说明：增加树节点
 * 函数参数：无
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110811
 * 修改日期：
 * 
 */
private function addTreeItems():void{
	if(treeCompsXml == null)treeCompsXml = new XML("<root></root>");
	var node:XML = ((this.treeCompsXml.descendants("*").(@iid==asfuncregeditvo.ipid) as XMLList)[0] as XML);
	if (node==null)
	{
		asfuncregeditvo.ipid=-1;
	}
	var newnode:String = "<node iid="+"'"+asfuncregeditvo.iid
		+"' ipid='"+asfuncregeditvo.ipid
		+"' ccode='"+asfuncregeditvo.ccode
		+"' cname='"+asfuncregeditvo.cname
		+"' ilistset='"+asfuncregeditvo.ifuncregedit
		+"' cparameter='"+asfuncregeditvo.cparameter
		+"' cprogram='"+asfuncregeditvo.cprogram
		+"' ctable='"+asfuncregeditvo.ctable
		+"' brepeat='"+asfuncregeditvo.brepeat
		+"' brelation='"+asfuncregeditvo.brelation
		+"' iworkflow='"+asfuncregeditvo.iworkflow
		+"' iform='"+asfuncregeditvo.iform
		+"' boperauth='"+asfuncregeditvo.boperauth
		+"' bdataauth='"+asfuncregeditvo.bdataauth
		+"' bdataauth1='"+asfuncregeditvo.bdataauth1
		+"' bdataauth2='"+asfuncregeditvo.bdataauth2
		+"' bdictionary='"+asfuncregeditvo.bdictionary
		+"' bnumber='"+asfuncregeditvo.bnumber
		+"' bquery='"+asfuncregeditvo.bquery
		+"' bprint='"+asfuncregeditvo.bprint
		+"' blist='"+asfuncregeditvo.blist
		+"' iimage='"+asfuncregeditvo.iimage
		+"' bvouchform='"+asfuncregeditvo.bvouchform
		+"' buse='"+asfuncregeditvo.buse
		+"' bbind='"+asfuncregeditvo.bbind
		+"' bworkflowmodify='"+asfuncregeditvo.bworkflowmodify
		+"'/>";
	if (node==null)
	{		
		treeCompsXml.appendChild(XML(newnode));
	}
	else
	{
		node.appendChild(XML(newnode));
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
	var t_arr:ArrayCollection = new ArrayCollection();
	
	//新增时检查编码是否重复
	if(operType=="onNew")
	{
		if(this.tree.isExistsCcode(this.ccode.text,ConstsModel.MENU_CCODE_WARNMSG))
		{
			return false;
		}
	}
	//编辑时校验
	if(operType=="onEdit")
	{
		if(!this.tree.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.MENU_CHOOSE);
			return false;
		}
		if(this.tree.selectedItem.@ccode!=this.ccode.text){
			if(this.tree.isExistsCcode(this.ccode.text,ConstsModel.MENU_CCODE_WARNMSG))
			{
				return false;
			}
		}
	}
	
	if(!this.tree.isExistsParent(this.ccode.text,ConstsModel.MENU_PID_WARNMSG))
	{
		return false;
	}
	
	//检验不为空的字段值是否为空	
	/*for each (var DataInfo:Object in arr_fields){
	var name:String=DataInfo.cfield;
	if(StringUtil.trim(TextInput(this[name]).text) ==""){Alert.show("请填写必输项");return false;break;}
	}*/
	
	setFuncregeditVO();
	
	return true;
}

private function onDelete():void{
	var node:Object=this.tree.selectedItem;
	if (node==null)
	{
		CRMtool.showAlert(ConstsModel.MENU_CHOOSE);
		return;
	}
	else
	{
		var ccode:String = String(node.@ccode);
		if(this.tree.isExistsChild(ccode,ConstsModel.MENU_ROMEVE_PID))
		{
			return; 
		}
		removeTreeXml(this.tree.selectedItem,operType);
	}
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
	CRMtool.tipAlert(ConstsModel.MENU_DETERMINE_HEAD+node.@ccname+ConstsModel.MENU_DETERMINE_TAIL,null,"AFFIRM",this,"onDeleteTree");
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
public function onDeleteTree():void
{
	AccessUtil.remoteCallJava("FuncregeditDest","deleteFuncrededit",onFuncrededitBack,iid,ConstsModel.MENU_REMOVE_INFO);
}

public function setValue():void{
	
	this.ccode.text		=	asfuncregeditvo.ccode;
	this.cname.text		=	asfuncregeditvo.cname;
	this.cprogram.text	=	asfuncregeditvo.cprogram;
	this.cparameter.text = asfuncregeditvo.cparameter;
	this.ctable.text 	= 	asfuncregeditvo.ctable;
	this.iimage.text 	= 	asfuncregeditvo.iimage.toString();
	
	/*this.ifuncregedit.tnp_text.text = 	asfuncregeditvo.ifuncregedit+"";*/
	
	if(asfuncregeditvo.boperauth == 0)
		this.boperauth.selected = false;
	else
		this.boperauth.selected = true;
	
	if(asfuncregeditvo.bdataauth == 0)
		this.bdataauth.selected = false;
	else
		this.bdataauth.selected = true;
	
	if(asfuncregeditvo.bdataauth1 == 0)
		this.bdataauth1.selected = false;
	else
		this.bdataauth1.selected = true;
	
	if(asfuncregeditvo.bdataauth2 == 0)
		this.bdataauth2.selected = false;
	else
		this.bdataauth2.selected = true;
	
	if(asfuncregeditvo.bdictionary == 0)
		this.bdictionary.selected = false;
	else
		this.bdictionary.selected = true;
	if(asfuncregeditvo.bnumber == 0)
		this.bnumber.selected = false;
	else
		this.bnumber.selected = true;
	
	if(asfuncregeditvo.bquery == 0)
		this.bquery.selected = false;
	else
		this.bquery.selected = true;
	if(asfuncregeditvo.blist == 0)
		this.blist.selected = false;
	else
		this.blist.selected = true;
	
	if(asfuncregeditvo.brepeat == 0)
		this.brepeat.selected = false;
	else
		this.brepeat.selected = true;
	
	if(asfuncregeditvo.brelation == 0)
		this.brelation.selected = false;
	else
		this.brelation.selected = true;
	
	if(asfuncregeditvo.bprint == 0)
		this.bprint.selected = false;
	else
		this.bprint.selected = true;
	
	if(asfuncregeditvo.bvouchform == 0)
		this.bvouchform.selected = false;
	else
		this.bvouchform.selected = true;
	
	if(asfuncregeditvo.buse == 0)
		this.buse.selected = false;
	else
		this.buse.selected = true;
	
	if(asfuncregeditvo.bbind == 0)
		this.bbind.selected = false;
	else
		this.bbind.selected = true;
	
	if(asfuncregeditvo.bworkflowmodify == 0)
		this.bworkflowmodify.selected = false;
	else
		this.bworkflowmodify.selected = true;
	
}

protected function tree_itemClickHandler(event:ListEvent):void
{
	if(this.tree.selectedItem.@boperauth == 1 || this.tree.selectedItem.@boperauth == "true")
		this.boperauth.selected =true;
	else
		this.boperauth.selected = false;
	
	if(this.tree.selectedItem.@bdataauth == 1 || this.tree.selectedItem.@bdataauth == "true")
		this.bdataauth.selected =true;
	else
		this.bdataauth.selected = false;
	
	if(this.tree.selectedItem.@bdataauth1 == 1 || this.tree.selectedItem.@bdataauth1 == "true")
		this.bdataauth1.selected =true;
	else
		this.bdataauth1.selected = false;
	
	if(this.tree.selectedItem.@bdataauth2 == 1 || this.tree.selectedItem.@bdataauth2 == "true")
		this.bdataauth2.selected =true;
	else
		this.bdataauth2.selected = false;
	
	if(this.tree.selectedItem.@bdictionary == 1 || this.tree.selectedItem.@bdictionary == "true")
		this.bdictionary.selected =true;
	else
		this.bdictionary.selected = false;
	if(this.tree.selectedItem.@bnumber == 1 || this.tree.selectedItem.@bnumber == "true")
		this.bnumber.selected = true;
	else
		this.bnumber.selected = false;
	
	if(this.tree.selectedItem.@bquery == 1 || this.tree.selectedItem.@bquery == "true")
		this.bquery.selected =true;
	else
		this.bquery.selected = false;
	
	
	if(this.tree.selectedItem.@blist == 1 || this.tree.selectedItem.@blist == "true")
		this.blist.selected = true;
	else
		this.blist.selected = false;
	
	if(this.tree.selectedItem.@brepeat == 1 || this.tree.selectedItem.@brepeat == "true")
		this.brepeat.selected = true;
	else
		this.brepeat.selected = false;
	
	if(this.tree.selectedItem.@brelation == 1 || this.tree.selectedItem.@brelation == "true")
		this.brelation.selected = true;
	else
		this.brelation.selected = false;
	
	if(this.tree.selectedItem.@bprint == 1 || this.tree.selectedItem.@bprint == "true")
		this.bprint.selected = true;
	else
		this.bprint.selected = false;
	
	if(this.tree.selectedItem.@bvouchform == 1 || this.tree.selectedItem.@bvouchform == "true")
		this.bvouchform.selected = true;
	else
		this.bvouchform.selected = false;
	
	if(this.tree.selectedItem.@buse == 1 || this.tree.selectedItem.@buse == "true")
		this.buse.selected = true;
	else
		this.buse.selected = false;
	
	if(this.tree.selectedItem.@bbind == 1 || this.tree.selectedItem.@bbind == "true")
		this.bbind.selected = true;
	else
		this.bbind.selected = false;
	
	if(this.tree.selectedItem.@bworkflowmodify == 1 || this.tree.selectedItem.@bworkflowmodify == "true")
		this.bworkflowmodify.selected = true;
	else
		this.bworkflowmodify.selected = false;
	
	//参照赋值
	crm = ifuncregeditHbox.getChildByName("UI_AS_funcregedit_ifuncregedit") as CrmEapTextInput;
	
	crm.text= this.tree.selectedItem.@ifuncregedit;
	crm.onDataChange();
}

//控制操作权限勾选
public function controlbdataauth():void
{
	this.bdataauth.selected=(this.bdataauth1.selected && this.bdataauth2.selected);
}


/**
 * 
 * 作者：liulei
 * 日期：2011-10-12
 * 功能 修改数据权限勾选初始化数据权限分配
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function update_initdata():void
{
	AccessUtil.remoteCallJava("as_dataauthViewDest","update_initdata",getupdate_initdataCallBackHandler,asfuncregeditvo.iid,null,false);
}
public function getupdate_initdataCallBackHandler(evt:ResultEvent):void
{
	if (evt.result.toString()!="sucess")
	{
		mx.controls.Alert.show("初始化数据权限分配失败！！");
	}
}


//窗体初始化
public function onWindowInit():void
{
	
}
//窗体打开
public function onWindowOpen():void
{
	ini();
	onGiveUp();
	/*this.ifuncregedit.text = "";*/
	//crm = ifuncregeditHbox.getChildByName("UI_AS_funcregedit_ifuncregedit") as CrmEapTextInput;
	crm.text="";
	CRMtool.toolButtonsEnabled(this.btn_menubar,"onGiveUp");
	
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}
