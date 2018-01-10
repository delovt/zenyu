/**
 *
 * @author：liu_lei
 * 日期：2011-8-20
 * 功能：
 * 修改记录：
 *
 */
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import hlib.Hash;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.models.*;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.sysmanage.AC_tableView;
import yssoft.vos.*;

public var iid:int;
//表头VO
[Bindable]
public var acConsultsetVo:AcConsultsetVo=new AcConsultsetVo();
//表体VO
public var acConsultclmVo:AcConsultclmVo;

//列表表头
[Bindable]
private var acListsetVo:ListsetVo=new ListsetVo();

//列表标题
[Bindable]
private var acListclmVos:ArrayCollection = new ArrayCollection();

//表体集
[Bindable]
public var resultArr:ArrayCollection=new ArrayCollection();

public var parentForm:Object;

[Bindable]
public var ifieldtypeArr:ArrayCollection=new ArrayCollection();
[Bindable]
public var isFand:Boolean = true;

[Bindable]public var arrDataList:ArrayCollection = new ArrayCollection();	//数据集

public var delArrDataList:ArrayCollection = new ArrayCollection(); //删除数据集

public var editArrDataList:ArrayCollection = new ArrayCollection(); //修改的数据集

[Bindable] private var arrColor:Array = new Array();


//回调刷新参照设置样式
[Bindable]
public var refreshStyle:Function;

private var _isShowList:int= 0;

public function  set isShowList(value:int):void
{
	this._isShowList = value;	
}

[Bindable]
private var _isShow:Boolean; 

public function set isShow(value:Boolean):void
{
	this._isShow = value;
}


public var value:Object=new Object();


//常用条件类型
[Bindable]
public var arr_icmtype:ArrayCollection = new ArrayCollection(
	[
		{label:"单项", value:"0"},
		{label:"区间", value:"1"},
		{label:"多选", value:"2"},
		{label:"是否BIT型", value:"3"}
	]
);

private static var dateFormatter:DateFormatter = new DateFormatter();



/**
 * 
 * 作者：XZQWJ
 * 日期：2013-01-29
 * 功能：
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getHeadData():void
{
	this.additionicon.setStyle("icon",ConstsModel._ADDITIONICON);
	this.additionicon.addEventListener(MouseEvent.CLICK,addNewItem);
	this.subtractionicon.setStyle("icon",ConstsModel._SUBTRACTIONICON);
	this.subtractionicon.addEventListener(MouseEvent.CLICK,deleteItem);
	if(isFand){
		var h_value:Object=value.head;
		this.cname.text=h_value.name as String;
		this.ccaption.text=h_value.ccaption as String;
		this.cmemo.text=h_value.cmemo as String;
	}
	
	
}

public function addNewItem(event:MouseEvent):void
{
	arrDataList=this.dgrd_consultclm.dataProvider as ArrayCollection;
	var obj:Object=new Object();
	obj.filedName="";
	obj.CNfiledName="";
	obj.ialign="";
	obj.num="";
	obj.bshow=false;
	obj.bkey=false;
	obj.num=null;
	obj.iid="";
	arrDataList.addItem(obj);
}

public function deleteItem(event:MouseEvent):void{
	if(arrDataList==null||arrDataList.length==0){
		
	}else{
		if(this.dgrd_consultclm.selectedItem==null){
			CRMtool.tipAlert("请选择要删除的数据");
			return;
		}else{
			if(this.dgrd_consultclm.selectedItem.filedName=="iid"){
				CRMtool.tipAlert("无法删除iid");
				return;
			}
			var index:int=this.dgrd_consultclm.selectedIndex;
			if(arrDataList.getItemAt(index).iid!=""){
				delArrDataList.addItem(this.dgrd_consultclm.selectedItem);
			}
			arrDataList.removeItemAt(index);
		}
	}
}

public function onEditEnd(event:DataGridEvent):void{
	
	var cols:DataGridColumn=dgrd_consultclm.columns[event.columnIndex];   
	var beingEditField:String = event.dataField;  //获得当前列的dataField  
	var oldLocal:String = event.itemRenderer.data[beingEditField];   
	var newLocale:String = dgrd_consultclm.itemEditorInstance[cols.editorDataField]; 
	if(beingEditField=="filedName"){
		for(var i:int=0;i<arrDataList.length;i++){
			if(i!=this.dgrd_consultclm.selectedIndex){
				if(newLocale==arrDataList.getItemAt(i)[beingEditField] as String){
					event.preventDefault();
				}
			}
		}
	}else if(beingEditField=="num"){
		var num:Number=Number(newLocale);   
		if(isNaN(num)){
			event.preventDefault();//恢复本来数据   
		}
	}
}

private function onGetAcQueryclmListBack(evt:ResultEvent):void{
	this.currentState ="queryState";
	arrDataList = evt.result as ArrayCollection;
	this.dgrd_consultclm.dataProvider = arrDataList;
	isFand = false;
	this.title ="查询条件设置";

}

private function getAcConsultclmBack(event:ResultEvent):void
{
	this.currentState ="consultState";
	
	acListclmVos = event.result.acListclmVos as ArrayCollection;
	if(null!=event.result.acListsetVo)
	{
		acListsetVo = event.result.acListsetVo as ListsetVo;
		acListclmVos = event.result.acListclmVos as ArrayCollection;
//		this.tnp_rownum.text = acListsetVo.ipage.toString();
//		this.tnp_fixnum.text = acListsetVo.ifixnum.toString();
		this.dgrd_consultclm.dataProvider = acListclmVos;
	}
	
	if(_isShow)
	{
		this.dgc_bgroup.visible =true;
		this.dgc_bsum.visible = true;
	}
	this.btn_resume.visible =true;
	
	this.title ="列表配置";
	(dgrd_consultclm as DataGrid).dragEnabled = true;
	(dgrd_consultclm as DataGrid).dropEnabled = true;
	(dgrd_consultclm as DataGrid).dragMoveEnabled = true;
}

public function  rowMoveEndUp():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveEndUp(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
	}
	
	
}

public function  rowMoveUp():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveUp(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
		
	}
	
	
}

public function  rowMoveDown():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveDown(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
	}
	
	
}

public function  rowMoveEndDown():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveEndDown(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-22
 * 功能：获得表头数据回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function headData_callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		this.currentState ="consultState";
		var arr:ArrayCollection=event.result as ArrayCollection;
		if (arr.length>0)
		{
		   acConsultsetVo=AcConsultsetVo(arr[0]);
		}
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-20
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
	if(isFand){
		var sql:String="select ac_fields.iid,ac_fields.cfield filedName ,ac_fields.ccaption CNfiledName,vi_tbfields.数据类型 ialign,vi_tbfields.长度 num,";
		sql=sql+"  case when vi_tbfields.允许为空='是' then 'true' else 'false' end bshow, ";
		sql=sql+" case when vi_tbfields.PK='K' then 'true' else 'false' end  bkey ";
		sql=sql+" from ac_table,ac_fields,vi_tbfields ";
		sql=sql+" where ac_table.iid=ac_fields.itable  and ctable=vi_tbfields.表名 and ac_fields.cfield=vi_tbfields.字段名 ";
		sql=sql+" and ctable='"+value.head.name+"'";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(event:ResultEvent):void{
			
			var arr:ArrayCollection = event.result as ArrayCollection;
			arrDataList=arr;
			
		},sql);
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-20
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
 * 作者：XZQWJ
 * 日期：2013-01-29
 * 功能：
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
		case "nvarchar":
		{
			lbltext="字符";//nvarchar
			break;
		}
		case "int":
		{
			lbltext="整型";//int
			break;
		}
		case "float":
		{
			lbltext="浮点";//float
			break;
		}
		case "datetime":
		{
			lbltext="日期";//datetime
			break;
		}
		case "bit":
		{
			lbltext="布尔";//bit
			break;
		}
		case "text":
		{
			lbltext="文本";//text
			break;
		}
	}
	return lbltext;
}

public function checkCreateTable(arr:ArrayCollection):String{

	var Msg:String="";
	for(var i:int=0;i<arr.length;i++){
		var item:Object=arr.getItemAt(i);
		if(CRMtool.isStringNull(item.filedName as String)){
			Msg="第"+(i+1)+"行字段名不能为空!请确认!"
//			CRMtool.tipAlert("第"+(i+1)+"行字段名不能为空!请确认!");
			break;
		}
		
		if(CRMtool.isStringNull(item.ialign as String)){
			Msg="第"+(i+1)+"行字段类型不能为空!请确认!";
//			CRMtool.tipAlert("第"+(i+1)+"行字段类型不能为空!请确认!");
			break;
		}else{
			if(item.num==""){
				Msg="第"+(i+1)+"行字段长度不能为空!请确认!";
//				CRMtool.tipAlert("第"+(i+1)+"行字段长度不能为空!请确认!");
				break;
			}else{
				if(item.ialign=="nvarchar"&&item.num=="0"){
					Msg="第"+(i+1)+"行字段类型为<字符>，其长度不能为零!请确认!";
//					CRMtool.tipAlert("第"+(i+1)+"行字段类型为<字符>，其长度不能为零!请确认!");
					break;
				}
			}
		}
		
		if(item.bkey as Boolean){
			if(item.bshow as Boolean){
				Msg="第"+(i+1)+"行字段为关键字，不能为空!请确认!";
				break;
			}
		}
		
	}
	return Msg;
	
}

/**
 * 
 * 作者：XZQWJ
 * 日期：2013-01-30
 * 功能：修改表后的确定
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
private function updatePm():void{
	
}

/**
 * 
 * 作者：XZQWJ
 * 日期：2013-01-29
 * 功能：确定
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
protected function btn_ok_clickHandler():void
{
	
	if(CRMtool.isStringNull(this.cname.text)){
		CRMtool.tipAlert("表名不能为空，请确认！");
		return;
	}
	
	if(arrDataList.length==0){
		CRMtool.tipAlert("表字段不能为空!请确认!");
		return;
	}
	
	var msg:String=checkCreateTable(arrDataList);
	if(CRMtool.isStringNotNull(msg)){
		CRMtool.tipAlert(msg);
		return;
	}
	if(isFand){
		updatePm();
		return;
	}
	
	
	var sql:String="select * from sysobjects where id = object_id(N'"+StringUtil.trim(this.cname.text)+"') and objectproperty(id,'IsTable')=1";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(event:ResultEvent):void{
		
		var arr:ArrayCollection = event.result as ArrayCollection;
		if(arr.length==0){
			
			var creatTableSql:String="CREATE TABLE "+StringUtil.trim(cname.text)+" (";
			
			var sql_con:String=createSql();
			
			creatTableSql=creatTableSql+sql_con+" CONSTRAINT PK_"+StringUtil.trim(cname.text)+" PRIMARY KEY  CLUSTERED ( "+" iid ) ON [PRIMARY] ) ON [PRIMARY]  ";
			
			trace(creatTableSql);
			
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(event:ResultEvent):void{
				var cntableName:String=StringUtil.trim(ccaption.text);
				dateFormatter.formatString="YYYY-MM-DD JJ:NN:SS";
				
				
				var insertSql:String="insert into ac_createTableLog(ctablename,ctablenamecn,imaker,dmaker,dr) values('"+StringUtil.trim(cname.text)+"','"+cntableName+"',"+CRMmodel.userId+",'"+dateFormatter.format(new Date())+"',0)";
				
				
				var param:Object=new Object();
				param.tablename=StringUtil.trim(cname.text);
				param.tablenamecn=cntableName;
				param.vmeno=StringUtil.trim(cmemo.text);
				param.insertSql=insertSql;
				param.value=arrDataList;
				AccessUtil.remoteCallJava("CommonalityDest", "executeSqlList",function(evt:ResultEvent):void{
					CRMtool.tipAlert("生成成功");
					closeWindow();
				},param);
				
			},creatTableSql);
			
		}else{
			CRMtool.tipAlert("表<"+StringUtil.trim(cname.text)+">存在，请重新输入新增表名!");
		}
		
		
	},sql);
}


private function createSql():String{
	var l:int=arrDataList.length;
	var sql:String="";
	for each(var item:Object in arrDataList){
		if(StringUtil.trim((item.filedName as String))=="iid"){
			sql=sql+" iid int IDENTITY (1, 1) NOT NULL , ";
			continue;
		}
		sql=sql+item.filedName;
		if(item.ialign=="nvarchar"){
			sql=sql+" "+item.ialign+" ("+item.num+") COLLATE Chinese_PRC_CI_AS ";
			if(item.bshow){
				sql=sql+" NULL ,";
			}else{
				sql=sql+" NOT NULL ,";
			}
			continue;
		}
		sql=sql+" "+item.ialign;
		if(item.bshow){
			sql=sql+" NULL ,";
		}else{
			sql=sql+" NOT NULL ,";
		}
		
	}
	return sql;
}


/**
 * 函数名称：onAddAcqueryclmBack
 * 函数说明：保存事件后处理
 * 函数参数：event:ListEvent
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onAddAcqueryclmBack(evt:ResultEvent):void{
	
	var result:String = evt.result as String;
	if(result=="fail")
	{
		CRMtool.tipAlert("保存失败");
	}else{
		this.closeWindow();
	}
	
}

private function updatelistsetsBack(event:ResultEvent):void
{
	var arr:ArrayCollection = event.result as ArrayCollection;
	if(arr.length==0){
		CRMtool.tipAlert("表<"+StringUtil.trim(this.cname.text)+">不存在，可以添加！");
	}else{
		CRMtool.tipAlert("表<"+StringUtil.trim(this.cname.text)+">存在，请重新输入新增表名!");
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-21
 * 功能：确定回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function saveTreecallBackHandler(event:ResultEvent):void
{
	if(event.result || event.result.toString()!="false")
	{
			if (this.refreshStyle!=null)
			{
				this.refreshStyle();
	            this.closeWindow();
			}
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.CONSULT_FAIL);
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-21
 * 功能：取消
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
protected function closeWindow():void
{
	PopUpManager.removePopUp(this);
}


protected function tnp_search_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode==13)
	{
//		tnp_search_searchHandler();
	}
}


//窗体初始化
public function onWindowInit():void
{
	
}
//窗体打开
public function onWindowOpen():void
{
	getHeadData();
//	getBodyData();
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}

public function resume():void
{
	if(isFand){
		
	}
//	if(CRMtool.isStringNull(this.cname.text)){
//		CRMtool.tipAlert("请输入表名");
//	}else{
//		var sql:String="select * from sysobjects where id = object_id(N'"+StringUtil.trim(this.cname.text)+"') and objectproperty(id,'IsTable')=1";
//		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",updatelistsetsBack,sql);
//	}
}

public function convertIcmType(item:Object,column:DataGridColumn):String{
	var itemlabel:String = item.icmtype+"";
	
	switch(itemlabel){	
		case "0":
			return "单项";
			break;
		case "1":
			return "区间";
			break;
		case "2":
			return "多选";
			break;
		case "3":
			return "是否BIT型";
			break;
		default:
			break;
	}
	return "";
}