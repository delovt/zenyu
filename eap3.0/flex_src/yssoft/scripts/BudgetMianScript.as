import flash.display.DisplayObject;
import flash.events.Event;
import flash.utils.setTimeout;


import mx.charts.series.items.ColumnSeriesItem;
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.CheckBox;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.FlexGlobals;
import mx.events.ItemClickEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;


import yssoft.comps.dataGridForCheckBox.CheckBoxHeaderRenderer;
import yssoft.comps.dataGridForCheckBox.CheckBoxItemRenderer;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.consultsets.ConsultsetSet;
import yssoft.views.materies.MateriesProductView;
import yssoft.views.materies.MateriesRecord;
import yssoft.views.sysmanage.AssemblyQueryclmView;
import yssoft.vos.BmBudgetVo;
import yssoft.vos.ListclmVo;
import yssoft.vos.ListsetVo;

[Bindable]
private var acListsetVo:ListsetVo=new ListsetVo();

[Bindable]
private var acListclmVos:ArrayCollection = new ArrayCollection(); //列表专用

[Bindable]
private var budgetArr:ArrayCollection = new ArrayCollection();

[Bindable]
private var menuData:ArrayCollection = new ArrayCollection([
	{label:"更多操作",name:"onMose"		},
	{label:"删除",name:"onDelete"		},
	{label:"列表设置",name:"onSetup"		}
]);



//初始化树
private function init():void{
	var acListclmVo:ListclmVo = new ListclmVo();
	acListclmVo.ilist = 53; //获取list_set 表内设定的ID
	acListclmVo.iperson = CRMmodel.userId;
	AccessUtil.remoteCallJava("ACListsetDest","getListset",getAcConsultclmBack,acListclmVo);
}

//初始化加载动态列
private function getAcConsultclmBack(event:ResultEvent):void{
	acListsetVo = event.result.acListsetVo as ListsetVo;
	acListclmVos = new ArrayCollection();
	acListclmVos = event.result.acListclmVos as ArrayCollection;
	this.dgrid.InitColumns();
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
			dgrid.columns =dgrid.columns.concat(dgc_name);
		}
	}
}


//新增，修改，查询
public function onOpenBudget(event:ItemClickEvent):void{
		var type:String=event.item.name;
		
		var paramObj:Object = new Object();
		paramObj.itemType = type;
		
		if(type=="onNew")
		{	
			paramObj.arr =new ArrayCollection();
			paramObj.budget =new BmBudgetVo();
		}
		else if(type=="onEdit")
			{	
			
			if(this.dgrid.getSelectRows().length > 0){
				getDB_Budgets(); return ;
			}else{
				CRMtool.showAlert("请选中您要修改的信息！");
				return;
			}
		}else{
				this.tnp_bjobstatus.text="";
				var ass:AssemblyQueryclmView = new AssemblyQueryclmView();
				ass.ifuncregedit =53;
				ass.width=700;
				ass.height = 500;
				ass.owner = this;
				/*var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
				PopUpManager.addPopUp(ass, mainApp);
				PopUpManager.centerPopUp(ass);*/
				CRMtool.openView(ass);
				return;
		}
		
		CRMtool.openMenuItemFormOther("yssoft.views.expensesBudget.BudgetView",paramObj,"预算明细","");
}

//删除 ,窗口列表调整
public function onClick(event:MenuEvent):void
{
	if(event.item.name=="onDelete")
	{
	if (this.dgrid.getSelectRows().length >0 )CRMtool.tipAlert("确认要删除这些信息？",null,"AFFIRM",this,"onDeleteBudget");
		else CRMtool.tipAlert("请选择要删除的记录！！");
	}else if(event.item.name=="onSetup"){
		var ass:ConsultsetSet = new ConsultsetSet();
		ass.iid = 53;
		ass.isShowList =1;
		ass.width=700;
		ass.height = 500;
		ass.owner = this;
		/*var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
		PopUpManager.addPopUp(ass, mainApp);
		PopUpManager.centerPopUp(ass);	*/
		CRMtool.openView(ass);
	}
}

//执行删除
public function onDeleteBudget():void{
	var ids:String ="";
	for each (var obj:Object in this.dgrid.getSelectRows()) {
		ids += (obj.iid+",");
	}
	ids = ids.substr(0,ids.length-1);
	var param:Object = {};
	param.iid = "where iid in ( "+ ids+")";
	param.iid_son = "where ibudget in ( "+ ids+")"
	
	AccessUtil.remoteCallJava("BmBudgetDest","delBmBudget",callfundel,param);
}

//删除回调函数
private function callfundel(e:ResultEvent):void{
	var str:String = e.result as String;
	if(str =="success"){
		CRMtool.tipAlert("操作成功！");
	}else{
		CRMtool.tipAlert("操作失败！");
	}
}

//查询
public function search():void{
	
	var sql:String = acListsetVo.csql1;
	var beraStr:String="";
	var count:int=0;
	
	if(this.tnp_bjobstatus.text != ""){
	
		if(sql.lastIndexOf(" where ")==-1)
		{
			sql+=" where ";
		}
		else
		{
			sql+=" and ";
		}
		
		for each(var listclmVo:ListclmVo in this.acListclmVos)
		{
			if(listclmVo.bsearch)
			{
				if(count>0)
				{
					beraStr+=" or ";
				}
				beraStr+=listclmVo.cfield+"='"+this.tnp_bjobstatus.text+"'";
				count++;
			}
		}
	}
	
	if(beraStr!="" || this.tnp_bjobstatus.text == ""){	
		if(this.tnp_bjobstatus.text != ""){
			sql += 	beraStr;
		}
		var paramObj:Object = new Object();
		paramObj.pagesize = this.acListsetVo.ipage;
		paramObj.curpage=1;
		paramObj.sqlid="bm_budget_select";
		paramObj.sql=sql;
		this.pageBar.initPageHandler(paramObj,pageCallBack);
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


//打开预算项目
public function openBudgetClassView():void{
	CRMtool.openMenuItemFormOther("yssoft.views.expensesBudget.BudgetItemView",null,"预算项目","");
}

//查询窗口回调方法
public function pageInitBack(sql1:String):void
{
	var sql:String = acListsetVo.csql1;
	
	if(sql.indexOf('where') == -1){
		sql += " where 1=1  ";
	}
	sql += sql1;
	var paramObj:Object = {};
	paramObj.pagesize = this.acListsetVo.ipage;
	paramObj.curpage=1;
	paramObj.sqlid="bm_budget_select";

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
}

//查询，快搜 回调函数
public function pageCallBack(list:ArrayCollection):void{
	budgetArr =list;
}


//grid点击事件
public function onGridClick(e:Event):void{
	this.pageBar.selectedNum = this.dgrid.getSelectRows().length;
}

 
//打开子窗体
public function onDouble():void
{
	var paramObj:Object = new Object();
	if(this.dgrid.getSelectRows().length>0)
	{
		getDB_Budgets();
	}
	else
	{
		Alert.show("请选择要操作的记录");	
	}
}


//获取预算详细列表
public function getDB_Budgets():void{
	AccessUtil.remoteCallJava("BmBudgetDest","getBmBudgetsList",db_call_fun,this.dgrid.getSelectRows()[0]);
}

private function db_call_fun(e:ResultEvent):void{
	var paramObj:Object = {};
	paramObj.arr = e.result.list as ArrayCollection;
	paramObj.budget = this.dgrid.getSelectRows()[0] ;
	CRMtool.openMenuItemFormOther("yssoft.views.expensesBudget.BudgetView",paramObj,"预算明细","");
	
}
