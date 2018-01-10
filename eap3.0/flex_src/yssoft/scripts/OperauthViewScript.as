import flash.events.Event;

import mx.accessibility.TreeAccImpl;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;

import yssoft.comps.TreeCompsVbox;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.OperauthVo;

[Bindable]
public  var roleTreeXml:XML = null;

[Bindable]
public var authcontentTreeXml:XML = null;

[Bindable]
public var operauthVoTreeXml:XML = null;

private var operauth:OperauthVo = new OperauthVo();;

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
private function initTree():void
{
	AccessUtil.remoteCallJava("asOperauthDest","queryTree",callBackHandler); 
}

private function callBackHandler(event:ResultEvent):void
{
	if(event.result.roleTree!=null)
	{
		roleTreeXml = new XML(event.result.roleTree as String); 
	/*	this.tre_authcontent.treeCompsXml =roleTreeXml;*/
	}
	if(event.result.authcontentTree!=null)
	{
		authcontentTreeXml =new XML(event.result.authcontentTree as String);
		/*this.tre_authcontent.treeCompsXml = authcontentTreeXml;*/
	}
	CRMtool.toolButtonsEnabled(this.lbr_operauth,null,this.roleTreeXml.length());
}

/**
 *
 * 函数名：
 * 作者：钟晶
 * 日期：2011-08-02
 * 功能： 树的change事件
 * 参数：无
 * 返回值：角色
 * 修改记录：
 * 
 */
public function tre_role_changeHandler(event:ListEvent):void
{
	if(this.tre_role.selectedItem)
	{
		this.titile.text=ConstsModel.ROLE_LABLE+":"+this.tre_role.selectedItem.@cname;
	}
	AccessUtil.remoteCallJava("asOperauthDest","getAsOperauthVoByIrole",getAsOperauthVoByIrolechangeHandler,int(Number(this.tre_role.selectedItem.@iid))); 
}

public function getAsOperauthVoByIrolechangeHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		operauthVoTreeXml = new XML(event.result);
		this.tre_authcontent.treeCompsXml= operauthVoTreeXml;
		
		for each(var item:Object in this.tre_authcontent.treeCompsXml.descendants("*")){
			if(item.@state=="1")
			{
				item[this.tre_authcontent.checkBoxStateField]=1;
			}
		}
	}
	else
	{
		this.tre_authcontent.treeCompsXml = authcontentTreeXml;
		for each(var item:Object in this.tre_authcontent.treeCompsXml.descendants("*")){
			if(item.@state!="1")
			{
				item[this.tre_authcontent.checkBoxStateField]=0;
			}
		}
	}
	this.tre_authcontent.visible = true;
}



private function getRolesB():ArrayCollection{
	var tmpAr:ArrayCollection=new ArrayCollection();
	for each(var item:Object in this.tre_authcontent.treeCompsXml.descendants("*")){
		var checked:String=item[tre_authcontent.checkBoxStateField];
		if(checked !='' && checked =='1'){
			var operauth:OperauthVo = new OperauthVo();
			operauth.coperauth = item.@coperauth;
			operauth.irole = this.tre_role.selectedItem.@iid;
			tmpAr.addItem(operauth);
		}
	}
	return tmpAr;
}

private var itemType:String;
public function onEdit(event:Event):void
{
	if(!this.tre_role.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	this.tre_role.enabled= false;
	this.itemType ="onEdit";
	CRMtool.toolButtonsEnabled(this.lbr_operauth,"onEdit",roleTreeXml.length());
}

public function onSave(event:Event):void
{
	var item:ArrayCollection = this.getRolesB();
	AccessUtil.remoteCallJava("asOperauthDest","addOperauth",onSaveHandler,item); 
}

public function onSaveHandler(event:ResultEvent):void
{
	var result:String = event.result as String;
	if(result=="fail")
	{
		CRMtool.tipAlert("保存失败");
	}
	else
	{
		CRMtool.tipAlert("保存成功");
	}
	this.tre_role.enabled = true;
}

public function onGiveUp(event:Event):void
{
	for each(var item:Object in this.tre_authcontent.treeCompsXml.descendants("*")){
		if(item.@STATE=="1")
		{
			item[this.tre_authcontent.checkBoxStateField]=1;
		}
	}
	CRMtool.toolButtonsEnabled(this.lbr_operauth,"onGiveUp",roleTreeXml.length());
	this.tre_role.enabled = true;
	
}