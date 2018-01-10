import flash.events.Event;

import mx.controls.Alert;
import mx.rpc.events.ResultEvent;

import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.AuthcontentVo;

[Bindable]
public var tree_xml:XML;

private var itemType:String;
private var authcontentVo:AuthcontentVo= new AuthcontentVo();



/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 保存节点
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function onSave(event:Event):void
{
	if(!this.checkValue())
	{
		return;	
	}
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,itemType,this.tre_authcontent.treeCompsXml.length());
	authcontentVo = new AuthcontentVo();
	authcontentVo = getAuthcontentItem();
	if(itemType=="onNew")
	{
		AccessUtil.remoteCallJava("AsAuthcontentDest","addAuthcontent",saveTreecallBackHandler,authcontentVo,"添加处理中"); 
	}
	else
	{
		AccessUtil.remoteCallJava("AsAuthcontentDest","updateAsAuthcontentVo",saveTreecallBackHandler,authcontentVo,"修改处理中");
	}
}


/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 保存后执行操作
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
private function saveTreecallBackHandler(event:ResultEvent):void
{
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,null,this.tre_authcontent.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,false);
	if(event.result || event.result.toString()!="fail")
	{
		var result:String = event.result as String;
		if(itemType =="onNew")
		{
			authcontentVo.iid =int(Number(event.result));
			this.tre_authcontent.AddTreeNode(authcontentVo);
			CRMtool.tipAlert("新增成功");
		}
		else if(itemType=="onDelete")
		{
			this.tre_authcontent.DeleteTreeNode();
			CRMtool.tipAlert("删除成功");
		}
		else if(itemType=="onEdit")
		{
			this.tre_authcontent.EditTreeNode(authcontentVo);
			CRMtool.tipAlert("修改成功");
		}
		onGiveUp(event);
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.FAIL);
	}
}

/**
 *
 * 函数名：
 * 作者：钟晶
 * 日期：2011-08-02
 * 功能： 检查输入字段
 * 参数：无
 * 返回值：无
 * 修改记录：
 * 
 */
private function checkValue():Boolean
{
	if(this.itemType=="onNew"||(this.itemType==ConstsModel.ONEDIT_LABLE&&this.tre_authcontent.selectedItem.@ccode!=this.tnp_ccode.text))
	{
		if(this.tre_authcontent.isExistsCcode(this.tnp_ccode.text,ConstsModel.ROLE_CCODE_WARNMSG))
		{
			return false;
		}
	}
	
	if(CRMtool.isStringNull(this.tnp_ccode.text))
	{
		CRMtool.tipAlert(ConstsModel.ROLE_CCODE_ISNULL,this.tnp_ccode);
		return false;
	}
	else if(CRMtool.isStringNull(this.tnp_cname.text))
	{
		CRMtool.tipAlert(ConstsModel.ROLE_CNAME_ISNULL,this.tnp_cname);
		return false;
	}
	else if(!this.tre_authcontent.isExistsParent(this.tnp_ccode.text,ConstsModel.ROLE_PID_WARNMSG))
	{
		return false;
	}
	return true;
}


/**
 *
 * 函数名：
 * 作者：钟晶
 * 日期：2011-08-02
 * 功能： 封装角色值
 * 参数：无
 * 返回值：角色
 * 修改记录：
 * 
 */
private function getAuthcontentItem():AuthcontentVo
{
	var authcontentVo:AuthcontentVo = new AuthcontentVo();
	authcontentVo.ccode= this.tnp_ccode.text;
	authcontentVo.cname = this.tnp_cname.text;
	authcontentVo.cmemo = this.tnp_cmemo.text;
	if(this.itemType=="onEdit")
	{
		authcontentVo.iid =  int(Number(this.tre_authcontent.selectedItem.@iid));
		authcontentVo.oldCcode = this.tre_authcontent.selectedItem.@ccode;
	}
	authcontentVo.buse = this.chbx_buse.selected;
	authcontentVo.ipid = this.tre_authcontent.getIpid(this.tnp_ccode.text);
	authcontentVo.coperauth = this.tnp_coperauth.text;
	return authcontentVo;
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：确定删除树
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function onDelete(event:Event):void
{
	this.itemType = "onDelete";
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,itemType,this.tre_authcontent.treeCompsXml.length());
	if(!this.tre_authcontent.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	var ccode:String = this.tre_authcontent.selectedItem.@ccode as String;
	if(this.tre_authcontent.isExistsChild(this.tre_authcontent.selectedItem.@ccode,"该节点存在子节点，不能删除"))
	{
		return;
	}
	CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+this.tre_authcontent.selectedItem.@ccname+"操作权限?",null,"AFFIRM",this,"onDeleteTree");
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：删除树
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function onDeleteTree():void
{
	AccessUtil.remoteCallJava("AsAuthcontentDest","romveAsAuthcontentVo",saveTreecallBackHandler,int(Number(this.tre_authcontent.selectedItem.@iid)),"删除操作权限处理中");
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：树初始化操作
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getAuthcontentTree():void
{
	AccessUtil.remoteCallJava("AsAuthcontentDest","getAsAuthcontentVos",callBackHandler); 
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：封装查询后的结果集
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
private function callBackHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		this.tre_authcontent.treeCompsXml = new XML(event.result as String);
	}
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,null,this.tre_authcontent.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,false);
	//回车替代TAB键
	CRMtool.setTabIndex(this.myBorder);
}

public function onNew(event:Event):void
{
	this.itemType = "onNew";
	this.tnp_ccode.text="";
	this.tnp_cmemo.text="";
	this.tnp_coperauth.text="";
	this.chbx_buse.selected= false;
	this.tre_authcontent.selectedIndex=-1;
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,itemType,this.tre_authcontent.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,true);
}



public function onEdit(event:Event):void
{
	if(!this.tre_authcontent.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	this.itemType = "onEdit";
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,"onEdit",this.tre_authcontent.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,true);
	this.tre_authcontent.enabled = false;
}

public function onGiveUp(event:Event):void
{
	this.tnp_ccode.text="";
	this.tnp_cmemo.text="";
	this.tnp_coperauth.text="";
	this.chbx_buse.selected= false;
	this.tnp_cname.text="";
	CRMtool.toolButtonsEnabled(this.lbr_authcontent,"onGiveUp",this.tre_authcontent.treeCompsXml.length());
	CRMtool.containerChildsEnabled(this.myBorder,false);
	this.tre_authcontent.enabled = true;
}