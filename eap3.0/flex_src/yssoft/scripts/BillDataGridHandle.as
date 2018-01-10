/*
模块名称：单据中的DataGrid相关操作
模块功能：业务单据中主子表关联的子表信息操作
现阶段实现的功能：
1、子表信息的内部计算

创建者：		YJ	
创建日期：	2011-11-23
修改者：
修改日期：

*/
import flash.events.Event;
import flash.events.FocusEvent;
import flash.utils.Timer;
import flash.utils.setTimeout;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.INavigatorContent;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import spark.primitives.Rect;

import yssoft.comps.ConsultList;
import yssoft.comps.ConsultTree;
import yssoft.comps.ConsultTreeList;
import yssoft.evts.SumEvent;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.tools.LoginTool;
import yssoft.views.msg.OA_noticeView;
import yssoft.vos.AcConsultsetVo;

public var cselsetvalues:String = "";//承载表头参照赋值公式
[Bindable]
public var consultdg:String = "";//承载参照中的需要赋值的DataGrid

[Bindable]
public var operationArr:ArrayCollection = new ArrayCollection();//("s"," j=s@*d@|c="备注" ")
//承载表达式记录集
[Bindable]
public var expressionArr:ArrayCollection = null;//("j","s@*d@"    "c","备注")
//承载字段记录集
[Bindable]
public var fieldsArr:ArrayCollection = new ArrayCollection();
//承载表达式中存在的字段记录集
[Bindable]
public var operFieldsArr:ArrayCollection = null;
//承载DataGrid
[Bindable]
private var operationDataGrid:DataGrid = new DataGrid();

public var curroperation:String = "";//承载当前的整个表达式

public var jharr:Array = null;//承载聚合函数的集合

/**************************   YJ Add  DataGrid与表头的互动运算操作   ******************************************/

[Bindable]private var _flag:String = "";//标识参与何种运算
[Bindable]private var _param:String = "";//运算参数，哪个字段参与运算(表名.字段名)
[Bindable]private var _funname:Function = null;//调用外部的方法名称
[Bindable]private var _operation:String = "";//外部公式

//属性定义
public function set flag(value:String):void{
	_flag = value;
}
public function set param(value:String):void{
	_param = value;
}
public function set funname(value:Function):void{
	_funname = value;
}
public function set operation(value:String):void{
	_operation = value;
}
/**End**/



/*
函数名称：onDataGridOperation
函数功能：初始化DataGrid需要运算的元素
函数参数：tableArr(表结构记录集)
创建者：  YJ
创建日期：2011-11-23
*/
public function onDataGridOperation(tableArr:ArrayCollection,paramDg:DataGrid,dgcaption:String):void{
	this.operationDataGrid = paramDg;
	this.fieldsArr = tableArr;
	
	//初始化表达式、字段的记录集
	iniArr();
	
}


/*
函数名称：iniArr
函数功能：赋值于operationArr
函数参数：tableArr(表结构记录集)
创建者：  YJ
创建日期：2011-11-23
*/
private function iniArr():void{
	
	//赋值于operationArr(表达式记录集)
	for(var i:int=0;i<fieldsArr.length;i++){
		
		var cfunction:String = fieldsArr[i]["cfunction"];//计算公式
		var cfield:String = fieldsArr[i]["cfield"];
		
		if(cfunction != null && cfunction != ""){
			var obj:Object = {};
			obj.operation = cfunction;
			obj.cfield = cfield;
			operationArr.addItem(obj);
		}
		
	}
	
	//如果表达式为空并且约束表达式为空，直接返回
	if(operationArr.length==0 && restrainArr.length==0) return;
	
	if(operationArr.length >0){
		//内部计算需要注册的监听事件
		if(operationDataGrid.hasEventListener(DataGridEvent.ITEM_FOCUS_OUT)){
			operationDataGrid.removeEventListener(DataGridEvent.ITEM_FOCUS_OUT,onItemFocusOut);
		}
		operationDataGrid.addEventListener(DataGridEvent.ITEM_FOCUS_OUT,onItemFocusOut,false,0,true);
		
	}
	
	//约束
	if(restrainArr.length >0){
		if(operationDataGrid.hasEventListener(DataGridEvent.ITEM_EDIT_END)){
			operationDataGrid.removeEventListener(DataGridEvent.ITEM_EDIT_END,onItemEnd);
		}
		operationDataGrid.addEventListener(DataGridEvent.ITEM_EDIT_END,onItemEnd,false,0,true);
	}
	
}

//DataGrid 单元格离开事件
private function onItemFocusOut(event:DataGridEvent):void{
	
	//当前操作的字段
	var cfield:String = (event.target as DataGrid).columns[event.columnIndex].dataField+"";
	//当前操作的行记录集
	var dataItem:Object = event.itemRenderer.data;
	
	//依据当前字段查找对应的表达式
	if(onFindOperation(cfield)){
		
		//解析公式(公式会存在多个)
		onAnalysisExpression();
		
		//解析表达式
		onAnalysisOperation(dataItem);
		
		//赋值表达式
		onVoluationOperation(dataItem);
		
	}
}

//DataGrid中数据约束分析
//参数：cfield-验证约束的字段，data-记录集
public function onItemEnd(event:DataGridEvent):void{
	//	var dataItem:Object = event.itemRenderer.data;
	//检查约束
	if(this.restrainArr != null && this.restrainArr.length>0) {
		onCheckCres(event);
	}
	
	//	//计算运算公式
	//	
	//	//获取当前字段的计算公式
	//	var stropera:String = onFindOperation(event.dataField);
	//	if(stropera == "") {return;}//公式为空，直接返回
	//	
	//	//解析公式(公式会存在多个)
	//	onAnalysisExpression();
	//	
	//	//解析表达式
	//	onAnalysisOperation(dataItem);
	//	
	//	//赋值表达式
	//	onVoluationOperation(dataItem);
}

//private function onFindOperation(field:String):String{
//	
//	for(var i:int=0;i<operationArr.length;i++){
//		
//		var cfield:String = operationArr[i]["cfield"];
//		if(field == cfield){
//			//完整的公式	或者存在多个公式	"(A=B@+C@)|(D=J@-F@)"
//			curroperation = operationArr[i]["operation"];
//			return curroperation;
//		}
//	}
//	return "";
//}


//查找该字段是否参与了公式计算,是-True，否-False
private function  onFindOperation(paramfield:String):Boolean{
	
	for(var i:int=0;i<operationArr.length;i++){
		
		var cfield:String = operationArr[i]["cfield"];
		if(paramfield == cfield){
			//完整的公式	或者存在多个公式	"(A=B@+C@)|(D=J@-F@)"
			curroperation = operationArr[i]["operation"];
			return true;
		}
		
	}
	return false;
	
}

//解析公式(公式会存在多个)
private function onAnalysisExpression():void{
	
	var exArr:Array = curroperation.split("|");
	expressionArr = new ArrayCollection();
	
	for(var i:int=0;i<exArr.length;i++){
		
		var obj:Object = {};
		obj.result 		= getResultField(exArr[i]);
		obj.expression 	= getExpression(exArr[i]);
		obj.type		= getResultType(obj.result);
		
		expressionArr.addItem(obj);
		
	}
	
}

//获取表达式中的赋值字段
private function getResultField(operation:String):String{
	
	return operation.substr(0,operation.indexOf("="));
	
}

//获取表达式中的公式
private function getExpression(operation:String):String{
	
	return operation.substr(operation.indexOf("=")+1,operation.length);
	
}

//查找结果字段的数据类型
private function getResultType(fieldname:String):String{
	
	var fieldtype:String = "nvarchar";
	
	for(var i:int=0;i<fieldsArr.length;i++){
		var field:String = fieldsArr[i]["cfield"];
		if(fieldname == field){
			fieldtype = fieldsArr[i]["idatatype"];
			break;
		}
	}
	
	return fieldtype;
	
}

//解析表达式
private function onAnalysisOperation(dataItem:Object):void{
	
	operFieldsArr = new ArrayCollection();
	jharr = new Array();
	
	//依据表达式解析出字段
	for(var i:int=0;i<fieldsArr.length;i++){
		
		var fieldName:String = fieldsArr[i]["cfield"];//字段名称
		var fieldType:String = fieldsArr[i]["idatatype"];//字段类型
		
		for(var j:int=0;j<expressionArr.length;j++){
			
			var obj:Object = {};
			var result:String = expressionArr[j]["result"];//赋值字段
			var exp:String = expressionArr[j]["expression"];//表达式
			
			//字段存在于表达式
			if(exp.indexOf("@"+fieldName+"@") != -1){
				
				obj.fieldname = fieldName;
				
				//分析数据类型
				obj.fieldvalue = onGetValueByType(fieldType,dataItem[fieldName]);
				
				this.operFieldsArr.addItem(obj);
				
			}
			else if(exp.indexOf("getcol") !=-1 && exp.indexOf(fieldName) != -1){
				
				//初始化聚合函数的一些参数信息
				var param:String = result+"="+exp;
				obj.param = param;
				this.jharr.push(obj);
				
			}
			
		}
		
	}
	
}

//赋值表达式,带入值，并获取最后的执行结果
private function onVoluationOperation(dataItem:Object):void{
	
	var strreturn:String = "";
	var paramArr:ArrayCollection = new ArrayCollection();//传入后台的数据集
	
	for(var i:int=0;i<expressionArr.length;i++){
		
		var field:String = expressionArr[i]["result"];//结果需要赋值的字段
		var type:String = expressionArr[i]["type"];//结果需要赋值的字段的数据类型
		var exp:String = expressionArr[i]["expression"];//表达式
		
		if(exp.indexOf("getcol") !=-1) continue;
		
		strreturn = exp;
		
		for(var j:int=0;j<operFieldsArr.length;j++){
			
			strreturn = this.StringReplaceAll(strreturn,"@"+operFieldsArr[j]["fieldname"]+"@",operFieldsArr[j]["fieldvalue"]);
			
		}
		
		if(strreturn.indexOf("@") != -1) return;//没有替换完全
		
		//分析当前的表达式是否被替换，如果没有，则该表达式有可能是字符串或者sql函数
		if(strreturn == exp){
			if(type == "nvarchar" || type == "varchar"){//字符串类型 ， 替换"`" 为 单引号
				strreturn = StringReplaceAll(strreturn,"`","'")
			}
		}
		
		var objparam:Object = {};
		objparam.resultfield = field;
		objparam.resulttype = type;
		objparam.expression = strreturn;
		
		paramArr.addItem(objparam);
	}
	
	var obj:Object = {};
	obj.exparr = paramArr;
	
	//调用后台方法
	AccessUtil.remoteCallJava("CompetitorDest","onGetResult",function(evt:ResultEvent):void{
		getValue(evt,dataItem);
		
		if(jharr.length >0){
			for(var k:int=0;k<jharr.length;k++){
				onCallAggregation(jharr[k].param);//调用聚合函数
			}
		}
		
	},obj,null,false);
	
}

//获取值，并赋值
public function getValue(event:ResultEvent,items:Object):void
{
	var rArr:ArrayCollection = event.result.rlist as ArrayCollection;//返回的记录集
	
	var index:int=(this.operationDataGrid.dataProvider as ArrayCollection).getItemIndex(items);
	
	if(rArr == null || rArr.length==0) return;
	
	for(var i:int=0;i<rArr.length;i++){
		var cfield:String = rArr[i]["resultfield"];
		var cftype:String = rArr[i]["resulttype"];//字段类型
		var cvalue:String = rArr[i]["rvalue"].value;
		
		items[cfield] = onGetValueByType(cftype,cvalue);
	}
	(this.operationDataGrid.dataProvider as ArrayCollection).setItemAt(items,index);
	(this.operationDataGrid.dataProvider as ArrayCollection).refresh();
}

private function onGetValueByType(fieldtype:String,fieldvalue:Object):Object{
	
	var robj:Object = {};
	
	if(fieldvalue == null || fieldvalue == ""){return onGetNullValue(fieldtype);}
	
	switch(fieldtype){
		case "int":
			robj = int(fieldvalue+"");
			break;
		case "float":
			robj = Number(fieldvalue);
			break;
		case "nvarchar":
			robj = fieldvalue;
			break;
		case "varchar":
			robj = fieldvalue;
			break;
		case "datetime":
			robj = onGetFDate(fieldvalue,1);
			break;
		default:
			break;
	}
	
	return robj;
	
}


private function onGetNullValue(fieldtype:String):Object{
	
	var robj:Object = {};
	
	switch(fieldtype){
		case "int":
			robj = 0;
			break;
		case "float":
			robj = 0.0;
			break;
		case "nvarchar":
			robj = "";
			break;
		case "varchar":
			robj = "";
			break;
		case "datetime":
			robj = "";
			break;
		default:
			robj = "";
			break;
	}
	
	return robj;
}

/** 
 * onGetFDate	获取格式化后的日期 
 * @param dvalue:Object 日期值
 * @param flag:int      标识(0：完整日期带时间  1:日期 ) 
 * @return Object		返回格式化后的日期值 
 * **/ 
private function onGetFDate(dvalue:Object,flag:int):Object{
	
	var robj:Object = {};
	var dateFormatter:DateFormatter = new DateFormatter();
	
	switch(flag){
		case 0:
			dateFormatter.formatString = "YYYY-MM-DD HH:NN:SS";
			robj = dateFormatter.format(dvalue);
			break;
		case 1:
			dateFormatter.formatString = "YYYY-MM-DD";
			robj = dateFormatter.format(dvalue);
			break;
		default:
			break;
	}
	
	return robj;
}

/** 
 * StringReplaceAll 
 * @param source:String 源数据 
 * @param find:String 替换对象 
 * @param replacement:Sring 替换内容 
 * @return String 
 * **/  
private function StringReplaceAll( source:String, find:String, replacement:String ):String{  
	return source.split( find ).join( replacement );  
}  


/**************************************	YJ Add 聚合函数运算	*******************************************/

/** 
 * onCallAggregation
 * @param exp:String 表达式 
 * @return void 
 * **/ 
private function onCallAggregation(exp:String):void{
	
	//sa_quantion.fsum=getcolsum(ftaxsum)
	
	var hfield:String = exp.substring(0,exp.indexOf("="));//sa_quantion.fsum
	var strexp:String = exp.substring(exp.indexOf("=")+1,exp.indexOf("("));//getcolsum
	var bfield:String = exp.substring(exp.indexOf("(")+1,exp.indexOf(")"));//ftaxsum
	
	switch(strexp){
		case "getcolsum":
			onGetColSum(hfield,bfield);
			break;
		case "getcolavg":
			onGetColAvg(hfield,bfield);
			break;
		case "getcolmax":
			onGetColMax(hfield,bfield);
			break;
		case "getcolmin":
			onGetColMin(hfield,bfield);
			break;
		default:
			break;
	}
	
}

//DataGrid 求和运算  pfield-主表需要赋值的字段,  field-子表需要操作的字段
public function onGetColSum(pfield:String,field:String):void{
	
	//传出参数
	var outparam:Object=onSum(this.operationDataGrid,pfield,field);
	this.subformula(outparam);
}

//求平均
public function onGetColAvg(pfield:String,field:String):void{
	
	//传出参数
	var outparam:Object=onAvg(this.operationDataGrid,pfield,field);
	this.subformula(outparam);
}

//求最大值
public function onGetColMax(pfield:String,field:String):void{
	//传出参数
	var outparam:Object=onMax(this.operationDataGrid,pfield,field);
	this.subformula(outparam);
}

//求最小值
public function onGetColMin(pfield:String,field:String):void{
	//传出参数
	var outparam:Object=onMin(this.operationDataGrid,pfield,field);
	this.subformula(outparam);
}

//主表需要调用的计算聚合函数
//flag-标志(调用哪个聚合函数)，toperation(主表的表达式  fsum=sa_qunation.ftaxsum)
public function onGetColValue(flag:int,toperation:String):Object{
	
	//返回值
	var outparam:Object = {};
	
	if(this.dgnumber.length == 0) return null;
	
	
	switch(flag){
		case 1://求和
			outparam = onGetColSumByT(toperation);
			break;
		case 2://求平均
			outparam = onGetColAvgByT(toperation); 
			break;
		case 3://求最大值
			outparam = onGetColMaxByT(toperation);
			break;
		case 4://求最小值
			outparam = onGetColMinByT(toperation);
			break;
		default:
			break;
	}
	
	return outparam;
	
}

//主表需要调用的聚合函数  (主表参数格式：fsum=sa_qunations.ftaxsum)  求和
public function onGetColSumByT(fullparam:String):Object{
	var pfield:String = fullparam.substring(0,fullparam.indexOf("="));//主表需要赋值的字段
	var tablename:String = fullparam.substring(fullparam.indexOf("=")+1,fullparam.indexOf("."));//表名
	var field:String = fullparam.substring(fullparam.indexOf(".")+1,fullparam.length);//需要赋值的字段
	var outparam:Object = {};
	
	for(var i:int=0;i<dgnumber.length;i++){
		var dg:DataGrid = dgnumber.getItemAt(i) as DataGrid;
		
		if(tablename == dg.id) {
			outparam = onSum(dg,pfield,field);
		}
		
	}
	
	return outparam;
	
}

//主表需要调用的聚合函数 (主表参数格式：fsum=sa_qunations.ftaxsum)  平均
public function onGetColAvgByT(fullparam:String):Object{
	var pfield:String = fullparam.substring(0,fullparam.indexOf("="));//主表需要赋值的字段
	var tablename:String = fullparam.substring(fullparam.indexOf("=")+1,fullparam.indexOf("."));//表名
	var field:String = fullparam.substring(fullparam.indexOf(".")+1,fullparam.length);//需要赋值的字段
	
	var outparam:Object = {};
	
	for(var i:int=0;i<dgnumber.length;i++){
		var dg:DataGrid = dgnumber.getItemAt(i) as DataGrid;
		
		if(tablename == dg.id) {
			outparam = onAvg(dg,pfield,field);
		}
		
	}
	
	return outparam;
	
}
//主表需要调用的聚合函数 (主表参数格式：fsum=sa_qunations.ftaxsum)  最大值
public function onGetColMaxByT(fullparam:String):Object{
	var pfield:String = fullparam.substring(0,fullparam.indexOf("="));//主表需要赋值的字段
	var tablename:String = fullparam.substring(fullparam.indexOf("=")+1,fullparam.indexOf("."));//表名
	var field:String = fullparam.substring(fullparam.indexOf(".")+1,fullparam.length);//需要赋值的字段
	
	var outparam:Object = {};
	
	for(var i:int=0;i<dgnumber.length;i++){
		var dg:DataGrid = dgnumber.getItemAt(i) as DataGrid;
		
		if(tablename == dg.id) {
			outparam = onMax(dg,pfield,field);
		}
		
	}
	
	return outparam;
	
}
//主表需要调用的聚合函数 (主表参数格式：fsum=sa_qunations.ftaxsum)  最小值
public function onGetColMinByT(fullparam:String):Object{
	var pfield:String = fullparam.substring(0,fullparam.indexOf("="));//主表需要赋值的字段
	var tablename:String = fullparam.substring(fullparam.indexOf("=")+1,fullparam.indexOf("."));//表名
	var field:String = fullparam.substring(fullparam.indexOf(".")+1,fullparam.length);//需要赋值的字段
	
	var outparam:Object = {};
	
	for(var i:int=0;i<dgnumber.length;i++){
		var dg:DataGrid = dgnumber.getItemAt(i) as DataGrid;
		
		if(tablename == dg.id) {
			outparam = onMin(dg,pfield,field);
		}
		
	}
	
	return outparam;
	
}

//公共求和方法
private function onSum(dg:DataGrid,pfield:String,field:String):Object{
	//获取DataGrid数据集
	var dgData:ArrayCollection = dg.dataProvider as ArrayCollection;
	var sum:Number=0;
	//传出参数
	var outparam:String="";
	
	//汇总
	for(var i:int=0;i<dgData.length;i++){
		var item:Object = dgData.getItemAt(i);
		var tsum:Number = item[field];
		
		sum+=tsum;
		
	}
	
	outparam = pfield.substr(pfield.indexOf(".")+1,pfield.length)+"="+sum;
	
	return outparam;
}

//公共求平均方法
private function onAvg(dg:DataGrid,pfield:String,field:String):Object{
	//获取DataGrid数据集
	var dgData:ArrayCollection = dg.dataProvider as ArrayCollection;
	var sum:Number=0;
	var avg:Number=0;
	//传出参数
	var outparam:String="";
	
	//汇总 
	for(var i:int=0;i<dgData.length;i++){
		var item:Object = dgData.getItemAt(i);
		var tsum:Number = item[field];
		
		sum+=tsum;
		
	}
	
	avg = sum/dgData.length;
	
	outparam = pfield.substr(pfield.indexOf(".")+1,pfield.length)+"="+avg;
	
	return outparam;
}

//公共求最大值方法
private function onMax(dg:DataGrid,pfield:String,field:String):Object{
	//获取DataGrid数据集
	var dgData:ArrayCollection = dg.dataProvider as ArrayCollection;
	var arr:Array = new Array();
	//传出参数
	var outparam:String="";
	
	for(var i:int=0;i<dgData.length;i++){
		var item:Object = dgData.getItemAt(i);
		arr.push(item[field]);
	}
	
	arr.sortOn(item[field],Array.NUMERIC);
	
	outparam = arr[arr.length-1];
	
	return outparam;
}

//公共求最小值方法
private function onMin(dg:DataGrid,pfield:String,field:String):Object{
	//获取DataGrid数据集
	var dgData:ArrayCollection = dg.dataProvider as ArrayCollection;
	var arr:Array = new Array();
	//传出参数
	var outparam:String="";
	
	for(var i:int=0;i<dgData.length;i++){
		var item:Object = dgData.getItemAt(i);
		arr.push(item[field]);
	}
	
	arr.sortOn(item[field],Array.NUMERIC);
	
	outparam = arr[0];
	
	return outparam;
}


//依附主表赋值,poperation (sa_qunation.cmemo="备注")
public function onSetValueByPTable(poperation:String):void{
	
	var leftstr:String = poperation.substring(0,poperation.indexOf("="));//等号左面的数据
	var tablename:String = leftstr.substring(0,leftstr.indexOf("."));//表名
	var field:String = poperation.substring(leftstr.indexOf(".")+1,leftstr.length);//需要赋值的字段
	var value:String = poperation.substring(poperation.indexOf("=")+1,poperation.length);//值
	
	if(this.dgnumber.length == 0) return;
	
	for(var i:int=0;i<dgnumber.length;i++){
		var dg:DataGrid = dgnumber.getItemAt(i) as DataGrid;
		
		if(tablename != dg.id) continue;
		
		var dgArr:ArrayCollection = dg.dataProvider as ArrayCollection;
		
		if(dgArr.length == 0) continue;
		
		for(var j:int=0;j<dgArr.length;j++){
			var item:Object = dgArr.getItemAt(j);
			item[field] = value;
		}
		
		dg.invalidateList();
	}
	
}

//检查约束
private function onCheckCres(event:DataGridEvent):void{
	var data:Object = {};
	if(((event.currentTarget.itemEditorInstance) as Object).hasOwnProperty("text"))
		data = event.currentTarget.itemEditorInstance.text;
	else if(((event.currentTarget.itemEditorInstance) as Object).hasOwnProperty("te"))//参照
		data = event.currentTarget.itemEditorInstance.te;
	
	for(var i:int=0;i<restrainArr.length;i++){
		var item:Object = restrainArr[i];
		
		var cfield:String 	= item.cfield;//字段
		var cresfun:String 	= item.cresfun;//约束公式
		var cresmes:String	= item.cresmes;//约束提醒信息
		
		//约束限制
		if(event.dataField == cfield){
			//值带入
			var fun:String = "";
			var param:Object = {};
			
			fun = StringReplaceAll(cresfun,cfield,data+"");
			param.cresfun = fun;
			
			//调用后台方法
			AccessUtil.remoteCallJava("CompetitorDest","onGetResFunValue",function(evt:ResultEvent):void{
				var robj:Object = evt.result.rvalue;
				
				if(robj != null && robj.value==0){
					event.preventDefault();
					var rowindex:int = event.rowIndex;
					var columnindex:int = event.columnIndex;
					Alert.show(cresmes,"提示",4,null,function(event:CloseEvent):void{
						//operationDataGrid.editedItemPosition = {columnIndex:columnindex, rowIndex:rowindex};
					});
				}
			},param,null,false);
			
			break;
		}
		
	}
}

[Bindable]
public var subshow:int;//依附表头参照是否弹出子表的参照(0：弹出  1：不弹出)

/** 
 * onSetDataByConsult (依据参照赋值于DataGrid) 
 * @param 	consuid:int	 			参照键值
 * @param 	condition:String  		参照条件 
 * @param 	dgid:String 			DataGrid名称，实际对应的是DataGrid绑定的表名 
 * @param 	cselsetvalues2:String 	表头参照赋值公式
 * @param 	bshow:int				参照是否弹出(0：不弹出，1：弹出)
 * @return 	void 
 * **/  
public function onSetDataByConsult(consuid:int,condition:String,dgid:String,cselsetvalues2:String,bshow:int):void{
	
	if(consuid ==0) return; 
	
	subshow = bshow;
	consultdg = dgid;
	cselsetvalues = cselsetvalues2;
	
	//调用后台方法,获取参照信息
	AccessUtil.remoteCallJava("ConsultDest","getAcConsultsetByID",function(evt:ResultEvent):void{
		var acvArr:ArrayCollection  = evt.result as ArrayCollection;
		var itype:String = acvArr[0]["itype"];//参照类型
		var ballowmulti:Boolean = acvArr[0]["ballowmulti"];//是否多选
		
		if(bshow == 1){//参照弹出
			
			if(itype == "0"){//树参照
				new ConsultTree(onGetReturnValueByTree,consuid,ballowmulti);
			}
			else if(itype == "1"){//列表参照
				new ConsultList(onGetReturnValueByList,consuid,ballowmulti,condition);
			}
			else{
				new ConsultTreeList(onGetReturnValueByList,consuid,ballowmulti,condition);
			}
			
		}
		else{//参照不弹出
			
			onGetBodyDataByConsult(consuid,condition,itype);
			
		}
		
		
	},consuid,null,false);
	
}


/** 
 * onGetReturnValueByTree (树参照返回操作) 
 * @param 	tree:XML	 		树结果集
 * @return 	void 
 * **/
private function onGetReturnValueByTree(tree:XML):void{
	return;
}


/** 
 * onGetReturnValueByTree (列表参照返回操作) 
 * @param 	list:ArrayCollection 列表结果集
 * @return 	void 
 * **/
private function onGetReturnValueByList(list:ArrayCollection):void{
	
	//参照返回数据
	if(list==null || list.length == 0) return;
	if(this.dgnumber.length == 0) return;
	
	onSetDataGridData(list);
}


/** 
 * onGetBodyDataByConsult (参照不弹出直接读取信息返回) 
 * @param 	consuid:int	 		参照键值
 * @param 	condition:String  	参照条件 
 * @param 	itype:String		参照类型
 * @return 	void 
 * **/
private function onGetBodyDataByConsult(consuid:int,condition:String,itype:String):void{
	
	var paraObj:Object = {};
	paraObj.iid = consuid;
	paraObj.childsql = condition;
	paraObj.search = "";
	
	if(itype == "0"){//树参照
		AccessUtil.remoteCallJava("ConsultDest","getAcConsultTreeData",onGetAcConsultTreeDataBack,consuid);
	}
	else if(itype == "1"){//列表
		AccessUtil.remoteCallJava("ConsultDest","getAcConsultListData",onGetAcConsultListDataBack,paraObj);
	}
	else{//左树右表
		
	}
	
}

/** 
 * onGetAcConsultTreeDataBack (树信息读取返回操作)
 * @param 	evt:ResultEvent	 	返回信息
 * @return 	void 
 * **/
private function onGetAcConsultTreeDataBack(evt:ResultEvent):void{
	if(evt.result != null){
		var treexml:XML = new XML(evt.result.treexml as String);
		
		var objInfo:Object = ObjectUtil.getClassInfo(treexml);
		var fieldName:Array = objInfo["properties"] as Array;
	}
	
}

/** 
 * onGetAcConsultListDataBack (列表信息读取返回操作) 
 * @param 	evt:ResultEvent	 	返回信息
 * @return 	void 
 * **/
private function onGetAcConsultListDataBack(evt:ResultEvent):void{
	var listArr:ArrayCollection = evt.result.success as ArrayCollection;
	if(listArr.length == 0) return;
	
	onSetDataGridData(listArr);
}


/** 
 * onSetDataGridData (赋值于DataGrid记录集,公共方法) 
 * @param 	list:ArrayCollection 列表结果集
 * @return 	void 
 * **/
private function onSetDataGridData(datalist:ArrayCollection):void{
	//解析参照赋值公式
	var arr:Array = onAnalysisExp(this.cselsetvalues);
	
	for(var i:int=0;i<dgnumber.length;i++){
		var consultDg:DataGrid = dgnumber.getItemAt(i) as DataGrid;
		
		if(this.consultdg == consultDg.id){
			var dgdata:ArrayCollection = consultDg.dataProvider as ArrayCollection;
			
			if(subshow == 0){//参照不弹出时要处理数据集
				//移除记录集中（subflag=1）的记录
				dgdata = onRemoveData(dgdata);
			}
			
			for(var j:int=0;j<datalist.length;j++){
				var itemobj:Object = {};
				var item:Object = datalist.getItemAt(j);//参照一条记录
				itemobj["subflag"] = 1;//特殊标记，用于移除多余数据
				
				//循环遍历参照公式
				for(var k:int=0;k<arr.length;k++){
					var tempArr:Array = arr[k].toString().split("=");//获取一个元素
					var field:String = tempArr[0]+"";//表字段
					var field2:String = field.substring(field.indexOf(".")+1,field.length);//截取后的表字段
					var confield:String = tempArr[1]+"";//参照字段
					
					
					itemobj[field2] = item[confield];//根据参照公式赋值
					
				}
				
				dgdata.addItem(itemobj);
			}
			consultDg.dataProvider = dgdata;
			break;
		}
	}
	
}
//YJ Add 解析参照赋值公式,参数：oriExp(原始参照赋值公式)  例：A=a,B=b
private function onAnalysisExp(oriExp:String):Array{
	//返回值
	var reArr:Array = new Array();
	
	reArr = oriExp.split(",");
	
	return reArr;
}

//移除记录集中（subflag=1）的记录
private function onRemoveData(arr:ArrayCollection):ArrayCollection{
	var dataArr:ArrayCollection = new ArrayCollection();
	dataArr.addAll(arr);
	
	for(var i:int=0;i<dataArr.length;i++){
		var objitem:Object = {};
		objitem = dataArr.getItemAt(i);
		
		if(!objitem.hasOwnProperty("subflag")) continue;
		
		if(objitem.subflag == 1){
			dataArr.removeItemAt(i);
			i--;
		}
	}
	
	return dataArr;
	
}



