import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.TextInput;
import mx.core.UIComponent;
import mx.events.DataGridEvent;
import mx.events.DataGridEventReason;
import mx.events.FlexEvent;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.evts.EventAdv;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.sysmanage.AC_createTableView;

public var itemtype:String="onGiveUp";
public var curitem:Object;
public var old_curitem:Object;
public var curindex:int;
public var curccaption:String;
public var curcmemo:String;

[Bindable]
public var groupArr:ArrayCollection =new ArrayCollection([
	{value:0,label:"字符"},
	{value:1,label:"整型"},
	{value:2,label:"浮点"},
	{value:3,label:"日期"},
	{value:4,label:"布尔"},
	{value:5,label:"文本"}
]);

[Bindable]
public var tablenameArr:ArrayCollection;

[Bindable]
public var fieldArr:ArrayCollection;

[Bindable]
public var isCheckBoxEnable:Boolean=false;

public var old_fieldArr:ArrayCollection = new ArrayCollection();

public var delfieldArr:ArrayCollection = new ArrayCollection();

private static var dateFormatter:DateFormatter = new DateFormatter();
/**
 * 模块说明：获得物理表名列表
 * 创建人：刘磊
 * 创建日期：2012-2-8
 * 修改人：
 * 修改日期：
 *
 */
public function get_bywhere_sysobjects():void
{
	this.additionicon.setStyle("icon",ConstsModel._ADDITIONICON);
	this.additionicon.addEventListener(MouseEvent.CLICK,addNewItem);
	this.additionicon.visible=false;
	this.subtractionicon.setStyle("icon",ConstsModel._SUBTRACTIONICON);
	this.subtractionicon.addEventListener(MouseEvent.CLICK,deleteItem);
	this.subtractionicon.visible=false;
	CRMtool.toolButtonsEnabled(this.lbr_table,null);
	AccessUtil.remoteCallJava("sysobjectsViewDest","get_bywhere_sysobjects",onget_bywhere_sysobjects,null,null,true);
}

public function addNewItem(event:MouseEvent):void
{
	fieldArr=this.dgrd_fields.dataProvider as ArrayCollection;
	var obj:Object=new Object();
	obj.iid="";
	obj.itable="";
	obj.cfield="";
	obj.ccaption="";
	obj.idatatype=0;
	obj.ilength=100;
	obj.bempty=true;
	obj.bkey=false;
	obj.cmemo=null;
	
	fieldArr.addItem(obj);
}

public function deleteItem(event:MouseEvent):void{
	if(fieldArr==null||fieldArr.length==0){
		
	}else{
		if(this.dgrd_fields.selectedItem==null){
			CRMtool.tipAlert("请选择要删除的数据");
			return;
		}else{
			if(this.dgrd_fields.selectedItem.cfield=="iid"){
				CRMtool.tipAlert("无法删除iid");
				return;
			}
			var index:int=this.dgrd_fields.selectedIndex;
			if(fieldArr.getItemAt(index).iid!=""){
				delfieldArr.addItem(this.dgrd_fields.selectedItem);
			}
			fieldArr.removeItemAt(index);
		}
	}
}

public function onget_bywhere_sysobjects(evt:ResultEvent):void
{
	tablenameArr=evt.result as ArrayCollection;
}


/**
 * 模块说明：获得字段信息列表
 * 创建人：刘磊
 * 创建日期：2012-2-8
 * 修改人：
 * 修改日期：
 *
 */
public function get_bywhere_AC_fields(condition:String):void
{
	AccessUtil.remoteCallJava("AC_fieldsViewDest","get_bywhere_AC_fields",onget_bywhere_AC_fields,condition,null,false);
}
public function onget_bywhere_AC_fields(evt:ResultEvent):void
{
	fieldArr=evt.result as ArrayCollection;
}
/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-22
 * 功能：全表格搜索定位
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
protected function tnp_search_searchHandler(itype:int):void
{
	if (itype==0)
	{
	    CRMtool.dataGridSearchLocate(this.dgrd_tablename,this.tnp_search0.text);
	}
	else
	{
		CRMtool.dataGridSearchLocate(this.dgrd_fields,this.tnp_search1.text);
	}
}
//窗体初始化
public function onWindowInit():void
{
}
//窗体打开
public function onWindowOpen():void
{
	CRMtool.toolButtonsEnabled(this.lbr_table,null);
	curitem=null;
	this.dgrd_tablename.selectedIndex=-1;
	this.dgrd_fields.dataProvider=null;
	AccessUtil.remoteCallJava("sysobjectsViewDest","get_bywhere_sysobjects",onget_bywhere_sysobjects,null,null,true);
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{	
}

/**
 * 
 * 作者：XZQWJ
 * 日期：2013-01-29
 * 功能：增加数据库中的表
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
public function onNew(event:Event):void
{
	curitem=null;
	var obj:Object=new Object();
	obj.name="";
	obj.ccaption="";
	obj.cmemo="";
	obj.iid="";
	tablenameArr.addItemAt(obj,0);
	fieldArr.removeAll();
	this.dgrd_tablename.editable=true;
	this.dgrd_fields.editable=true;
	this.additionicon.visible=true;
	this.subtractionicon.visible=true;
	this.isCheckBoxEnable=true;
	itemtype="onNew";
	CRMtool.toolButtonsEnabled(this.lbr_table,itemtype);
}
//修改时
public function onEdit(event:Event):void
{
	delfieldArr=new ArrayCollection();
	if (this.dgrd_tablename.selectedItem)
	{
		this.additionicon.visible=true;
		this.subtractionicon.visible=true;
	   this.dgrd_tablename.editable=true;
	   this.dgrd_fields.editable=true;
	   this.isCheckBoxEnable=true;
	   itemtype="onEdit";
	   CRMtool.toolButtonsEnabled(this.lbr_table,itemtype);
	   curitem=this.dgrd_tablename.selectedItem;
	   old_curitem=CRMtool.ObjectCopy(this.dgrd_tablename.selectedItem);
	   old_fieldArr=CRMtool.copyArrayCollection(fieldArr);
	   curccaption=curitem.ccaption;
	   curcmemo=curitem.cmemo;
	   curindex=this.dgrd_tablename.selectedIndex;
	}
	else
	{
		CRMtool.tipAlert("请先选择需要修改的表！");
	}
}

public function checkCreateTable(arr:ArrayCollection):String{
	
	var Msg:String="";
	for(var i:int=0;i<arr.length;i++){
		var item:Object=arr.getItemAt(i);
		if(CRMtool.isStringNull(item.cfield as String)){
			Msg="第"+(i+1)+"行字段名不能为空!请确认!"
			//			CRMtool.tipAlert("第"+(i+1)+"行字段名不能为空!请确认!");
			break;
		}
		
//		if(item.idatatype==""||item.idatatype==null){
//			Msg="第"+(i+1)+"行字段类型不能为空!请确认!";
//			//			CRMtool.tipAlert("第"+(i+1)+"行字段类型不能为空!请确认!");
//			break;
//		}else{
			if(item.ilength==""){
				Msg="第"+(i+1)+"行字段长度不能为空!请确认!";
				//				CRMtool.tipAlert("第"+(i+1)+"行字段长度不能为空!请确认!");
				break;
			}else{
				if(item.idatatype==0&&item.ilength=="0"){
					Msg="第"+(i+1)+"行字段类型为<字符>，其长度不能为零!请确认!";
					//					CRMtool.tipAlert("第"+(i+1)+"行字段类型为<字符>，其长度不能为零!请确认!");
					break;
				}else if(item.ilength>4000){
					Msg="第"+(i+1)+"行字段长度只能小于4000!请确认!";
					break;
				}
			}
//		}
		
		if(item.bkey as Boolean){
			if(item.bempty as Boolean){
				Msg="第"+(i+1)+"行字段为关键字，不能为空!请确认!";
				break;
			}
		}
		
	}
	return Msg;
	
}

//保存时
public function onSave(event:Event=null):void
{
	
//	var sql:String="select * from sysobjects where id = object_id(N'#tableName#') and objectproperty(id,'IsTable')=1";
	if(itemtype=="onEdit"){
		if(fieldArr==null || fieldArr.length==0){
			CRMtool.tipAlert("表字段不能为空!请确认!");
			return;
		}else {
				var msg:String=checkCreateTable(fieldArr);
				if(CRMtool.isStringNotNull(msg)){
					CRMtool.tipAlert(msg);
					return;
				}
			
		}
		var obj:Object=new Object();
		var old_tablename:String=old_curitem.name as String;
		var new_tablename:String=this.dgrd_tablename.selectedItem.name as String;
		if(old_tablename==new_tablename){
			obj.sql="";
		}else{
			obj.sql="exec sp_rename '"+old_tablename+"','"+new_tablename+"'";
		}
		obj.head=this.dgrd_tablename.selectedItem;
		obj.body=fieldArr;
		obj.old_body=old_fieldArr;
		obj.delfieldArr=delfieldArr;
		//AccessUtil.remoteCallJava("AC_tableViewDest","Add_All",onAdd_All,obj,null,true);
		AccessUtil.remoteCallJava("AC_tableViewDest","Update_All",onSave_All,obj,null,true);
		this.dgrd_tablename.editable=false;
		this.dgrd_fields.editable=false;
		additionicon.visible=false;
		subtractionicon.visible=false;
		this.isCheckBoxEnable=false;
		itemtype="onSave";
		CRMtool.toolButtonsEnabled(this.lbr_table,itemtype);
		
	}else{//增加保存 XZQWJ
		var hasIid:Boolean = false;//必须添加iid
		if(tablenameArr.getItemAt(0).name==""){
			CRMtool.tipAlert("表名不能为空，请确认！");
			return;
		}
		var tableName:String=tablenameArr.getItemAt(0).name as String;
		var ccaption:String=(tablenameArr.getItemAt(0).ccaption=="")?"":tablenameArr.getItemAt(0).ccaption as String;
		var cmemo:String=(tablenameArr.getItemAt(0).cmemo=="")?"":tablenameArr.getItemAt(0).cmemo as String;
		if(fieldArr==null || fieldArr.length==0){
			CRMtool.tipAlert("表字段不能为空!请确认!");
			return;
		}else {
			for each(var item:Object in fieldArr) {
				if(item.ilength > 4000) {
					CRMtool.tipAlert("字符长度不能超过4000!");
					return;
				}
				if(item.cfield==""){
					CRMtool.tipAlert("字段不能为空!");
					return;
				}
				if(item.cfield == "iid") {
					hasIid = true;
				}
			}
		}
		if(hasIid) {
			var msg:String=checkCreateTable(fieldArr);
			if(CRMtool.isStringNotNull(msg)){
				CRMtool.tipAlert(msg);
				return;
			}
			var sql:String="select * from sysobjects where id = object_id(N'"+StringUtil.trim(tableName)+"') and objectproperty(id,'IsTable')=1";
			//		sql=sql.replace("#tableName#",StringUtil.trim(tableName));
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(event:ResultEvent):void{
				var arr:ArrayCollection = event.result as ArrayCollection;
				if(arr.length==0){
					var creatTableSql:String="CREATE TABLE ["+StringUtil.trim(tableName)+"] (";
					var sql_con:String=createSql();
					creatTableSql=creatTableSql+sql_con+" CONSTRAINT [PK_"+StringUtil.trim(tableName)+"] PRIMARY KEY  CLUSTERED ( "+" iid ) ON [PRIMARY] ) ON [PRIMARY]  ";
					trace(creatTableSql);
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(event:ResultEvent):void{
						var cntableName:String=StringUtil.trim(ccaption);
						dateFormatter.formatString="YYYY-MM-DD JJ:NN:SS";
						
						
						var insertSql:String="insert into ac_createTableLog(ctablename,ctablenamecn,imaker,dmaker,dr) values('"+StringUtil.trim(tableName)+"','"+cntableName+"',"+CRMmodel.userId+",'"+CRMtool.getNowDateHNS()+"',0)";
						
						
						var param:Object=new Object();
						param.tablename=StringUtil.trim(tableName);
						param.tablenamecn=cntableName;
						param.vmeno=StringUtil.trim(cmemo);
						param.insertSql=insertSql;
						param.value=fieldArr;
						AccessUtil.remoteCallJava("CommonalityDest", "executeSqlList",function(evt:ResultEvent):void{
							
							tablenameArr.getItemAt(0).iid=evt.result;
							CRMtool.tipAlert("生成成功");
							
							itemtype="onSave";
							CRMtool.toolButtonsEnabled(lbr_table,itemtype);
							isCheckBoxEnable=false;
							dgrd_tablename.editable=false;
							dgrd_fields.editable=false;
							additionicon.visible=false;
							subtractionicon.visible=false;
							get_bywhere_AC_fields("itable="+dgrd_tablename.selectedItem.iid);
						},param);
						
					},creatTableSql);
				}else{
					CRMtool.tipAlert("表<"+StringUtil.trim(tableName)+">存在，请重新输入新增表名!");
				}
			},sql);
		}else {
			CRMtool.tipAlert("请增加主键iid!");
		}
		
	}
	
}
//XZQWJ 2013-02-02
private function createSql():String{
	var l:int=fieldArr.length;
	var sql:String="";
	for each(var item:Object in fieldArr){
		if(StringUtil.trim((item.cfield as String))=="iid"){
			sql=sql+" [iid] [int] IDENTITY (1, 1) NOT NULL , ";
			continue;
		}
		sql=sql+"["+item.cfield+"]";
		var datatype:String=getdatatype(item);
		if(item.idatatype==0){
			sql=sql+" ["+datatype+"] ("+item.ilength+") COLLATE Chinese_PRC_CI_AS ";
			if(item.bempty){
				sql=sql+" NULL ,";
			}else{
				sql=sql+" NOT NULL ,";
			}
			continue;
		}
		sql=sql+" ["+datatype+"]";
		if(item.bempty){
			sql=sql+" NULL ,";
		}else{
			sql=sql+" NOT NULL ,";
		}
		
	}
	return sql;
}

public function onSave_All(evt:ResultEvent):void
{
	if (evt.result.toString()=="fail")
	{
		CRMtool.showAlert("数据字典保存失败！");
	}else{
		get_bywhere_AC_fields("itable="+dgrd_tablename.selectedItem.iid);
		CRMtool.showAlert("数据字典保存成功！");
	}
}
//放弃时
public function onGiveUp(event:Event=null):void
{
	if(itemtype=="onNew"){
		this.dgrd_tablename.editable=false;
		this.dgrd_fields.editable=false;
		this.additionicon.visible=false;
		this.subtractionicon.visible=false;
		this.isCheckBoxEnable=false;
		fieldArr=new ArrayCollection();
		tablenameArr.removeItemAt(0);
		itemtype="onGiveUp";
		CRMtool.toolButtonsEnabled(this.lbr_table,itemtype);
	}else{
		curitem.ccaption=curccaption;
		curitem.cmemo=curcmemo;
		dgrd_tablename.selectedItem=curitem;
		dgrd_tablename.scrollToIndex(curindex);
		//装载字段列表
		get_bywhere_AC_fields("itable="+curitem.iid);
		
		this.dgrd_tablename.editable=false;
		this.dgrd_fields.editable=false;
		this.additionicon.visible=false;
		this.subtractionicon.visible=false;
		this.isCheckBoxEnable=false;
		itemtype="onGiveUp";
		CRMtool.toolButtonsEnabled(this.lbr_table,itemtype);
	}
}
//更新时
public function onUpdate(event:Event=null):void
{
	AccessUtil.remoteCallJava("AC_tableViewDest","pr_updatedatadic",on_pr_updatedatadic,null,null,true);
	itemtype="onUpdate";
	CRMtool.toolButtonsEnabled(this.lbr_table,itemtype);	
}

public function onDel():void
{
	var tablename:Object=this.dgrd_tablename.selectedItem.name ;
	var drop_table_sql:String="DROP TABLE "+tablename;
	
	var del_table_fields:String="delete ac_fields where itable in ( select iid from ac_table where ctable ='"+tablename+"')";
	var del_table:String="delete ac_table where ctable='"+tablename+"'";
	var param:Object=new Object();
	param.sqlValue=del_table_fields+";"+del_table+";";
		AccessUtil.remoteCallJava("AC_tableViewDest","del_AC_table",function(event:ResultEvent):void{
			if (event.result.toString()=="sucess"){
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(event:ResultEvent):void{
					tablenameArr.removeItemAt(dgrd_tablename.selectedIndex);
					fieldArr=new ArrayCollection();
					CRMtool.tipAlert("删除成功！");
				},drop_table_sql);
			}else{
				CRMtool.tipAlert("删除失败！");
			}
		},param);
		
	
}

//删除表 XZQWJ 2013-02-04
public function onDelete(event:Event=null):void
{
	if (this.dgrd_tablename.selectedItem){
		var tablename:Object=this.dgrd_tablename.selectedItem.name ;
		CRMtool.tipAlert1("确定要删除当前表<"+tablename+">，删除表可能影响系统正常使用?",null,"AFFIRM",onDel,null);
	}else{
		CRMtool.tipAlert("请先选择删除的表！");
	}
}
public function on_pr_updatedatadic(evt:ResultEvent):void
{
	if (evt.result.toString()=="sucess")
	{
		get_bywhere_sysobjects();
		//装载字段列表
		if (dgrd_tablename.selectedItem)
		{
		   get_bywhere_AC_fields("itable="+dgrd_tablename.selectedItem.iid);
		}
	}
}
//页面装载时
protected function hbox1_creationCompleteHandler(event:FlexEvent):void
{
	get_bywhere_sysobjects();
}

protected function dgrd_tablename_doubleClickHandler(event:MouseEvent):void
{
	// TODO Auto-generated method stub
	var obj:Object=new Object();
	obj.head=dgrd_tablename.selectedItem;
	obj.body=dgrd_fields.dataProvider;
	
	var ass:AC_createTableView = new AC_createTableView();
	ass.isShowList =2;
	ass.width=700;
	ass.height = 500;
	ass.owner = this;
	ass.isFand=true;
	ass.value=obj;
	CRMtool.openView(ass)
	
}

//点击左侧列表时
protected function dgrd_tablename_clickHandler(event:MouseEvent):void
{
	if (dgrd_tablename.selectedItem)
	{
	   var iid:int=dgrd_tablename.selectedItem.iid;
	   //设置编辑状态
	   if (curitem!=null && (itemtype=="onEdit"|| itemtype=="onNew"))
	   {
		   dgrd_tablename.editable=(dgrd_tablename.selectedItem==curitem);
		   dgrd_fields.editable=(curitem.iid==iid);
		   if (!dgrd_tablename.editable)
		   {
			   if(iid>0){
				   CRMtool.tipAlert1("确定保存当前编辑数据?",null,"AFFIRM",onSave,function():void{
					   onGiveUp();
				   });
			   }
		   }
	   }else if(curitem==null && itemtype=="onNew"){
		   if(iid>0){
			   CRMtool.tipAlert1("确定保存当前编辑数据?",null,"AFFIRM",onSave,function():void{
				   onGiveUp();
			   });
		   }else{
			   //装载字段列表
			   get_bywhere_AC_fields("itable="+iid);
		   }
	   }
	  else{
		   //装载字段列表
		   get_bywhere_AC_fields("itable="+iid);
	   }
	}
}

public function onEditEnd(event:DataGridEvent):void{
	
	var cols:DataGridColumn=dgrd_fields.columns[event.columnIndex];   
	var beingEditField:String = event.dataField;  //获得当前列的dataField  
	var oldLocal:String = event.itemRenderer.data[beingEditField];   
	var newLocale:String = dgrd_fields.itemEditorInstance[cols.editorDataField]; 
	if(beingEditField=="cfield"){
		for(var i:int=0;i<fieldArr.length;i++){
			if(i!=this.dgrd_fields.selectedIndex){
				if(newLocale==fieldArr.getItemAt(i)[beingEditField] as String){
					event.preventDefault();
				}
			}
		}
	}else if(beingEditField=="ilength"){
		if(newLocale==""){
			event.preventDefault();//恢复本来数据   
		}
	}
}

public function onTabelNameEditEnd(event:DataGridEvent):void{
	
	var cols:DataGridColumn=dgrd_tablename.columns[event.columnIndex];   
	var beingEditField:String = event.dataField;  //获得当前列的dataField  
	var oldLocal:String = event.itemRenderer.data[beingEditField];   
	var newLocale:String = dgrd_tablename.itemEditorInstance[cols.editorDataField]; 
	 if(beingEditField=="name"){
		for(var i:int=0;i<tablenameArr.length;i++){
			if(i!=this.dgrd_tablename.selectedIndex){
				if(newLocale==tablenameArr.getItemAt(i)[beingEditField] as String){
					event.preventDefault();
				}
			}
		}
	}
}

public function getdatatype(item:Object):String{
	
	var lbltext:String;
	switch(item.idatatype)
	{
		case 0:
		{
			lbltext="nvarchar";
			break;
		}
		case 1:
		{
			lbltext="int";
			break;
		}
		case 2:
		{
			lbltext="float";
			break;
		}
		case 3:
		{
			lbltext="datetime";
			break;
		}
		case 4:
		{
			lbltext="bit";
			break;
		}
		case 5:
		{
			lbltext="text";
			break;
		}
	}
	return lbltext;	
	
}

//翻译数据类型
public function getdatatypelabel(item:Object,icol:int):String
{
	var lbltext:String;
	switch(item.idatatype)
	{
		case 0:
		{
			lbltext="字符";
			break;
		}
		case 1:
		{
			lbltext="整型";
			break;
		}
		case 2:
		{
			lbltext="浮点";
			break;
		}
		case 3:
		{
			lbltext="日期";
			break;
		}
		case 4:
		{
			lbltext="布尔";
			break;
		}
		case 5:
		{
			lbltext="文本";
			break;
		}
	}
	return lbltext;	
}

//
//private function validateItem(event:DataGridEvent):void{
//	if(event.reason==DataGridEventReason.CANCELLED){
//		return;
//	}
//	
//	var input:TextInput = TextInput(dgrd_fields.itemEditorInstance);
//	var newData:String= TextInput(event.currentTarget.itemEditorInstance).text;
//	if((event.dataField == "cfield" || event.dataField=="ilength") && StringUtil.trim(newData).length<=0){
//		event.preventDefault();
//		var field_name:String="";
//		if(event.dataField == "cfield"){
//			field_name="字段";
//		}else{
//			field_name="长度";
//		}
//		input.errorString="<"+field_name+">不能为空！";
//	}
//
//	
//}
