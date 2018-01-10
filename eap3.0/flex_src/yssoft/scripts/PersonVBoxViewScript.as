import flash.display.DisplayObject;
import flash.events.Event;
import flash.net.getClassByAlias;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.FlexGlobals;
import mx.events.ItemClickEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.consultsets.ConsultsetSet;
import yssoft.views.sysmanage.AssemblyQueryclmView;
import yssoft.vos.ListclmVo;
import yssoft.vos.ListsetVo;


[Bindable]
private var acListsetVo:ListsetVo=new ListsetVo();

[Bindable]
private var acListclmVos:ArrayCollection = new ArrayCollection();

[Bindable]
private var personArr:ArrayCollection = new ArrayCollection();

private var count:int=0;


[Bindable]
private var menuData:ArrayCollection = new ArrayCollection([
	{label:"更多操作",name:"onMose"		},
	{label:"删除",name:"onDelete"		},
	{label:"列表设置",name:"onSetup"		}
]);

[Bindable]
public var winParam:Object=new Object();

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 查询部门
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getDepartmentTreeXml(value:int=0):void
{
	if(winParam=="1")
	{
		count = value;
		this.currentState= "person";
		this.label ="职员管理";
		AccessUtil.remoteCallJava("RoleDest","getDepartment",getEpartmencallBackHandler,"",ConstsModel.EPARTMENT_GET_INFO);
	}
	else if(winParam=="2")
	{
		this.currentState= "customer";
		this.label ="客商档案管理";
		getList(44);
	}
}

private function getEpartmencallBackHandler(event:ResultEvent):void
{
	if(event.result!=null)
	{
		var result:String = event.result as String;
		this.tre_department.treeCompsXml = new XML(result);
	}
	this.getList(13);
}

private function getList(ilist:int):void
{
	var acListclmVo:ListclmVo = new ListclmVo();
	acListclmVo.ilist = ilist;
	acListclmVo.iperson = CRMmodel.userId;
	AccessUtil.remoteCallJava("ACListsetDest","getListset",getAcConsultclmBack,acListclmVo);
}

private function getAcConsultclmBack(event:ResultEvent):void
{
	acListsetVo = event.result.acListsetVo as ListsetVo;
	acListclmVos = new ArrayCollection();
	acListclmVos = event.result.acListclmVos as ArrayCollection;
	this.dgrd_person.InitColumns();
	for each(var acli:ListclmVo in acListclmVos)
	{
		if(acli.bshow)
		{
			var dgc_name:DataGridColumn = new DataGridColumn();
			dgc_name.dataField = acli.cfield;
			dgc_name.headerText = acli.cnewcaption;
			switch(acli.ialign)
			{
				case 0:
				{
					dgc_name.setStyle("textAlign","left");
					break;
				}
				case 1:
				{
					dgc_name.setStyle("textAlign","center");
					break;
				}	
				case 2:
				{
					dgc_name.setStyle("textAlign","right");
					break;
				}
				default:
				{
					break;
				}
			}
			dgc_name.width =acli.icolwidth;
			dgrd_person.columns =dgrd_person.columns.concat(dgc_name);
		}
	}
	/*this.hbx_person.removeAllChildren();*/
}

public function onGridClick(event:Event):void
{
	this.pageBar.selectedNum = this.dgrd_person.getSelectRows().length;
}

// 按部门查询
private function onChange():void
{
	var sql:String = acListsetVo.csql1;
	if(sql.lastIndexOf(" where ")==-1)
	{
		sql+=" where ";
	}
	else
	{
		sql+=" and ";
	}
	sql+=" HR_person.idepartment='"+this.tre_department.selectedItem.@iid+"'";
	sql+=" and hr_person.bjobstatus in (";
	
	
	if(this.cmbx_working.selected&&this.cmbx_left.selected)
	{
		sql+="'1','0')";
	}
	else if(this.cmbx_left.selected)
	{
		sql+="'0')";
	}
	else if(this.cmbx_working.selected)
	{
		sql+="'1')";
		/*this.cmbx_working.selected = true;
		this.cmbx_left.selected = false;
		sql+="1'";*/
	}
	else
	{
		
	}
	var paramObj:Object = new Object();
	paramObj.pagesize = this.acListsetVo.ipage;
	paramObj.curpage=1;
	paramObj.sqlid="get_persons_sql";
	paramObj.sql=sql;
	this.pageBar.initPageHandler(paramObj,pageCallBack);
	/*AccessUtil.remoteCallJava("hrPersonDest","verificationSql",onChangeHandler,sql); */
}

public function pageCallBack(list:ArrayCollection):void{
	personArr = new ArrayCollection();
	personArr =list;
}

private function onChangeHandler(event:ResultEvent):void
{
	personArr = new ArrayCollection();
	personArr = event.result as ArrayCollection;
}

private function exclusiveWork():void
{
	if(this.cmbx_working.selected)
	{
		this.cmbx_left.selected = false;
	}
}

private function exclusiveleft():void
{
	if(this.cmbx_left.selected)
	{
		this.cmbx_working.selected = false;
	}
}

public function onClick(event:MenuEvent):void
{
	if(event.item.name=="onDelete")
	{
		var rows:ArrayCollection = this.dgrd_person.getSelectRows();
	 	if(rows.length>0)
		{
			var str:String ="";
			for(var i:int=0;i<rows.length;i++)
			{
				if(str=="")
				{
					str=rows[i].cname;
				}
				else
				{
					str+=","+rows[i].cname;
				}
			}
			CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+str+"这些人员？】",null,"AFFIRM",this,"onDeletePerson");
		}
		else
		{
			CRMtool.tipAlert("请选择要删除的记录！！");
		}
	}
	else if(event.item.name=="onSetup")
	{
		var ass:ConsultsetSet = new ConsultsetSet();
		if(this.winParam=="1")
		{
			ass.iid = 13;
		}
		else
		{
			ass.iid =44;
		}
		ass.isShowList =1;
		ass.width=700;
		ass.height = 500;
		ass.owner = this;
		/*var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
		PopUpManager.addPopUp(ass, mainApp);
		PopUpManager.centerPopUp(ass);*/
		CRMtool.openView(ass);
	}
}

public function refreshStyle():void
{
	var acListclmVo:ListclmVo = new ListclmVo();
	acListclmVo.ilist = 13;
	acListclmVo.iperson = CRMmodel.userId;
	AccessUtil.remoteCallJava("ACListsetDest","getListset",getAcConsultclmBack,acListclmVo);
}


public function onDeletePerson():void
{
	var paramObj:Object = new Object();
	paramObj.iidStr =  this.dgrd_person.getSelectRows();
	if(this.winParam=="1")
	{
		AccessUtil.remoteCallJava("hrPersonDest","removePerson",savePerson,paramObj,"删除人员处理中...");
	}
	else if(this.winParam=="2")
	{
		AccessUtil.remoteCallJava("csCustomerDest","removePerson",savePerson,paramObj,"删除人员处理中...");
	}
}

private function savePerson(event:ResultEvent):void
{
	if(event.result || event.result.toString()!="fail")
	{ 
		var rows:ArrayCollection =  this.dgrd_person.getSelectRows();
		for(var j:int=0;j<rows.length;j++)
		{
			for(var i:int=0;i<this.personArr.length;i++)
			{
				if(rows[j].iid==this.personArr.getItemAt(i).iid)
				{
					this.personArr.removeItemAt(i);
					break;
				}
			}
		}
		this.dgrd_person.getSelectRows().removeAll();
		CRMtool.tipAlert("删除人员成功!!");
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.FAIL);
	}
}


public function onOpenPerson(event:ItemClickEvent):void
{
	var type:String=event.item.name;
	if(type=="onNew"||type=="onEdit")
	{
		var paramObj:Object = new Object();
		paramObj.itemType = type;
		if(this.tre_department.selectedItem)
		{
			paramObj.idepartment=this.tre_department.selectedItem.@iid;
		}
		if(type=="onEdit")
		{
			if(this.dgrd_person.getSelectRows().length>0)
			{
				paramObj.personArr = this.dgrd_person.getSelectRows();
			}
			else
			{
				Alert.show("请选择要修改的记录");
			}
		}
		if(this.winParam=="1")
		{
			CRMtool.openMenuItemFormOther('yssoft.views.person.PersonRecord',paramObj,'','');
		}
		else if(this.winParam=="2")
		{
			paramObj.isCustom ="1";
			CRMtool.openMenuItemFormOther('yssoft.views.customer.CsCustomerRecord',paramObj,'','');
		}
	}
	else
	{
		this.tnp_bjobstatus.text="";
		/*this.personArr = new ArrayCollection();*/
		//居中显示  
		var ass:AssemblyQueryclmView = new AssemblyQueryclmView();
		if(this.winParam=="1")
		{
			ass.ifuncregedit =13;
		}
		else
		{
			ass.ifuncregedit =44;
		}
		ass.width=700;
		ass.height = 500;
		ass.owner = this;
/*		var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
		PopUpManager.addPopUp(ass, mainApp);
		PopUpManager.centerPopUp(ass);*/
		CRMtool.openView(ass);
	}
}

public function pageInitBack(sql1:String):void
{
	var sql:String = acListsetVo.csql1;
	if(sql.lastIndexOf(" where ")==-1)
	{
		sql+=" where ";
	}
	else
	{
		sql+=" and ";
	}
	if(this.winParam=="1")
	{
		sql+=" hr_person.bjobstatus in (";
		
		if(this.cmbx_working.selected&&this.cmbx_left.selected)
		{
			sql+="'1','0')";
		}
		else if(this.cmbx_left.selected)
		{
			sql+="'0')";
		}
		else if(this.cmbx_working.selected)
		{
			sql+="'1')";
			/*this.cmbx_working.selected = true;
			this.cmbx_left.selected = false;
			sql+="1'";*/
		}
		else
		{
			
		}
	}
	else if(this.winParam=="2")
	{
		sql+="CS_customer.istatus in(";
		
		var istatusStr:String = "";
		if(this.cmbx_unaudited.selected)
		{
			istatusStr ="0";
		}
		if(this.cmbx_audited.selected)
		{
			if(CRMtool.isStringNotNull(istatusStr))
			{
				istatusStr+=",";
			}
			istatusStr +="1";
		}
		
		if(this.cmbx_close.selected)
		{
			if(CRMtool.isStringNotNull(istatusStr))
			{
				istatusStr+=",";
			}
			istatusStr +="2";
		}
		
		if(this.cmbx_delete.selected)
		{
			if(CRMtool.isStringNotNull(istatusStr))
			{
				istatusStr+=",";
			}
			istatusStr +="3";
		}
		
		if(CRMtool.isStringNotNull(istatusStr))
		{
			sql+=istatusStr+")";
		}
	}
	if(CRMtool.isStringNotNull(sql))
	{
		sql+=sql1;
	}
	var paramObj:Object = new Object();
	paramObj.pagesize = this.acListsetVo.ipage;
	paramObj.curpage=1;
	paramObj.sqlid="get_persons_sql";
	if(sql.lastIndexOf("order")!=-1)
	{
		var end:int = sql.lastIndexOf("order");
		var len:int = sql.length;
		paramObj.sql = sql.substring(0,end);
		paramObj.orderSql = sql.substring(end,len);
	}
	else
	{
		paramObj.sql = sql;
	}
	this.pageBar.initPageHandler(paramObj,pageCallBack);
	/*AccessUtil.remoteCallJava("hrPersonDest","verificationSql",onChangeHandler,sql); */
}

public function onDouble():void
{
	/*if(this.dgrd_person.selectedItem)
	{*/
		/*var param:ArrayCollection = new ArrayCollection();
		param.addItem(this.dgrd_person.getro);*/
		
		if(this.dgrd_person.getSelectRows().length>0)
		{
			var paramObj:Object = new Object();
			paramObj.personArr =this.dgrd_person.getSelectRows();
			if(this.winParam=="1")
			{
				CRMtool.openMenuItemFormOther('yssoft.views.person.PersonRecord',paramObj,"",'');
			}
			else if(this.winParam=="2")
			{
				paramObj.isCustom ="1";
				CRMtool.openMenuItemFormOther('yssoft.views.customer.CsCustomerRecord',paramObj,'','');
			}
		}
		else
		{
			Alert.show("请选择要操作的记录");	
		}
		
	/*}*/
}

//窗体初始化
public function onWindowInit():void
{
	
}

//窗体打开
public function onWindowOpen():void
{
	getDepartmentTreeXml();
	this.personArr.removeAll();
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}

public function search():void
{
	var sql:String = "select * from ("+acListsetVo.csql1+") ";
	
	if(this.winParam=="1")
	{
		sql+="hr_person";
	}
	else if(this.winParam=="2")
	{
		sql+="CS_customer";
	}
	
	if(sql.lastIndexOf(" where ")==-1)
	{
		sql+=" where ";
	}
	else
	{
		sql+=" and ";
	}
	var beraStr:String="";
	var count:int=0;
	for each(var listclmVo:ListclmVo in this.acListclmVos)
	{
		if(listclmVo.bsearch)
		{
			if(count>0)
			{
				beraStr+=" or ";
			}
			if(this.winParam=="1")
			{
				beraStr+="hr_person.";
			}
			else
			{
				beraStr+="CS_customer.";
			}
			beraStr+=listclmVo.cfield+"='"+this.tnp_bjobstatus.text+"'";
			count++;
		}
	}
	if(beraStr!="")
	{
		if(CRMtool.isStringNotNull(this.tnp_bjobstatus.text))
		{
			sql+="("+beraStr+") and ";
			
		}
		if(this.winParam=="1")
		{
			sql+="  hr_person.bjobstatus in (";
			
			if(this.cmbx_working.selected&&this.cmbx_left.selected)
			{
				sql+="'1','0')";
			}
			else if(this.cmbx_left.selected)
			{
				sql+="'0')";
			}
			else if(this.cmbx_working.selected)
			{
				sql+="'1')";
			}
			else
			{
				
			}
		}
		else if(this.winParam=="2")
		{
			sql+=" CS_customer.istatus in(";
			
			var istatusStr:String = "";
			if(this.cmbx_unaudited.selected)
			{
				istatusStr ="0";
			}
			if(this.cmbx_audited.selected)
			{
				if(CRMtool.isStringNotNull(istatusStr))
				{
					istatusStr+=",";
				}
				istatusStr +="1";
			}
			
			if(this.cmbx_close.selected)
			{
				if(CRMtool.isStringNotNull(istatusStr))
				{
					istatusStr+=",";
				}
				istatusStr +="2";
			}
			
			if(this.cmbx_delete.selected)
			{
				if(CRMtool.isStringNotNull(istatusStr))
				{
					istatusStr+=",";
				}
				istatusStr +="3";
			}
			
			if(CRMtool.isStringNotNull(istatusStr))
			{
				sql+=istatusStr+")";
			}
		}
		var paramObj:Object = new Object();
		paramObj.pagesize = this.acListsetVo.ipage;
		paramObj.curpage=1;
		paramObj.sqlid="get_persons_sql";
		paramObj.sql=sql;
		this.pageBar.initPageHandler(paramObj,pageCallBack);
	/*	AccessUtil.remoteCallJava("hrPersonDest","verificationSql",onChangeHandler,sql); */
	}
	else
	{
		val.visible=true;
		val.height=20;
		val.text ="您没有设置快速查询条件!";
		disappearInfo();
	}
}

/**提示消息消失*/
private function disappearInfo():void{
	setTimeout(function ():void{val.visible=false;
	val.height=0;
	val.text ="";},2000);
}