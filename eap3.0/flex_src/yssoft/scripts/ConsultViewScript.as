/**
 *
 * @author：liu_lei
 * 日期：2011-8-12
 * 功能：
 * 修改记录：
 *
 */
import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.TextInput;
import mx.events.ItemClickEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ArrayUtil;
import mx.utils.ObjectUtil;
import mx.utils.StringUtil;

import yssoft.models.*;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.*;

[Bindable]
public var ifieldtypeArr:ArrayCollection=new ArrayCollection();
[Bindable]
public var operType:String;

//工具栏初始化值
[Bindable]
public var lbrItem:ArrayCollection=new ArrayCollection([
	{label:"增加",name:"onNew"	},
	{label:"修改",name:"onEdit"},
	{label:"删除",name:"onDelete"	},
	{label:"保存",name:"onSave"},
	{label:"放弃",name:"onGiveUp"},
	{label:"更新",name:"onRefresh"}
]);

//主键		
public var iid:int;
//表头VO
[Bindable]
public var acConsultsetVo:AcConsultsetVo=new AcConsultsetVo();
//表体VO
public var acConsultclmVo:AcConsultclmVo;
//表体集
[Bindable]
public var resultArr:ArrayCollection=new ArrayCollection();

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-12
 * 功能：树初始化操作
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getTreeXml():void
{
	AccessUtil.remoteCallJava("ConsultDest","getAllAcConsultset",callBackHandler); 
}


/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-12 
 * 功能：树初始化操作回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public var treeCompsXmlBase:XML;

public function callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		treeCompsXmlBase = new XML(event.result as String);
		this.tre_tree.treeCompsXml = new XML(event.result as String);
		AccessUtil.remoteCallJava("ConsultDest","getDataType",getDataType_callBackHandler); 
	}
	else
	{
		this.tre_tree.treeCompsXml=null;
	}
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

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-18
 * 功能：获得表体数据
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getBodyData():void
{
	var iid:String=this.tre_tree.selectedItem.@iid.toString();
	AccessUtil.remoteCallJava("ConsultDest","getAcConsultsetByID",sqlData_callBackHandler,iid,null,false);
	AccessUtil.remoteCallJava("ConsultDest","getAcConsultclmByPID",bodyData_callBackHandler,iid,null,false);
}
/**
 * 
 * 作者：liu_lei
 * 日期：2012-06-11
 * 功能：获得表头sql回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function sqlData_callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		acConsultsetVo=event.result[0] as AcConsultsetVo;
	}
}
/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-18
 * 功能：获得表体数据回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function bodyData_callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		resultArr=event.result as ArrayCollection;
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-16
 * 功能：SQL语句校验
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function CheckSql():void
{
	var sqlstr:String;
	switch(getitype())
	{
		case "0":{
			sqlstr=this.tnp_ctreesql.text;
			
			break;
		}
		case "1":{
			sqlstr=this.tnp_cgridsql.text.toLowerCase().replace("@join","").replace("@childsql","");
			sqlstr=sqlstr.replace("@childsql","");
			break;
		}
		case "2":{
			sqlstr=this.tnp_cgridsql.text.toLowerCase().replace("@join",this.tnp_cconnsql.text.toLowerCase().replace("@value","'%'"));
			sqlstr=sqlstr.replace("@childsql","");
			break;
		}
	}
	if(this.txt_order.text!=null && this.txt_order.text!=""){
		sqlstr+=this.txt_order.text;
	}
	AccessUtil.remoteCallJava("ConsultDest","getDAODataType",checkSql_callBackHandler,sqlstr);
}
//wtf add
public function saveCheckSql():void{
	var sqlstr:String;
	switch(getitype())
	{
		case "0":{
			sqlstr=this.tnp_ctreesql.text;
			
			break;
		}
		case "1":{
			sqlstr=this.tnp_cgridsql.text.toLowerCase().replace("@join","").replace("@childsql","");
			sqlstr=sqlstr.replace("@childsql","");
			break;
		}
		case "2":{
			sqlstr=this.tnp_cgridsql.text.toLowerCase().replace("@join",this.tnp_cconnsql.text.toLowerCase().replace("@value","'%'"));
			sqlstr=sqlstr.replace("@childsql","");
			break;
		}
	}
	if(this.txt_order.text!=null && this.txt_order.text!=""){
		sqlstr+=this.txt_order.text;
	}
	AccessUtil.remoteCallJava("ConsultDest","getDAODataType",saveCheckSql_callBackHandler,sqlstr);
}
//wtf add
public function saveCheckSql_callBackHandler(event:ResultEvent):void{
	var enabled:Boolean;
	if (event.result.hasOwnProperty("success")){
		if (this.checkAllValue())
		{
			if (this.tnp_ccode.text.indexOf(".")>-1)
			{ 
				if (this.resultArr.length==0)
				{
					CRMtool.tipAlert(ConstsModel.CONSULT_REFRESHERR);
					return;
				}
			}
			saveTreeXml(getTreeItem(),operType);
			enabled=false;
		}
		else
		{
			return;
		}
		CRMtool.toolButtonsEnabled(lbr_toolbar,"onSave");
		//调用统一设置BorderContainer容器内控件enabled属性
		CRMtool.containerChildsEnabled(container,enabled);
		if (enabled && operType=="onNew")
		{
			this.InitItems(true);
		}
		if (enabled && operType=="onEdit")
		{
			tnp_ccode_changeHandler(event);
		}
		//参照(不)允许编辑
		this.tnp_ifuncregedit.tnp_text.editable=true;
	}else{
		CRMtool.showAlert(String(event.result.exception));
	}
}
/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-16 
 * 功能：SQL语句校验
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function checkSql_callBackHandler(event:ResultEvent):void
{
	if (event.result.hasOwnProperty("success"))
	{
		var arrtmp:ArrayCollection=event.result.success as ArrayCollection;
		if (arrtmp.length==0)
		{
			CRMtool.showAlert(ConstsModel.CONSULT_NULLSTATEERR);
			return;
		}
		var newArr:ArrayCollection=new ArrayCollection();
		for (var i:int = 0; i < arrtmp.length; i++) 
		{
			acConsultclmVo=new AcConsultclmVo();
			acConsultclmVo.ino=i+1;
			var cfield:String=arrtmp[i].fieldname;
			var type:String=arrtmp[i].fieldtype;
			var value:String=arrtmp[0][cfield];
			this.acConsultclmVo.cfield=cfield;
			var ifieldtype:int= CRMtool.GetDataTypeIid(type);
			this.acConsultclmVo.ifieldtype=ifieldtype;
			this.acConsultclmVo.ialign=(ifieldtype==1||ifieldtype==2?2:0);
			this.acConsultclmVo.bshow=1;
			this.acConsultclmVo.bsearch=(ifieldtype==0?1:0);
			this.acConsultclmVo.icolwidth=100;
			this.acConsultclmVo.ccaption=cfield;
			this.acConsultclmVo.cnewcaption=cfield;
			newArr.addItem(this.acConsultclmVo);
		}
		CRMtool.dosqlfields(this.resultArr,newArr);
	}
	else
	{
		CRMtool.showAlert(String(event.result.exception));
	}
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-12
 * 功能：检查输入规则
 * 参数：无
 * 返回值：无
 * 修改记录：
 * 
 */
public function checkAllValue():Boolean
{
	if (this.tnp_ccode.text.split(".").length>2)
	{
		CRMtool.showAlert(ConstsModel.CONSULT_CCODE_OVER,this.tnp_ccode);
		return false;
	}
	if(this.tnp_ccode.text=="")
	{
		CRMtool.showAlert(ConstsModel.CONSULT_CCODE_ISNULL,this.tnp_ccode);
		return false;
	}
	else if(this.tnp_cname.text=="")
	{
		CRMtool.showAlert(ConstsModel.CONSULT_CNAME_ISNULL,this.tnp_cname);
		return false;
	}
	else
	{
		if (this.tnp_ccode.text.indexOf(".")>-1)
		{
			/*if(this.tnp_ifuncregedit.tnp_text.text=="")
			{
				CRMtool.showAlert(ConstsModel.CONSULT_IFUNCREGEDIT_ISNULL,this.tnp_ifuncregedit);
				return false;
			}
			else*/ 
			if(this.rbtgn_sql.selectedValue==null)
			{
				CRMtool.showAlert(ConstsModel.CONSULT_ITYPE_ISNULL,null);
				return false;
			}
			else if (this.rbtn_ctreesql.selected==true && this.tnp_ctreesql.text=="")
			{
				CRMtool.showAlert(ConstsModel.CONSULT_TREESQL_ISNULL,null);
				return false;
			}
			else if (this.rbtn_cgridsql.selected==true && this.tnp_cgridsql.text=="")
			{
				CRMtool.showAlert(ConstsModel.CONSULT_GRIDSQL_ISNULL,null);
				return false;
			}
			else if (this.rbtn_cgridsql2.selected==true && this.tnp_cgridsql.text=="")
			{
				CRMtool.showAlert(ConstsModel.CONSULT_GRIDSQL_ISNULL,null);
				return false;
			}
			else if (this.rbtn_cconnsql.selected==true && (this.tnp_ctreesql.text==""||this.tnp_cgridsql.text==""||this.tnp_cconnsql.text==""))
			{
				CRMtool.showAlert(ConstsModel.CONSULT_CONNSQL_ISNULL,null);
				return false;
			}
			else
			{
			    var cgridsql:String=this.tnp_cgridsql.text.toLowerCase();
			    if (this.rbtn_cconnsql.selected==true && cgridsql.indexOf("@join")==-1)
			    {
				   CRMtool.showAlert(ConstsModel.CONSULT_JOINERR_ISNULL,null);
				   return false;
			    }
				else
				{
					var cconnsql:String=this.tnp_cconnsql.text.toLowerCase();
					if (this.rbtn_cconnsql.selected==true && cconnsql.indexOf("@value")==-1)
					{
						CRMtool.showAlert(ConstsModel.CONSULT_VALUEERR_ISNULL,null);
						return false;
					}
				}
			}
		}
	}
	if(operType=="onEdit")
	{
		if(!tre_tree.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.CONSULT_CHOOSE);
			return false;
		}
		else
		{
			if (tre_tree.selectedItem.@ccode!=this.tnp_ccode.text)
			{
				var isExistsCcode1:Boolean=tre_tree.isExistsCcode(tnp_ccode.text,ConstsModel.CONSULT_CCODE_WARNMSG);
				if(isExistsCcode1)
				{
					return false;
				}		
			}
		}
	}
	if(operType=="onNew")
	{
		var isExistsCcode2:Boolean=tre_tree.isExistsCcode(tnp_ccode.text,ConstsModel.CONSULT_CCODE_WARNMSG);
		if(isExistsCcode2)
		{
			return false;
		}
	}
	if(!tre_tree.isExistsParent(tnp_ccode.text,ConstsModel.CONSULT_PID_WARNMSG))
	{
		return false;
	}
	return true;
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-12
 * 功能： 增加参照配置初始化项目值
 * 参数：@focus：设置焦点
 * 返回值：菜单
 * 修改记录：
 */
public function InitItems(focus:Boolean):void
{
	this.tnp_ccode.text="";
	this.tnp_cname.text="";
	this.tnp_ifuncregedit.tnp_text.text="";
	this.tnp_ifuncregedit.value="";
	this.tnp_ctreesql.text="";
	this.tnp_cgridsql.text="";
	this.tnp_cconnsql.text="";
	this.tnp_ctreesql.editable=false;
	this.tnp_cgridsql.editable=false;
	this.tnp_cconnsql.editable=false;
	this.rbtn_ctreesql.selected=false;
	this.rbtn_cgridsql.selected=false;
	this.rbtn_cgridsql2.selected=false;
	this.rbtn_cconnsql.selected=false;
    this.tnp_bdataauth.selected=false;
	this.tnp_ballowmulti.selected=false;
	if (focus)
	{
	    this.tnp_ccode.setFocus();
	}
	this.resultArr.removeAll();
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-12
 * 功能：封装树节点值
 * 参数：无
 * 返回值：菜单
 * 修改记录：
 */
public function getTreeItem():AcConsultsetVo
{
	if(this.operType=="onEdit")
	{
		acConsultsetVo.iid =  int(Number(this.tre_tree.selectedItem.@iid));
		acConsultsetVo.oldCcode=this.tre_tree.selectedItem.@ccode;
	}
		
	acConsultsetVo.ipid = this.tre_tree.getIpid(this.tnp_ccode.text);
	acConsultsetVo.ccode = this.tnp_ccode.text;
	acConsultsetVo.cname = this.tnp_cname.text;
	if (StringUtil.trim(this.tnp_ifuncregedit.tnp_text.text)=="")
	{
		acConsultsetVo.ifuncregedit = null;
	}
	else
	{
		acConsultsetVo.ifuncregedit = this.tnp_ifuncregedit.value.toString();
	}
	acConsultsetVo.itype = getitype();
	acConsultsetVo.ctreesql=this.tnp_ctreesql.text;
	acConsultsetVo.cgridsql=this.tnp_cgridsql.text;
	acConsultsetVo.cconnsql=this.tnp_cconnsql.text;
	acConsultsetVo.bdataauth=this.tnp_bdataauth.selected;
	acConsultsetVo.ballowmulti=this.tnp_ballowmulti.selected;
	acConsultsetVo.cordersql = this.txt_order.text;
	return acConsultsetVo;
}

/**
 *
 * 函数名：
 * 作者：刘磊
 * 日期：2011-08-12
 * 功能：刷新树节点
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function updateTreeItem():void
{
	//getTreeXml();
	switch(operType)
	{
		case "onNew":
		{
			var treenode1:AcConsultsetVo=CRMtool.ObjectCopy(acConsultsetVo);
			treenode1.ctreesql="";
			treenode1.cgridsql="";
			treenode1.cconnsql="";
			this.setrbtns(treenode1.itype);
			tre_tree.AddTreeNode(treenode1);
			break;
		}
		case "onEdit":
		{
			var treenode2:AcConsultsetVo=CRMtool.ObjectCopy(acConsultsetVo);
			treenode2.ctreesql="";
			treenode2.cgridsql="";
			treenode2.cconnsql="";		
			
			//getTreeXml();
			tre_tree.EditTreeNode(treenode2);
			//修改操作保存，设定为新节点值
			this.tnp_ccode.text=acConsultsetVo.ccode;
			this.tnp_cname.text=acConsultsetVo.cname;
			this.tnp_ifuncregedit.value=acConsultsetVo.ifuncregedit;
			this.get_cname_FuncregeditByID();
			this.setrbtns(acConsultsetVo.itype);
			this.tnp_ctreesql.text=acConsultsetVo.ctreesql;
			this.tnp_cgridsql.text=acConsultsetVo.cgridsql;
			this.tnp_cconnsql.text=acConsultsetVo.cconnsql;		
			this.tnp_bdataauth.selected=acConsultsetVo.bdataauth;
			this.tnp_ballowmulti.selected=acConsultsetVo.ballowmulti;
			break;
		}
		case "onDelete":
		{
			//getTreeXml();
			tre_tree.DeleteTreeNode();
			break;
		}
	}
}

/**
 *
 * 函数名：InitSelItems
 * 作者：刘磊
 * 日期：2011-08-12
 * 功能：修改操作放弃，恢复为树节点选中值
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function InitSelItems():void
{
	if (this.tre_tree.selectedItem!=null)
	{
		this.tnp_ccode.text=this.tre_tree.selectedItem.@ccode;
		this.tnp_cname.text=this.tre_tree.selectedItem.@cname;
		this.tnp_ifuncregedit.value=this.tre_tree.selectedItem.@ifuncregedit;
		this.get_cname_FuncregeditByID();
		this.setrbtns(this.tre_tree.selectedItem.@itype);
		this.tnp_ctreesql.text=acConsultsetVo.ctreesql;
		this.tnp_cgridsql.text=acConsultsetVo.cgridsql;
		this.tnp_cconnsql.text=acConsultsetVo.cconnsql;
		this.tnp_bdataauth.selected=(String(this.tre_tree.selectedItem.@bdataauth)=="true");
		this.tnp_ballowmulti.selected=(String(this.tre_tree.selectedItem.@ballowmulti)=="true");
		this.getBodyData();
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
 * 日期：2011-08-12
 * 功能：工具栏按钮点击事件处理
 * 参数：无
 * 返回值：无
 * 修改记录：
 */
public function lbr_toolbar_itemClickHandler(event:ItemClickEvent):void
{	
	var enabled:Boolean;
	var node:Object=this.tre_tree.selectedItem;
	
	switch(event.item.name)
	{
		case "onNew":{
			enabled=true;operType=event.item.name;break;
		}
		case "onDelete":{
			if (node==null)
			{
				CRMtool.showAlert(ConstsModel.CONSULT_CHOOSE);
				return;
			}
			else
			{
				var ccode:String = String(node.@ccode);
				if(this.tre_tree.isExistsChild(ccode,ConstsModel.CONSULT_ROMEVE_PID))
				{
					return;
				}
				operType=event.item.name;
				removeTreeXml(this.tre_tree.selectedItem,operType);
			}
			break;
		}
		case "onEdit":{
			if (node==null)
			{
				CRMtool.showAlert(ConstsModel.CONSULT_CHOOSE);
				return;
			}
			else
			{
				enabled=true;operType=event.item.name;break;
			}
		}
		case "onSave":{
//			wtf mofidfy
//				saveCheckSql();
  				if (this.checkAllValue())
				{
					if (this.tnp_ccode.text.indexOf(".")>-1)
					{ 
						if(!checkOrderSql()){
							CRMtool.tipAlert("排序中没有\"order by\"语句");
							return;
						}
						if (this.resultArr.length==0)
						{
						    CRMtool.tipAlert(ConstsModel.CONSULT_REFRESHERR);
							return;
						}
					}
					saveTreeXml(getTreeItem(),operType);
					enabled=false;
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
			enabled=false;break;
		}
	}
	
	if (event.item.name=="onRefresh")
	{
		if (operType=="onNew"||operType=="onEdit")
		{
			if (this.checkAllValue())
			{
			   this.CheckSql();
			}
		}
		else
		{
			CRMtool.tipAlert(ConstsModel.CONSULT_EDITSTATEERR);
		}
	}
	else
	{
		//wtf modify
//		if(event.item.name=="onSave"){
//			return;
//		}
		//调用按钮互斥
		CRMtool.toolButtonsEnabled(lbr_toolbar,event.item.name)
		//调用统一设置BorderContainer容器内控件enabled属性
		CRMtool.containerChildsEnabled(container,enabled);
		if (enabled && operType=="onNew")
		{
			this.InitItems(true);
		}
		if (enabled && operType=="onEdit")
		{
			tnp_ccode_changeHandler(event);
		}
		//参照(不)允许编辑
		this.tnp_ifuncregedit.tnp_text.editable=true;
	}
}

// wtf add
public function checkOrderSql():Boolean{
	var orderSql:String = txt_order.text;
	var checkSql1:String = "order by";
	var checkSql2:String = "order";
	var checkSql3:String = "by";
	var checkSql4:String = "order by";
	if(orderSql.toLowerCase().indexOf(checkSql1)>=0||orderSql.replace(" ","")==""){
		return true;
	}else if(orderSql.toLowerCase().indexOf(checkSql2)>=0&&orderSql.toLowerCase().indexOf(checkSql3)>=0&&orderSql.toLowerCase().indexOf(checkSql4)!=-1){
		return true;
	}
	return false;
}
//lr add
private function backTree():void{
	if(tre_tree.treeCompsXml!=treeCompsXmlBase){
		var selectedItemObj:Object = tre_tree.selectedItem;
		var iidForSearch:String = selectedItemObj.@iid;
		if(selectedItemObj){
			tre_tree.treeCompsXml = treeCompsXmlBase;
			tre_tree.expandAll();
			
//			tre_tree.selectedItem = selectedItemObj;
			//lzx add 将selectedItem变为treeCompsXmlBase中的对象（原来不是）
			var list:XMLList = new XMLList();
			list[0] = tre_tree.dataProvider[0];
			this.recursionFindTree(list, iidForSearch);
			
			//wtf add
			tre_tree.scrollToIndex(tre_tree.selectedIndex);
			//wtf end
			
		}
		
	}
}

//递归定位树形节点,要查找的字符就是传入的find  和对应tree的@iid属性  add by lzx
private function recursionFindTree(xmlList:XMLList,find:String):void
{
	for(var i:int=0;i<xmlList.length();i++)
	{
		var childXml:XML =xmlList[i];
		var iid:String = childXml.@iid;
		if(iid != null && iid == find)
		{
			tre_tree.selectedItem = childXml;    //将tree的选中像设定为当前项
			return;
		}else if(tre_tree.dataDescriptor.isBranch(childXml))//如果有子节点,则递归调用本方法
		{
			recursionFindTree(childXml.children(),find);
		}
		
	}
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
public function saveTreeXml(acConsultsetVo:AcConsultsetVo,operType:String):void
{
	var obj:Object=new Object();
	obj.head=acConsultsetVo;
	obj.body=this.resultArr;
	switch(operType)
	{
		case "onNew":{	AccessUtil.remoteCallJava("ConsultDest","addAcConsultset",saveTreecallBackHandler,obj,ConstsModel.CONSULT_ADD_INFO);break;}
		case "onEdit":{AccessUtil.remoteCallJava("ConsultDest","updateAcConsultset",saveTreecallBackHandler,obj,ConstsModel.CONSULT_UPDATE_INFO);break;}
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
	if(event.result.toString()!="false")
	{
		var result:String = event.result as String;
		
		if(this.operType =="onNew")
		{
			acConsultsetVo.iid=int(Number(result));
			CRMtool.tipAlert(ConstsModel.CONSULT_ADD_SUCCESS);
		}
		else if(this.operType=="onDelete")
		{
			CRMtool.tipAlert(ConstsModel.CONSULT_REMOVE);
		}
		else if(this.operType=="onEdit")
		{
			CRMtool.tipAlert(ConstsModel.CONSULT_UPDATE_SUCCESS);
		}
		this.updateTreeItem();
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.CONSULT_FAIL);
	}
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
	this.resultArr.removeAll();
	AccessUtil.remoteCallJava("ConsultDest","deleteAcConsultsetByID",saveTreecallBackHandler,iid,ConstsModel.CONSULT_REMOVE_INFO);
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
	CRMtool.tipAlert(ConstsModel.CONSULT_DETERMINE_HEAD+node.@ccname+ConstsModel.CONSULT_DETERMINE_TAIL,null,"AFFIRM",this,"onDeleteTree");
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-13 
 * 功能：互斥灰化树SQL或列SQL或树列关联SQL
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function rbtn_ctreesql_clickHandler(event:MouseEvent):void
{
	setarea(String(event.currentTarget.value));
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-14 
 * 功能：若录入参照编码为一级节点，仅只能录入参照名称，其他项目禁止录入
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function tnp_ccode_changeHandler(event:Event):void
{
	var enabled:Boolean=true;
	if (this.tnp_ccode.text.indexOf(".")==-1)
	{
		this.tnp_ifuncregedit.enabled=!enabled;
		this.tnp_ctreesql.editable=!enabled;
		this.tnp_cgridsql.editable=!enabled;
		this.tnp_cconnsql.editable=!enabled;
		this.rbtgn_sql.enabled=!enabled;
		this.dgrd_consultclm.enabled=!enabled;
		(lbr_toolbar.getChildAt(5) as mx.controls.Button).enabled=!enabled;   
	}
	else
	{
		this.tnp_ifuncregedit.enabled=enabled;
		this.rbtgn_sql.enabled=enabled;
		this.dgrd_consultclm.enabled=enabled;
		(lbr_toolbar.getChildAt(5) as mx.controls.Button).enabled=enabled;
		setarea(getitype());
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-15 
 * 功能：参照风格SQL录入框互斥方法封装
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
public function setarea(index:String):void
{
	var choice:Boolean=true;
	switch(index)
	{
		case "0":{
			this.tnp_ctreesql.editable=choice;
			this.tnp_cgridsql.editable=!choice;
			this.tnp_cconnsql.editable=!choice;
			break;
		}
		case "1":{
			this.tnp_ctreesql.editable=!choice;
			this.tnp_cgridsql.editable=choice;
			this.tnp_cconnsql.editable=!choice;
			break;
		}
		case "2":{
			this.tnp_ctreesql.editable=choice;
			this.tnp_cgridsql.editable=choice;
			this.tnp_cconnsql.editable=choice;
			break;
		}
		case "3":{
			this.tnp_ctreesql.editable=!choice;
			this.tnp_cgridsql.editable=choice;
			this.tnp_cconnsql.editable=!choice;
			break;
		}
	}
}
/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-14 
 * 功能：参照风格选项按钮互斥方法封装
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
public function setrbtns(index:String):void
{
	var choice:Boolean=true;
	switch(index)
	{
		case "0":{
			this.rbtn_ctreesql.selected=choice;
			this.rbtn_cgridsql.selected=!choice;
			this.rbtn_cconnsql.selected=!choice;
			this.rbtn_cgridsql2.selected=!choice;
			break;
		}
		case "1":{
			this.rbtn_ctreesql.selected=!choice;
			this.rbtn_cgridsql.selected=choice;
			this.rbtn_cconnsql.selected=!choice;
			this.rbtn_cgridsql2.selected=!choice;
			break;
		}
		case "2":{
			this.rbtn_ctreesql.selected=!choice;
			this.rbtn_cgridsql.selected=!choice;
			this.rbtn_cconnsql.selected=choice;
			this.rbtn_cgridsql2.selected=!choice;
			break;
		}
		case "3":{
			this.rbtn_ctreesql.selected=!choice;
			this.rbtn_cgridsql.selected=!choice;
			this.rbtn_cconnsql.selected=!choice;
			this.rbtn_cgridsql2.selected=choice;
			break;
		}
	}
}
/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-15 
 * 功能：获得参照风格选项值
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
public function getitype():String
{
	var index:String;
	if (this.rbtn_ctreesql.selected)
	{
		index="0";
	}
	else
	{
		if (this.rbtn_cgridsql.selected)
		{
			index="1";
		}
		else
		{
			if (this.rbtn_cconnsql.selected)
			{
			   index="2";
			}
			else
			{
				if (this.rbtn_cgridsql2.selected)
				{
					index="3";
				}
			}
		}
	}
	return index;
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-19
 * 功能：数据类型显示文字
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
public function getIfieldtypeLabel(item:Object,icol:int):String
{
	var obj:Object=this.ifieldtypeArr.getItemAt(item.ifieldtype);
	return obj.cname;
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-19
 * 功能：对齐方式显示文字
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
public function getIalignArrLabel(item:Object,icol:int):String
{
	var lbltext:String;
	switch(String(item.ialign))
	{
		case "0":
		{
			lbltext="居左对齐";
			break;
		}
		case "1":
		{
			lbltext="居中对齐";
			break;
		}
		case "2":
		{
			lbltext="居右对齐";
			break;
		}
	}
	return lbltext;
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-29
 * 功能：“'”转“`”SQL
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
/*[Bindable]
public function ExChangeSignSql(sql:String):String
{
	var myPattern:RegExp = /\'/g;
	return sql.replace(myPattern,"`");
}*/

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-29
 * 功能：“`”转“'”SQL
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
[Bindable]
public function ChangeSignSql(sql:String):String
{
	var myPattern:RegExp = /\`/g;
	return sql.replace(myPattern,"'");
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

	if (this.tre_tree.selectedItem.@iid=="")
	{
		this.tnp_ifuncregedit.tnp_text.text="";
	}
	else
	{
	    AccessUtil.remoteCallJava("ConsultDest","getAcConsultsetByID",function (event:ResultEvent):void{
			var param:ArrayCollection  = event.result as ArrayCollection;
			if(param[0].ifuncregedit == null || param[0].ifuncregedit == "") {
				tnp_ifuncregedit.tnp_text.text="";
			}else {
				AccessUtil.remoteCallJava("FuncregeditDest","get_cname_FuncregeditByID",Funcregedit_callBackHandler,Number(param[0].ifuncregedit),null,false);
			}
		},Number(this.tre_tree.selectedItem.@iid),null,false); 
	}
}
public function Funcregedit_callBackHandler(event:ResultEvent):void
{
	if (event.result)
	{
	   this.tnp_ifuncregedit.tnp_text.text=event.result.toString();
	}
	else
	{
		this.tnp_ifuncregedit.tnp_text.text="";
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