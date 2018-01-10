/**
 *
 * @author：liu_lei
 * 日期：2011-8-8
 * 功能：
 * 修改记录：
 *
 */
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.ItemClickEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.models.*;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.AsMenuVo;

[Bindable]
public var operType:String;

//工具栏初始化值
[Bindable]
public var lbrItem:ArrayCollection=new ArrayCollection([
	{label:"增加",name:"onNew"	},
	{label:"修改",name:"onEdit"},
	{label:"删除",name:"onDelete"	},
	{label:"保存",name:"onSave"},
	{label:"放弃",name:"onGiveUp"}]);

//主键		
public var iid:int;
//菜单VO
public var asMenuVo:AsMenuVo = new AsMenuVo();

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-08 
 * 功能：树初始化操作
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getTreeXml(event:Event=null):void
{
    var mv:AsMenuVo = new AsMenuVo();
    if(main_menu.selectedItem)
        mv.imenup = main_menu.selectedItem.@iid;
	AccessUtil.remoteCallJava("MenuDest","getMenusByIpid",callBackHandler,mv);
}


/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-08 
 * 功能：树初始化操作回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		tre_menu.treeCompsXml = new XML(event.result as String);
	}
	else
	{
		tre_menu.treeCompsXml=null;
	}
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-08
 * 功能：检查输入规则
 * 参数：无
 * 返回值：无
 * 修改记录：
 * 
 */
public function checkAllValue():Boolean
{
	if(this.tnp_ccode.text=="")
	{
		CRMtool.showAlert(ConstsModel.MENU_CCODE_ISNULL,this.tnp_ccode);
		return false;
	}
	else if(this.tnp_cname.text=="")
	{
		CRMtool.showAlert(ConstsModel.MENU_CNAME_ISNULL,this.tnp_cname);
		return false;
	}
	else if(this.dplt_icons.selectedIndex==-1)
	{
		CRMtool.showAlert(ConstsModel.MENU_IIMAGE_ISNULL,this.tnp_cname);
		return false;
	}
	else if(this.rbtgn_syln.selectedValue ==null)
	{
		CRMtool.showAlert(ConstsModel.MENU_ITYPE_ISNULL,null);
		return false;
	}
	else if (this.rbtgn_syln.selectedValue==1)
	{
		if (StringUtil.trim(this.tnp_sys.tnp_text.text)=="")
		{
			CRMtool.showAlert(ConstsModel.MENU_IFUNCREGEDIT_ISNULL,null);
			return false;
		}
	}
	else if (this.rbtgn_syln.selectedValue==0)
	{
		   if (StringUtil.trim(this.tnp_link.text)=="")
		   {
		       CRMtool.showAlert(ConstsModel.MENU_CPROGRAM_ISNULL,null);
		       return false;
		   }
	}
	else if(this.rbtgn_shpo.selectedValue ==null)
	{
		CRMtool.showAlert(ConstsModel.MENU_IOPENTYPE_ISNULL,null);
		return false;
	}
	else if(this.rbtgn_shhi.selectedValue ==null)
	{
		CRMtool.showAlert(ConstsModel.MENU_BSHOW_ISNULL,null);
		return false;
	}
	
	if(CRMtool.isStringNotNull(this.tnp_irfuncregedit.tnp_text.text))
	{
		if(CRMtool.isStringNull(this.tnp_crname.text))
		{
			CRMtool.showAlert("相关程序的名称不能为空！",this.tnp_crname);
			return false;	
		}
	}
	if(operType=="onEdit")
	{
		if(!tre_menu.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.MENU_CHOOSE);
			return false;
		}
		else
		{
			if (tre_menu.selectedItem.@ccode!=this.tnp_ccode.text)
			{
				var isExistsCcode:Boolean=tre_menu.isExistsCcode(tnp_ccode.text,ConstsModel.MENU_CCODE_WARNMSG);
				if(isExistsCcode)
				{
					return false;
				}		
			}
		}
	}
	if(operType=="onNew")
	{
		if(tre_menu.isExistsCcode(tnp_ccode.text,ConstsModel.MENU_CCODE_WARNMSG))
		{
			return false;
		}
	}
	if(!tre_menu.isExistsParent(tnp_ccode.text,ConstsModel.MENU_PID_WARNMSG))
	{
		return false;
	}
	return true;
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-04
 * 功能： 增加菜单初始化项目值
 * 参数：@focus：设置焦点
 * 返回值：菜单
 * 修改记录：
 */
public function InitItems(focus:Boolean):void
{
	this.tnp_ccode.text="";
	this.tnp_cname.text="";
	this.rbtn_sys.value=1;
	this.rbtn_sys.selected=true;
	this.rbtn_link.value=0;
	this.rbtn_link.selected=false;
	this.rbtn_menu.value=2;
	this.rbtn_menu.selected=false;
	this.rbtn_sheet.value=1;
	this.rbtn_sheet.selected=true;
	this.rbtn_popup.value=0;
	this.rbtn_popup.selected=false;
	this.rbtn_show.value=1;
	this.rbtn_show.selected=true;
	this.rbtn_hide.value=0;
	this.rbtn_hide.selected=false;
	this.tnp_link.text="";
	this.tnp_sys.tnp_text.text="";
	this.tnp_cparameter.text="";
	this.tnp_sys.value=null;
	this.dplt_icons.selectedIndex=0;
    tnp_irfuncregedit.tnp_text.text="";
    tnp_irfuncregedit.value = null;
	if (focus)
	{
		this.tnp_ccode.setFocus();
	}
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-04
 * 功能： 封装菜单值
 * 参数：无
 * 返回值：菜单
 * 修改记录：
 */
public function getMenuItem():AsMenuVo
{
	if(this.operType=="onEdit")
	{
		asMenuVo.iid =  int(Number(this.tre_menu.selectedItem.@iid));
		asMenuVo.oldCcode=this.tre_menu.selectedItem.@ccode;
	}
	asMenuVo.ipid = this.tre_menu.getIpid(this.tnp_ccode.text);
	asMenuVo.ccode = this.tnp_ccode.text;
	asMenuVo.cname = this.tnp_cname.text;
	asMenuVo.iimage=this.dplt_icons.selectedItem.value;
	asMenuVo.itype = int(Number(this.rbtgn_syln.selectedValue));
	asMenuVo.iopentype = int(Number(this.rbtgn_shpo.selectedValue));
	asMenuVo.cprogram = this.tnp_link.text;
	if (StringUtil.trim(this.tnp_sys.tnp_text.text)=="")
	{
		asMenuVo.ifuncregedit = null;
	}
	else
	{
		asMenuVo.ifuncregedit = this.tnp_sys.value.toString();
	}
	asMenuVo.bshow = this.rbtn_show.selected==true?1:0;
	asMenuVo.cparameter=this.tnp_cparameter.text;
	asMenuVo.crname = this.tnp_crname.text;
    asMenuVo.imenup = main_menu.selectedItem.@iid;
	if (StringUtil.trim(this.tnp_irfuncregedit.tnp_text.text)=="")
	{
		asMenuVo.irfuncregedit = null;
	}
	else
	{
		asMenuVo.irfuncregedit = this.tnp_irfuncregedit.value.toString();
	}
	return asMenuVo;
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-04
 * 功能：刷新树节点
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function updateTreeItem():void
{
	switch(operType)
	{
		case "onNew":
		{
			tre_menu.AddTreeNode(asMenuVo);				
			break;
		}
		case "onEdit":
		{
			var curxml:XML = this.tre_menu.selectedItem as XML;
			var ccode:String = curxml.@ccode; //原选中编码
			tre_menu.EditTreeNode(asMenuVo);
			//修改操作保存，设定为新节点值
			this.tnp_ccode.text=asMenuVo.ccode;
			this.tnp_cname.text=asMenuVo.cname;
			this.rbtn_sys.value=(asMenuVo.itype==1);
			this.rbtn_sys.selected=this.rbtn_sys.value;
			this.rbtn_link.value=!this.rbtn_sys.value;
			this.rbtn_link.selected=this.rbtn_link.value;
			this.rbtn_sheet.value=(asMenuVo.iopentype==1);
			this.rbtn_sheet.selected=this.rbtn_sheet.value;
			this.rbtn_popup.value=!this.rbtn_sheet.value;
			this.rbtn_popup.selected=this.rbtn_popup.value;
			this.rbtn_show.value=(asMenuVo.bshow==true?1:0);
			this.rbtn_show.selected=asMenuVo.bshow;
			this.rbtn_hide.value=(asMenuVo.bshow==false?1:0);
			this.rbtn_hide.selected=!asMenuVo.bshow;
			this.tnp_sys.value=asMenuVo.ifuncregedit;
			this.get_cname_FuncregeditByID();
			this.tnp_link.text=asMenuVo.cprogram;
			this.dplt_icons.selectedIndex=asMenuVo.iimage-1;
			break;
		}
		case "onDelete":
		{
			tre_menu.DeleteTreeNode();
			break;
		}
	}
}

/**
 *
 * 函数名：InitSelItems
 * 作者：刘磊
 * 日期：2011-08-04
 * 功能：修改操作放弃，恢复为树节点选中值
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function InitSelItems():void
{
	if (this.tre_menu.selectedItem!=null)
	{
		this.tnp_ccode.text=this.tre_menu.selectedItem.@ccode;
		this.tnp_cname.text=this.tre_menu.selectedItem.@cname;
		this.rbtn_sys.value=(this.tre_menu.selectedItem.@itype==1);
		this.rbtn_sys.selected=this.rbtn_sys.value;
		this.rbtn_link.value=(this.tre_menu.selectedItem.@itype==0);
		this.rbtn_link.selected=this.rbtn_link.value;
		this.rbtn_sheet.value=(this.tre_menu.selectedItem.@iopentype==1);
		this.rbtn_sheet.selected=this.rbtn_sheet.value;
		this.rbtn_popup.value=(this.tre_menu.selectedItem.@iopentype==0);
		this.rbtn_popup.selected=this.rbtn_popup.value;
		this.rbtn_show.value=(this.tre_menu.selectedItem.@bshow==true);
		this.rbtn_show.selected=this.rbtn_show.value;
		this.rbtn_hide.value=(this.tre_menu.selectedItem.@bshow==false);
		this.rbtn_hide.selected=this.rbtn_hide.value;
		this.tnp_sys.value=this.tre_menu.selectedItem.@ifuncregedit;
		this.get_cname_FuncregeditByID();
		this.tnp_link.text=this.tre_menu.selectedItem.@cprogram;
		this.dplt_icons.selectedIndex=this.tre_menu.selectedItem.@iimage-1;
	}
	else
	{
		this.InitItems(false);
	}
}

/**
 *
 * 函数名：lbr_toolbar_itemClickHandler
 * 作者：刘磊
 * 日期：2011-08-04
 * 功能：工具栏按钮点击事件处理
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function lbr_toolbar_itemClickHandler(event:ItemClickEvent):void
{
	var enabled:Boolean;
	var node:Object=this.tre_menu.selectedItem;
	
	switch(event.item.name)
	{
		case "onNew":{enabled=true;operType=event.item.name;this.InitItems(true);break;}
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
				if(this.tre_menu.isExistsChild(ccode,ConstsModel.MENU_ROMEVE_PID))
				{
					return;
				}
				removeTreeXml(this.tre_menu.selectedItem,operType);
			}
			break;}
		case "onEdit":{
			if (node==null)
			{
				CRMtool.showAlert(ConstsModel.MENU_CHOOSE);
				return;
			}
			else
			{
				enabled=true;operType=event.item.name;break;
			}
		}
		case "onSave":{
			enabled=false;
			if (this.checkAllValue())
			{
				saveTreeXml(getMenuItem(),operType);
			}
			else
			{
				return;
			}
			break;
		}
		case "onGiveUp":{
			if (operType=="onNew")
			{
				//增加操作放弃，恢复为初始化值
				this.InitItems(false);
			}
			else if (operType=="onEdit")
			{
				this.InitSelItems();
			}
            operType = "onGiveUp";
			enabled=false;break;
		}
	}
	//调用按钮互斥
	CRMtool.toolButtonsEnabled(lbr_toolbar,event.item.name)
	//调用统一设置BorderContainer容器内控件enabled属性
	CRMtool.containerChildsEnabled(container,enabled);
	//互斥灰化系统程序或链接程序
	rbtn_sys_clickHandler();
	//参照不允许编辑
	this.tnp_sys.tnp_text.editable=false;
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-08 
 * 功能：增加或修改树节点保存
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function saveTreeXml(menuVo:AsMenuVo,operType:String):void
{
	switch(operType)
	{
		case "onNew":{	AccessUtil.remoteCallJava("MenuDest","addMenu",saveTreecallBackHandler,menuVo,ConstsModel.MENU_ADD_INFO);break;}
		case "onEdit":{AccessUtil.remoteCallJava("MenuDest","updateMenu",saveTreecallBackHandler,menuVo,ConstsModel.MENU_UPDATE_INFO);break;}
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-08 
 * 功能：增加或修改树节点保存回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function saveTreecallBackHandler(event:ResultEvent):void
{
	if(event.result || event.result.toString()!="fail")
	{
		var result:String = event.result as String;
		
		if(this.operType =="onNew")
		{
			asMenuVo.iid=int(Number(result));
			CRMtool.tipAlert(ConstsModel.MENU_ADD_SUCCESS);
		}
		else if(this.operType=="onDelete")
		{
			CRMtool.tipAlert(ConstsModel.MENU_REMOVE);
		}
		else if(this.operType=="onEdit")
		{
			CRMtool.tipAlert(ConstsModel.MENU_UPDATE_SUCCESS);
		}
		this.updateTreeItem();
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.MENU_FAIL);
	}

    operType = "onGiveUp";
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-08 
 * 功能：删除树节点保存
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function onDeleteTree():void
{
	AccessUtil.remoteCallJava("MenuDest","deleteMenu",saveTreecallBackHandler,iid,ConstsModel.MENU_REMOVE_INFO);
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-08 
 * 功能：删除树节点保存回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function removeTreeXml(node:Object,operType:String):void
{
	iid =int(Number(node.@iid));
	CRMtool.tipAlert(ConstsModel.MENU_DETERMINE_HEAD+node.@ccname+ConstsModel.MENU_DETERMINE_TAIL,null,"AFFIRM",this,"onDeleteTree");
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-08 
 * 功能：互斥灰化系统程序或链接程序
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
protected function rbtn_sys_clickHandler():void
{
	   this.tnp_sys.enabled=this.rbtn_sys.selected;
	   this.tnp_link.enabled=!this.tnp_sys.enabled;
	   if (this.rbtn_menu.selected)
	   {
		   this.tnp_sys.enabled=false;
		   this.tnp_link.enabled=false;
	   }
	   this.tnp_cparameter.enabled=!this.rbtn_menu.selected;
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-30
 * 功能：获得系统程序名称
 * 参数：无
 * 返回值：String
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function get_cname_FuncregeditByID():void
{
	
	if(this.tre_menu.selectedItem != null){
		
		if (this.tre_menu.selectedItem.@ifuncregedit=="")
		{
			this.tnp_sys.tnp_text.text="";
		}
		else
		{
			AccessUtil.remoteCallJava("FuncregeditDest","get_cname_FuncregeditByID",Funcregedit_callBackHandler,Number(this.tre_menu.selectedItem.@ifuncregedit),null,false);
		}
	}
}


public function Funcregedit_callBackHandler(event:ResultEvent):void
{
	if (event.result)
	{
	    this.tnp_sys.tnp_text.text=event.result.toString();
	}
	else
	{
		this.tnp_sys.tnp_text.text="";
	}
	
	if (this.tre_menu.selectedItem.@irfuncregedit=="")
	{
		this.tnp_irfuncregedit.tnp_text.text="";
	}
	else
	{
		AccessUtil.remoteCallJava("FuncregeditDest","get_cname_FuncregeditByID",rFuncregedit_callBackHandler,Number(this.tre_menu.selectedItem.@irfuncregedit),null,false);
	}
}

public function rFuncregedit_callBackHandler(event:ResultEvent):void
{
	if (event.result)
	{
		this.tnp_irfuncregedit.tnp_text.text=event.result.toString();
	}
	else
	{
		this.tnp_irfuncregedit.tnp_text.text="";
	}
}

//窗体初始化
public function onWindowInit():void
{
	
}

//窗体打开
public function onWindowOpen():void
{
    this.getTreeXml();
	InitItems(false);
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}
