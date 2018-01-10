/**
 * 模块说明：指标配置
 * 创建人：LZX
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 *
 */
import flash.profiler.showRedrawRegions;
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
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.sysmanage.FuncregeditView;
import yssoft.vos.BmTargetVO;

public var iid:int;
public var crm:CrmEapTextInput;

[Bindable]protected var arr_fields:ArrayCollection = new ArrayCollection();
[Bindable]protected var instanceInfo:XML=null;
[Bindable]protected var properties:XMLList=null;
[Bindable]public var operType:String;
[Bindable]protected var treeCompsXml:XML;
[Bindable]protected var bmTargetVO:BmTargetVO = new BmTargetVO();

[Bindable]
protected var arr_menubar:ArrayCollection = new ArrayCollection(
	[{label:"增加",name:"onNew"},
		{label:"修改",name:"onEdit"},
		{label:"删除",name:"onDelete"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"}]
);

private var menuArray:ArrayCollection=new ArrayCollection([
	{label:"合计",value:"1"},
	{label:"统计",value:"2"}
]);

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
	AccessUtil.remoteCallJava("BmTargetDest","get_all_bm_target",onGetMenuListBack);
}

private function onGetMenuListBack(e:ResultEvent):void
{
	if(e.result!=null)
	{
		var treexml:XML = new XML(e.result as String);
		this.tree.treeCompsXml=treexml;
	}
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
	setFuncregeditVO();
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
		/*for each(var propertyInfo:XML in properties){
			var propertyName:String =propertyInfo.@name;
			TextInput(this[propertyName]).text="";
		}*/
		this.ccode.text		=	"";
		this.cname.text		=	"";
		this.cmemo.text	=	"";
		this.cvaluefield.text = "";
		this.cdepartmentfield.text 	= 	"";
		this.cpersonfield.text 	= 	"";
		this.cdatefield.text 	= 	"";
		this.csqlcd.text 	= 	"";
		this.cvaluetable.text = "";
		this.imaker.text = "";
		this.dmaker.text = "";
		this.imodify.text = ""
		this.dmodify.text = "";	
	}
	
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
		case "onNew":{	AccessUtil.remoteCallJava("BmTargetDest","add_bm_target",onFuncrededitBack,bmTargetVO);break;}
		case "onEdit":{AccessUtil.remoteCallJava("BmTargetDest","update_bm_target",onFuncrededitBack,bmTargetVO);break;}
		default:break;
	}
	
}

private function onFuncrededitBack(evt:ResultEvent):void{
	if(evt.result || evt.result.toString()!="fail")
	{
		var result:String = evt.result as String;
		
		if(this.operType =="onNew")
		{
			bmTargetVO.iid=int(Number(result));
			CRMtool.tipAlert("新增指标成功!");
		}
		else if(this.operType=="onDelete")
		{
			CRMtool.tipAlert("指标删除成功!");
		}
		else if(this.operType=="onEdit")
		{
			//update_initdata();
			CRMtool.tipAlert("数据保存成功!");
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
		bmTargetVO.iid =  int(Number(this.tree.selectedItem.@iid));
		bmTargetVO.oldCcode=this.tree.selectedItem.@ccode;
		bmTargetVO.imodify = CRMmodel.userId;
//		bmTargetVO.dmodify = new Date();
	}
	if(this.operType=="onNew") {
		bmTargetVO.imaker = CRMmodel.userId;
//		bmTargetVO.dmaker = new Date();
	}
	bmTargetVO.ipid = this.tree.getIpid(this.ccode.text);
	bmTargetVO.ccode = this.ccode.text; 
	bmTargetVO.cname = this.cname.text;
	bmTargetVO.cmemo = this.cmemo.text;
	if(this.ivaluetype.selectedItem) {
		bmTargetVO.ivaluetype =this.ivaluetype.selectedItem.value;
	}else {
		bmTargetVO.ivaluetype = 0;
	}
	bmTargetVO.cvaluefield = this.cvaluefield.text;
	bmTargetVO.cdepartmentfield = this.cdepartmentfield.text;
	bmTargetVO.cpersonfield = this.cpersonfield.text;
	bmTargetVO.csqlcd = this.csqlcd.text;
	bmTargetVO.cdatefield = this.cdatefield.text;
	bmTargetVO.cvaluetable = this.cvaluetable.text;
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
			this.tree.AddTreeNode(bmTargetVO);
			break;
		case "onEdit":
			var curxml:XML = this.tree.selectedItem as XML;
			var ccode:String = curxml.@ccode; //原选中编码
			this.tree.EditTreeNode(bmTargetVO);			
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
	var node:XML = ((this.treeCompsXml.descendants("*").(@iid==bmTargetVO.ipid) as XMLList)[0] as XML);
	if (node==null)
	{
		bmTargetVO.ipid=-1;
	}
	var newnode:String = "<node iid="+"'"+bmTargetVO.iid
		+"' ipid='"+bmTargetVO.ipid
		+"' ccode='"+bmTargetVO.ccode
		+"' cname='"+bmTargetVO.cname
		+"' cmemo='"+bmTargetVO.cmemo
		+"' ivaluetype='"+bmTargetVO.ivaluetype
		+"' cvaluefield='"+bmTargetVO.cvaluefield
		+"' cdepartmentfield='"+bmTargetVO.cdepartmentfield
		+"' cpersonfield='"+bmTargetVO.cpersonfield
		+"' csqlcd='"+bmTargetVO.csqlcd
		+"' cdatefield='"+bmTargetVO.cdatefield
		+"' imaker='"+bmTargetVO.imaker
		+"' dmaker='"+bmTargetVO.dmaker
		+"' imodify='"+bmTargetVO.imodify
		+"' dmodify='"+bmTargetVO.dmodify
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
	
	if(this.ccode.text == "" || this.ccode.text == null) {
		CRMtool.showAlert("指标编码不能为空！");
		return false;
	}
	
	if(this.cname.text == "" || this.cname.text == null) {
		CRMtool.showAlert("指标名称不能为空！");
		return false;
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
	AccessUtil.remoteCallJava("BmTargetDest","delete_bm_target_byiid",onFuncrededitBack,iid,ConstsModel.MENU_REMOVE_INFO);
}

public function setValue():void{
	
	this.ccode.text		=	bmTargetVO.ccode;
	this.cname.text		=	bmTargetVO.cname;
	this.cmemo.text	=	bmTargetVO.cmemo;
	this.cvaluefield.text = bmTargetVO.cvaluefield;
	this.ivaluetype.selectedIndex  = bmTargetVO.ivaluetype-1;
	this.cdepartmentfield.text 	= 	bmTargetVO.cdepartmentfield;
	this.cpersonfield.text 	= 	bmTargetVO.cpersonfield;
	this.cdatefield.text 	= 	bmTargetVO.cdatefield;
	this.csqlcd.text 	= 	bmTargetVO.csqlcd;
	this.cvaluetable.text = bmTargetVO.cvaluetable;
	
	var sqlStr:String = "select hp.cname imaker,convert(varchar(10),bt.dmaker,120)  dmaker,hp2.cname imodify,convert(varchar(10),bt.dmodify,120)  dmodify from bm_target bt left join hr_person hp on hp.iid = bt.imaker " +
		"left join hr_person hp2 on hp2.iid = bt.imodify where bt.iid = " + bmTargetVO.iid;
	AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void{
		var eventAC:ArrayCollection =event.result as ArrayCollection;
		if(eventAC.length>0) {
			imaker.text  = eventAC[0].imaker;	
			dmaker.text  = eventAC[0].dmaker;
			imodify.text  = eventAC[0].imodify;
			dmodify.text  = eventAC[0].dmodify;
		}
	},sqlStr);	

}

protected function tree_itemClickHandler(event:ListEvent):void
{
	this.ccode.text		=	this.tree.selectedItem.@ccode;
	this.cname.text		=	this.tree.selectedItem.@cname;
	this.cmemo.text	=	this.tree.selectedItem.@cmemo;
	this.cvaluefield.text = this.tree.selectedItem.@cvaluefield;
	this.ivaluetype.selectedIndex  = this.tree.selectedItem.@ivaluetype-1;
	this.cdepartmentfield.text 	= 	this.tree.selectedItem.@cdepartmentfield;
	this.cpersonfield.text 	= 	this.tree.selectedItem.@cpersonfield;
	this.cdatefield.text 	= 	this.tree.selectedItem.@cdatefield;
	this.csqlcd.text 	= 	this.tree.selectedItem.@csqlcd;
	this.cvaluetable.text = this.tree.selectedItem.@cvaluetable;

	var sqlStr:String = "select hp.cname imaker,convert(varchar(10),bt.dmaker,120)  dmaker,hp2.cname imodify,convert(varchar(10),bt.dmodify,120)  dmodify from bm_target bt left join hr_person hp on hp.iid = bt.imaker " +
		"left join hr_person hp2 on hp2.iid = bt.imodify where bt.iid = " + this.tree.selectedItem.@iid;
	AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void {
		var eventAC:ArrayCollection =event.result as ArrayCollection;
		if(eventAC.length>0) {
			imaker.text  = eventAC[0].imaker;	
			dmaker.text  = eventAC[0].dmaker;
			imodify.text  = eventAC[0].imodify;
			dmodify.text  = eventAC[0].dmodify;
		}
	},sqlStr);
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
	AccessUtil.remoteCallJava("as_dataauthViewDest","update_initdata",getupdate_initdataCallBackHandler,bmTargetVO.iid,null,false);
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
	CRMtool.toolButtonsEnabled(this.btn_menubar,"onGiveUp");
	
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}
