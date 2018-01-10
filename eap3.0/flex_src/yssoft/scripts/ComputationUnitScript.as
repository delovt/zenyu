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

import yssoft.comps.dataGridForCheckBox.CheckBoxHeaderRenderer;
import yssoft.comps.dataGridForCheckBox.CheckBoxItemRenderer;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.consultsets.ConsultsetSet;
import yssoft.views.materies.UnitClassView;
import yssoft.views.materies.UnitEditView;
import yssoft.views.sysmanage.AssemblyQueryclmView;
import yssoft.vos.ListclmVo;
import yssoft.vos.ListsetVo;

[Bindable]
private var unitArr:ArrayCollection = new ArrayCollection();

[Bindable]
private var acListsetVo:ListsetVo=new ListsetVo();

[Bindable]
private var acListclmVos:ArrayCollection = new ArrayCollection();

[Bindable]
private var menuData:ArrayCollection = new ArrayCollection([
	{label:"更多操作",name:"onMose"		},
	{label:"删除",name:"onDelete"		},
	{label:"列表设置",name:"onSetup"		}
]);


private function init():void{
	var param:Object = {};
	AccessUtil.remoteCallJava("CalculateMaterielDest","getScUnitClassList",callFun);
}

private function callFun(e:ResultEvent):void
{
	if(e.result  != null&&e.result!="<root />"){
		this.tre_calculate.treeCompsXml = new XML(e.result as String);
	}else{
		this.tre_calculate.treeCompsXml = null;
	}
		
	
	var acListclmVo:ListclmVo = new ListclmVo();
	acListclmVo.ilist =36; 		//获取list_set 表内设定信息的ID
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


private function to_unitClass_Click():void
{	
	if(this.tre_calculate.selectedItem == null){
		return ;
	}
	var treObje:XML = this.tre_calculate.selectedItem as XML;
	
	var iid:int = int(treObje.@iid);
	var param1:Object = {};
	param1.iid = iid;
	param1.pagesize = 50;
	param1.curpage=1;
	param1.sqlid="get_persons_sql";
	//var sql:String =" select * from sc_unit where iunitclass in (select iid from sc_unitclass where ccode like '"+treObje.@ccode+"%')";
	var sql:String =" select  iid,iunitclass,ccode,cname,fchangerate,iifuncregedit,bdefault bdefault2, case bdefault when '0' then '否' when '1' then '是' end as bdefault from sc_unit where iunitclass ="+treObje.@iid;
	param1.sql = sql;
	this.pageBar.initPageHandler(param1,callFun_unit);
}

private function callFun_unit(list:ArrayCollection):void{
	unitArr.removeAll();
	unitArr = list;
}

public function onOpenUnit(event:ItemClickEvent):void{
		var type:String=event.item.name;
		var unitEdit:UnitEditView = new UnitEditView();
		
		if(type == "onBrowse")
		{
			unitEdit.title = "查看计量单位";
			if(this.dgrid.selectedItem != null){
				unitEdit.unitObj  = this.dgrid.selectedItem;   //获取unit对象信息
				unitEdit.method = "onBrowse";
				CRMtool.openView(unitEdit);
			}else{
				CRMtool.showAlert("请选中您要查看的信息！");
			}
		}
		else if(type=="onNew")
		{	
			unitEdit.title = "新增计量单位";
			CRMtool.openView(unitEdit);
		}
		else if(type=="onEdit")
		{	
			unitEdit.title = "修改计量单位";
			if(this.dgrid.selectedItem != null){
				unitEdit.unitObj  = this.dgrid.selectedItem;   //获取unit对象信息
				CRMtool.openView(unitEdit);
			}else{
				CRMtool.showAlert("请选中您要修改的信息！");
			}
		}else if(type=="onDelete"){
			
				if (this.dgrid.getSelectRows().length >0 )CRMtool.tipAlert("确认要删除这些信息？",null,"AFFIRM",this,"onDeleteUnit");
				else {CRMtool.tipAlert("请选择要删除的记录！！");}
		}
		
//		else{  //弹出查询
//			this.tnp_bjobstatus.text="";
//			var ass:AssemblyQueryclmView = new AssemblyQueryclmView();
//			ass.ifuncregedit =36;  //liest 对应的 id
//			ass.width=700;
//			ass.height = 500;
//			ass.owner = this;
//			/*var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
//			PopUpManager.addPopUp(ass, mainApp);
//			PopUpManager.centerPopUp(ass);*/
//			CRMtool.openView(ass);
//			return;
//		}
}


//public function onClick(event:MenuEvent):void
//{
//	if(event.item.name=="onDelete")
//	{
//		if (this.dgrid.getSelectRows().length >0 )CRMtool.tipAlert("确认要删除这些信息？",null,"AFFIRM",this,"onDeleteUnit");
//		else CRMtool.tipAlert("请选择要删除的记录！！");
//	}
//	
//	else if(event.item.name=="onSetup"){  //列表设置
//		var ass:ConsultsetSet = new ConsultsetSet();
//		ass.iid = 36;
//		ass.isShowList =1;
//		ass.width=700;
//		ass.height = 500;
//		ass.owner = this;
//		/*var mainApp:DisplayObject = FlexGlobals.topLevelApplication as DisplayObject;
//		PopUpManager.addPopUp(ass, mainApp);
//		PopUpManager.centerPopUp(ass);	*/
//		CRMtool.openView(ass);
//	}
//
//}

//执行删除
public function onDeleteUnit():void{
	var ids:String ="";
	for each (var obj:Object in  this.dgrid.getSelectRows()) {
		ids += (obj.iid+",");
	}
	ids = ids.substr(0,ids.length-1);
	var param:Object = {};
	param.iid = ids;
	
	AccessUtil.remoteCallJava("CalculateMaterielDest","delScUnit",callfundel,param);
}

private function callfundel(e:ResultEvent):void{
	var str:String = e.result as String;
	if(str =="success"){
		CRMtool.tipAlert("操作成功！");
		
		to_unitClass_Click();//刷新
	
	}else{
		CRMtool.tipAlert("操作失败！");
	}
}


//查询页面调用方法与 search一样
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
	paramObj.sqlid="get_product_sql";
	
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


public function search():void{
	this.unitArr.removeAll(); //清空原来信息
	
	var str:String = this.tnp_bjobstatus.text;	
	//var sql:String = " select * from  sc_unit ";	
	//update by 郝凯
	var sql:String=" select iid,iunitclass,ccode,cname,fchangerate,(case when sc_unit.bdefault=0 then '否' else '是' end) bdefault,iifuncregedit,iwfstatus from sc_unit ";
	
	if(null != str && "" != str){
		sql += "where sc_unit.ccode like '%"+str+"%' or sc_unit.cname  like '%"+str+"%'  or sc_unit.fchangerate  like '%"+str+"%'";
	}
	
	var paramObj:Object = new Object();
	paramObj.pagesize = this.acListsetVo.ipage;
	paramObj.curpage=1;
	paramObj.sqlid="get_product_sql";
	paramObj.sql=sql;
	this.pageBar.initPageHandler(paramObj,pageCallBack);
	
}

/**提示消息消失*/
private function disappearInfo():void{
	setTimeout(function ():void{val.visible=false;
		val.height=0;
		val.text ="";},2000);
}

public function pageCallBack(list:ArrayCollection):void{
	
	
	unitArr.removeAll();
	//----------------------code by liulei 添加序号列 开始----------------------//
	var i:int;
	i=1;
	for each (var item:Object in list) 
	{
		item.sort_id=i++;	
	}
	unitArr =list;
}

	

//打开计量单位详细窗口
public function openUntiClassView():void{
	var model:UnitClassView = new UnitClassView();
	model.titleLabel = "计量单位组";
	model.title = "计量单位组信息维护";
	CRMtool.openView(model);
}


//dataGrid点击事件
private function onGridClick(e:Event):void{

}
//列表设置返回刷新页面
public function refreshStyle():void
{
	this.init();
}
//dataGrid双击击事件
private function onDouble():void{

}
