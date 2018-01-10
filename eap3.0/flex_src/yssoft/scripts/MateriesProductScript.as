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
import yssoft.vos.ListclmVo;
import yssoft.vos.ListsetVo;
import yssoft.vos.ScProduct;

[Bindable]
private var acListsetVo:ListsetVo=new ListsetVo();

[Bindable]
private var acListclmVos:ArrayCollection = new ArrayCollection();


[Bindable]
private var productArr:ArrayCollection = new ArrayCollection();

[Bindable]
private var menuData:ArrayCollection = new ArrayCollection([
	{label:"更多操作",name:"onMose"		},
	{label:"删除",name:"onDelete"		}
]);




private function init():void{
	var param:Object = {};
	AccessUtil.remoteCallJava("CalculateMaterielDest","getSc_productClassList",callFun);
}

private function callFun(e:ResultEvent):void
{
	if(e.result  != null)
		this.tre_productClass.treeCompsXml = new XML(e.result as String);
	
	var acListclmVo:ListclmVo = new ListclmVo();
	acListclmVo.ilist = 43; //获取list_set 表内设定的ID
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



private function to_product_Click():void
{	
	if(this.tre_productClass.selectedItem == null){
		return ;
	}
	var treObje:XML = this.tre_productClass.selectedItem as XML;
	if(treObje.hasComplexContent()){return;}
	
	var iid:int = int(treObje.@iid);
	var param1:Object = {};
	param1.iproductclass = iid;
	param1.pagesize = 50;
	param1.curpage=1;
	param1.sqlid="sc_product_select";
	this.pageBar.initPageHandler(param1,callFun_product);
}

private function callFun_product(list:ArrayCollection):void{
	productArr.removeAll();
	productArr = list;
}



public function onOpenProduct(event:ItemClickEvent):void{
		var type:String=event.item.name;
		var paramObj:Object = new Object();
		paramObj.itemType = type;
		
		var title:String = "物料档案";
		if(type=="onBrowse")
		{
			if(this.dgrid.getSelectRows().length < 0){
				CRMtool.showAlert("请选中您要查看的信息！");
				return;
			}
			paramObj.product = this.dgrid.getSelectRows()[0] ;        //获取product对象信息
			paramObj.productArr   =this.dgrid.getSelectRows();  				//获取档案集合
			paramObj.productIndex= 0; 									//设定下标	
		}
		else if(type=="onNew")
		{	
			if(null != this.tre_productClass.selectedItem)
				paramObj.iproductclass = this.tre_productClass.selectedItem.@iid;
			else paramObj.iproductclass = 1;
		}
		else if(type=="onEdit")
			{	
			
			if(this.dgrid.getSelectRows().length > 0){
				paramObj.product = this.dgrid.getSelectRows()[0] ;        //获取product对象信息
				paramObj.productArr   =this.dgrid.getSelectRows();  				//获取档案集合
				paramObj.productIndex= 0; 									//设定下标
			}else{
				CRMtool.showAlert("请选中您要修改的信息！");
				return;
			}
		}
		else if(type=="onDelete")
		{
			if (this.dgrid.getSelectRows().length >0 )CRMtool.tipAlert("确认要删除这些信息？",null,"AFFIRM",this,"onDeleteProduct");
			else CRMtool.tipAlert("请选择要删除的记录！！");
			return;
		}
		
		CRMtool.openMenuItemFormOther("yssoft.views.materies.MateriesRecord",paramObj,"物料档案信息","");
		return;
}




//列表设置返回刷新页面
public function refreshStyle():void
{
	this.init();
}

//执行删除
public function onDeleteProduct():void{
	var ids:String ="";
	for each (var obj:Object in this.dgrid.getSelectRows()) {
		ids += (obj.iid+",");
	}
	ids = ids.substr(0,ids.length-1);
	var param:Object = {};
	param.iid = ids;
	
	AccessUtil.remoteCallJava("CalculateMaterielDest","delScProduct",callfundel,param);
}

private function callfundel(e:ResultEvent):void{
	var str:String = e.result as String;
	if(str =="success"){
		CRMtool.tipAlert("操作成功！");
		
		to_product_Click();//刷新
	
	}else{
		CRMtool.tipAlert("操作失败！");
	}
}


public function search():void{
	
	var str:String = this.tnp_bjobstatus.text;	
	var sql:String = " select * from  sc_product ";	
	
	if(null != str && "" != str){
		sql +="where sc_product.ccode like '%"+str+"%' or sc_product.cname  like '%"+str+"%'  or sc_product.cmnemonic  like '%"+str+"%'  or sc_product.istatus  like '%"+str+"%'"
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


//打开窗口
public function openPCView():void{
	CRMtool.openMenuItemFormOther("yssoft.views.materies.ProductClassView",null,"物料分类","");
}

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

public function pageCallBack(list:ArrayCollection):void{
	productArr.removeAll();
	productArr =list;
}


public function onGridClick(e:Event):void{
	this.pageBar.selectedNum = this.dgrid.getSelectRows().length;
}


public function onDouble():void
{
	var paramObj:Object = new Object();
	if(this.dgrid.getSelectRows().length>0)
	{
		paramObj.productIndex= 0; 		
		paramObj.product = this.dgrid.getSelectRows()[0] ; 
		paramObj.personArr =this.dgrid.getSelectRows();
		CRMtool.openMenuItemFormOther("yssoft.views.materies.MateriesRecord",paramObj,"物料档案信息","");
	}
	else
	{
		Alert.show("请选择要操作的记录");	
	}
}
